//
//  TracebookService.swift
//  Tracebook
//
//  Created by Marcus Painter on 25/11/2025.
//

import Foundation

@Observable
@MainActor
final class TracebookService: Sendable {
    private(set) var api: TracebookAPI
    private(set) var store: TracebookStore
    
    private var microphones: [String:String] = [:]
    private var analyzers: [String:String] = [:]
    private var interfaces: [String:String] = [:]
    private var synchronizationTask: Task<Void, Never>?
    private var thumbnailPrefetchTask: Task<Void, Never>?
    private var contentSynchronizationTasks: [String: Task<Void, Error>] = [:]
    private(set) var isSynchronizing = false
    private(set) var offlineDataRevision = 0

    init() {
        self.api = TracebookAPI()
        self.store = TracebookStore()
    }

    private func fetchMostRecentModificationDate() -> Date? {
        let item = try? store.fetchMostRecentlyModifiedMeasurementItem()
        return item?.modifiedDate
    }

    private func fetchLastMeasurementDate() -> Date? {
        let item = try? store.fetchLastMeasurementItem()
        return item?.createdDate
    }

    private func getFirstMeasurementDate() async throws -> Date? {
        guard let body = try await api.getLastMeasurement() else { return nil }
        return MeasurementItemMapper.toModel(body: body).createdDate
    }

    func synchronize(onPageInserted: (() -> Void)? = nil) async {
        if let synchronizationTask {
            await synchronizationTask.value
            return
        }

        let task = Task { @MainActor in
            isSynchronizing = true
            defer {
                isSynchronizing = false
                synchronizationTask = nil
            }

            do {
                print("Start items...")
                try await synchronizeMeasurementItems(onPageInserted: onPageInserted)
                print("Done")

                scheduleThumbnailPrefetch()

                onPageInserted?()

                print("Start content...")
                try await synchronizeMeasurementContents()
                print("Done")
            } catch {
                print(error)
            }
        }

        synchronizationTask = task
        await task.value
    }

    private func scheduleThumbnailPrefetch() {
        guard let measurements = try? store.fetchMeasurementItems() else { return }
        let requests = measurements.map {
            ThumbnailRequest(measurementID: $0.id, remotePath: $0.thumbnailImage)
        }

        thumbnailPrefetchTask?.cancel()
        thumbnailPrefetchTask = Task {
            await ThumbnailStore.shared.prefetch(requests)
        }
    }

    func synchronizeMeasurementItems(onPageInserted: (() -> Void)? = nil) async throws {
        var fromDate: String = "2010-01-01T00:00:00Z"
        if let date1 = fetchMostRecentModificationDate() {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            fromDate = formatter.string(from: date1)
        }
        print(fromDate)

        try await api.forEachMeasurementPage(modifiedAfter: fromDate) { measurements in
            try upsertMeasurementItems(measurements)
            onPageInserted?()
        }
        try await backfillMeasurementItems(onPageInserted: onPageInserted)
    }

    func resetOfflineData() async throws {
        let activeSynchronizationTask = synchronizationTask
        activeSynchronizationTask?.cancel()

        let activeContentTasks = Array(contentSynchronizationTasks.values)
        activeContentTasks.forEach { $0.cancel() }

        let activeThumbnailPrefetchTask = thumbnailPrefetchTask
        activeThumbnailPrefetchTask?.cancel()

        await activeSynchronizationTask?.value
        for task in activeContentTasks {
            _ = try? await task.value
        }
        await activeThumbnailPrefetchTask?.value
        contentSynchronizationTasks.removeAll()
        thumbnailPrefetchTask = nil

        try store.deleteAllOfflineData()
        try await ThumbnailStore.shared.removeAll()
        offlineDataRevision += 1
    }

    private func backfillMeasurementItems(onPageInserted: (() -> Void)? = nil) async throws {
        guard let date = fetchLastMeasurementDate() else { return }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let beforeDate = formatter.string(from: date)
        print("Backfill before \(beforeDate)")

        try await api.forEachMeasurementPage(createdBefore: beforeDate) { measurements in
            try upsertMeasurementItems(measurements)
            onPageInserted?()
        }
    }

    private func upsertMeasurementItems(_ measurements: [MeasurementBody]) throws {
        for measurement in measurements {
            if let existingModel = try store.fetchMeasurementItem(id: measurement.id) {
                MeasurementItemMapper.update(model: existingModel, from: measurement)
                try store.save()
                print("Update \(existingModel.title)")
            } else {
                let model = MeasurementItemMapper.toModel(body: measurement)
                print(model.title)
                try store.insertMeasurementItem(measurement: model)
            }
        }
    }

    func synchronizeDetails() async throws {
        async let newMicrophones = getMicrophones()
        async let newAnalyzers = getAnalyzers()
        async let newInterfaces = getInterfaces()

        (microphones, analyzers, interfaces) = try await (newMicrophones, newAnalyzers, newInterfaces)
    }
    
    func synchronizeMeasurementContents() async throws {
        do {
            
            try await synchronizeDetails()
            
            let items = try store.fetchNoContent()
            for item in items {
                try Task.checkCancellation()
                print(item.title, item.additionalContent)
                
                try await synchronizeMeasurementItemContent(item: item)
            }
        }
    }
    
    func synchronizeMeasurementItemContent(item: MeasurementItem) async throws {
        guard item.content == nil, !item.additionalContent.isEmpty else { return }

        if let existingTask = contentSynchronizationTasks[item.id] {
            try await existingTask.value
            return
        }

        let task = Task { @MainActor in
            if microphones.isEmpty || analyzers.isEmpty || interfaces.isEmpty {
                try await synchronizeDetails()
            }
            try await downloadMeasurementItemContent(item: item)
        }
        contentSynchronizationTasks[item.id] = task

        do {
            try await task.value
            contentSynchronizationTasks[item.id] = nil
        } catch {
            contentSynchronizationTasks[item.id] = nil
            throw error
        }
    }

    private func downloadMeasurementItemContent(item: MeasurementItem) async throws {
        if let contentBody = try await api.getMeasurementContent(id: item.additionalContent) {
            if let content = MeasurementContentMapper.toModel(body: contentBody) {

                content.microphoneText = microphones[content.microphone] ?? ""
                content.analyzerText = analyzers[content.analyzer] ?? ""
                content.interfaceText = interfaces[content.interface] ?? ""

                item.content = content

                try store.save()
            }
        }
    }
    
    func getMicrophones() async throws -> [String: String] {
        var dictionary = [String: String]()
        let list = try await api.getMicrophones()
        for item in list {
            dictionary[item.id] = item.brandModel ?? ""
        }
        return dictionary
    }

    func getAnalyzers() async throws -> [String: String] {
        var dictionary = [String: String]()
        let list = try await api.getAnalyzers()
        for item in list {
            dictionary[item.id] = item.name ?? ""
        }
        return dictionary
    }

    func getInterfaces() async throws -> [String: String] {
        var dictionary = [String: String]()
        let list = try await api.getInterfaces()
        for item in list {
            dictionary[item.id] = item.brandModel ?? ""
        }
        return dictionary
    }
}
