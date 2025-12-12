//
//  TracebookService.swift
//  TracebookDB
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

    init() {
        self.api = TracebookAPI()
        self.store = TracebookStore()
    }

    private func fetchFirstMeasurementDate() -> Date? {
        let item = try! store.fetchFirstMeasurementItem()
        return item?.createdDate
    }

    private func getFirstMeasurementDate() async throws -> Date? {
        guard let body = try await api.getLastMeasurement() else { return nil }
        return MeasurementItemMapper.toModel(body: body).createdDate
    }

    func synchronizeMeasurementItems() async throws {
        var list = [MeasurementItem]()

        var fromDate: String = "2010-01-01T00:00:00Z"
        if let date1 = fetchFirstMeasurementDate() {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            fromDate = formatter.string(from: date1)
        }
        print(fromDate)

        let measurements = try await api.getMeasurementLong()
        for measurement in measurements {

            do {

                if try store.fetchMeasurementItem(id: measurement.id) != nil {
                    print("Skip \(measurement.title ?? "")")
                    continue
                }

                let model = MeasurementItemMapper.toModel(body: measurement)
                print(model.title)

                try store.insertMeasurementItem(measurement: model)
                list.append(model)
            } catch {
                print("Error: \(error)")
            }
        }
        return
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
            
            let items = try store.fetchMeasurementItems()
            for item in items {

                if item.content != nil {
                    print("Skip \(item.title)")
                    continue
                }
                print(item.title, item.additionalContent)
                
                try await synchronizeMeasurementItemContent(item: item)
            }
        }
    }
    
    func synchronizeMeasurementItemContent(item: MeasurementItem) async throws {
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

    func deleteAllMeasurementItems() {
        do {
            try store.deleteAllMeasurementItems()
        } catch {
            print("Error deleting measurements: \(error)")
        }
    }
    
    func refreshMeasurementItems() async throws {
        deleteAllMeasurementItems()
        try await synchronizeMeasurementItems()
    }
}
