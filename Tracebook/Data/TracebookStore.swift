//
//  TracebookStore.swift
//  Tracebook
//
//  Created by Marcus Painter on 10/07/2025.
//

import Foundation
import Observation
import SwiftData

class TracebookStore {
    let container: ModelContainer
    let context: ModelContext

    init(configuration: ModelConfiguration? = nil) {
        do {
            let schema = Schema([MeasurementItem.self, MeasurementContent.self])
            if let configuration {
                container = try ModelContainer(for: schema, configurations: [configuration])
            } else {
                container = try ModelContainer(for: schema)
            }
            context = ModelContext(container)
        } catch {
            print(error)
            fatalError("Failed to create database.")
        }
    }

    // MARK: Save

    func save() throws {
        try context.save()
    }

    // MARK: Fetch

    // Fetch filtered by title
    func fetchFiltered(searchText: String) throws -> [MeasurementItem] {
        let predicate = #Predicate<MeasurementItem> { item in
            item.title.localizedStandardContains(searchText)
        }

        let descriptor = FetchDescriptor<MeasurementItem>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.createdDate, order: .reverse)]
        )
        return try context.fetch(descriptor)

    }
    
    func fetchNoContent() throws -> [MeasurementItem] {
        let predicate = #Predicate<MeasurementItem> { item in
            item.content == nil
        }
        let descriptor = FetchDescriptor<MeasurementItem>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.createdDate, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    func fetchMeasurementItem(id: String) throws -> MeasurementItem? {
        var descriptor = FetchDescriptor<MeasurementItem>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }

    func fetchFirstMeasurementItem() throws -> MeasurementItem? {
        var descriptor = FetchDescriptor<MeasurementItem>(sortBy: [.init(\.createdDate, order: .reverse)])
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }

    func fetchMostRecentlyModifiedMeasurementItem() throws -> MeasurementItem? {
        var descriptor = FetchDescriptor<MeasurementItem>(
            predicate: #Predicate { $0.modifiedDate != nil },
            sortBy: [.init(\.modifiedDate, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }

    func fetchLastMeasurementItem() throws -> MeasurementItem? {
        var descriptor = FetchDescriptor<MeasurementItem>(sortBy: [.init(\.createdDate, order: .forward)])
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }

    // MARK: List

    func fetchMeasurementItems() throws -> [MeasurementItem] {
        let descriptor = FetchDescriptor<MeasurementItem>(sortBy: [.init(\.createdDate, order: .reverse)])
        return try context.fetch(descriptor)
    }

    // MARK: Insert

    func insertMeasurementItem(measurement: MeasurementItem) throws {
        context.insert(measurement)
        try context.save()
    }

    func deleteAllOfflineData() throws {
        try context.delete(model: MeasurementItem.self)
        try context.delete(model: MeasurementContent.self)
        try context.save()
    }

    // MARK: Delete

    func deleteMeasurementItem(id: String) throws {
        let model = try fetchMeasurementItem(id: id)
        if let model {
            context.delete(model)
            try context.save()
        }
    }
}
