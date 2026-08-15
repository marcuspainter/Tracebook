import Foundation
import SwiftData
import Testing
@testable import Tracebook

@Suite
@MainActor
struct TracebookServiceTests {
    @Test
    func simultaneousContentRequestsShareOneAPICall() async throws {
        let api = StubTracebookAPI()
        let store = makeStore()
        let service = TracebookService(api: api, store: store)
        let item = MeasurementItem(id: "measurement", additionalContent: "content")
        try store.insertMeasurementItem(measurement: item)

        let first = Task { @MainActor in
            try await service.synchronizeMeasurementItemContent(item: item)
        }
        let second = Task { @MainActor in
            try await service.synchronizeMeasurementItemContent(item: item)
        }
        try await first.value
        try await second.value

        #expect(api.contentRequestCount == 1)
        #expect(item.content?.id == "content")
    }

    @Test
    func existingContentDoesNotMakeAnotherAPICall() async throws {
        let api = StubTracebookAPI()
        let store = makeStore()
        let service = TracebookService(api: api, store: store)
        let item = MeasurementItem(id: "measurement", additionalContent: "content")
        item.content = MeasurementContent(id: "content")

        try await service.synchronizeMeasurementItemContent(item: item)

        #expect(api.contentRequestCount == 0)
    }

    @Test
    func failedContentRequestCanBeRetried() async throws {
        let api = StubTracebookAPI(failuresRemaining: 1)
        let store = makeStore()
        let service = TracebookService(api: api, store: store)
        let item = MeasurementItem(id: "measurement", additionalContent: "content")

        var firstRequestFailed = false
        do {
            try await service.synchronizeMeasurementItemContent(item: item)
        } catch {
            firstRequestFailed = true
        }

        #expect(firstRequestFailed)
        #expect(item.content == nil)

        try await service.synchronizeMeasurementItemContent(item: item)
        #expect(api.contentRequestCount == 2)
        #expect(item.content?.id == "content")
    }

    private func makeStore() -> TracebookStore {
        TracebookStore(
            configuration: ModelConfiguration(UUID().uuidString, isStoredInMemoryOnly: true)
        )
    }
}

@MainActor
private final class StubTracebookAPI: TracebookAPIClient {
    private(set) var contentRequestCount = 0
    private var failuresRemaining: Int

    init(failuresRemaining: Int = 0) {
        self.failuresRemaining = failuresRemaining
    }

    func getMeasurementContent(id: String) async throws -> MeasurementContentBody? {
        contentRequestCount += 1
        try await Task.sleep(for: .milliseconds(20))
        if failuresRemaining > 0 {
            failuresRemaining -= 1
            throw StubError.requestFailed
        }
        let body = MeasurementContentBody()
        body.id = id
        return body
    }

    func forEachMeasurementPage(
        modifiedAfter: String?,
        createdBefore: String?,
        _ handlePage: ([MeasurementBody]) throws -> Void
    ) async throws {}

    func getLastMeasurement() async throws -> MeasurementBody? { nil }
    func getMicrophones() async throws -> [MicrophoneBody] { [] }
    func getInterfaces() async throws -> [InterfaceBody] { [] }
    func getAnalyzers() async throws -> [AnalyzerBody] { [] }
}

private enum StubError: Error {
    case requestFailed
}
