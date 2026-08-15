import Foundation
import SwiftData
import Testing
@testable import Tracebook

@Suite
@MainActor
struct TracebookStoreTests {
    @Test
    func batchInsertPersistsEveryItemInOneOperation() throws {
        let store = makeStore()

        try store.insertMeasurementItems([
            MeasurementItem(id: "one"),
            MeasurementItem(id: "two"),
            MeasurementItem(id: "three")
        ])

        #expect(Set(try store.fetchMeasurementItems().map(\.id)) == ["one", "two", "three"])
    }

    @Test
    func deleteAllOfflineDataRemovesItemsAndContentAndStoreRemainsUsable() throws {
        let store = makeStore()
        let item = MeasurementItem(id: "measurement", additionalContent: "content")
        item.content = MeasurementContent(id: "content")
        try store.insertMeasurementItem(measurement: item)

        try store.deleteAllOfflineData()

        #expect(try store.fetchMeasurementItems().isEmpty)
        #expect(try store.context.fetch(FetchDescriptor<MeasurementContent>()).isEmpty)

        try store.insertMeasurementItem(measurement: MeasurementItem(id: "replacement"))
        #expect(try store.fetchMeasurementItems().map(\.id) == ["replacement"])
    }

    private func makeStore() -> TracebookStore {
        TracebookStore(
            configuration: ModelConfiguration(UUID().uuidString, isStoredInMemoryOnly: true)
        )
    }
}
