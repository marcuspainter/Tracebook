import Foundation
import Testing
import UIKit
@testable import Tracebook

@Suite(.serialized)
@MainActor
struct NetworkAndThumbnailTests {
    @Test
    func offlineClassifierOnlyRecognizesConnectivityFailures() {
        #expect(URLError(.notConnectedToInternet).isOfflineConnectivityFailure)
        #expect(URLError(.networkConnectionLost).isOfflineConnectivityFailure)
        #expect(!URLError(.badServerResponse).isOfflineConnectivityFailure)
        #expect(!StubNetworkError.invalidData.isOfflineConnectivityFailure)
    }

    @Test
    func measurementPaginationAdvancesCursorUntilComplete() async throws {
        URLProtocolStub.requestCount = 0
        URLProtocolStub.requestedCursors = []
        URLProtocolStub.requestHandler = Self.paginationResponse

        let api = TracebookAPI(bubbleAPI: BubbleAPI(session: makeSession()))
        var receivedIDs: [String] = []
        try await api.forEachMeasurementPage(modifiedAfter: nil, createdBefore: nil) {
            receivedIDs += $0.map(\.id)
        }

        #expect(receivedIDs == ["one", "two", "three"])
        #expect(URLProtocolStub.requestCount == 2)
        #expect(URLProtocolStub.requestedCursors == [nil, "2"])
    }

    @Test
    func thumbnailUsesDiskAfterFirstDownloadAndResetClearsIt() async throws {
        URLProtocolStub.requestCount = 0
        let imageData = try #require(makeImageData())
        URLProtocolStub.requestHandler = Self.imageResponse(data: imageData)

        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        defer { try? FileManager.default.removeItem(at: directory) }

        let firstStore = ThumbnailStore(session: makeSession(), directoryURL: directory)
        #expect(await firstStore.image(for: "measurement", remotePath: "https://example.com/image.png") != nil)
        #expect(URLProtocolStub.requestCount == 1)
        #expect(try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil).count == 1)

        let secondStore = ThumbnailStore(session: makeSession(), directoryURL: directory)
        #expect(await secondStore.image(for: "measurement", remotePath: "https://example.com/image.png") != nil)
        #expect(URLProtocolStub.requestCount == 1)

        try await secondStore.removeAll()
        #expect(try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil).isEmpty)
    }

    @Test
    func resetPreventsInFlightThumbnailFromRepopulatingCache() async throws {
        let imageData = try #require(makeImageData())
        URLProtocolStub.requestHandler = Self.delayedImageResponse(data: imageData)

        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        defer { try? FileManager.default.removeItem(at: directory) }

        let store = ThumbnailStore(session: makeSession(), directoryURL: directory)
        let download = Task {
            await store.image(for: "measurement", remotePath: "https://example.com/slow.png")
        }
        try await Task.sleep(for: .milliseconds(10))
        try await store.removeAll()

        #expect(await download.value == nil)
        #expect(try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil).isEmpty)
    }

    nonisolated private static func paginationResponse(
        for request: URLRequest
    ) throws -> (HTTPURLResponse, Data) {
        let cursor = request.url.flatMap {
            URLComponents(url: $0, resolvingAgainstBaseURL: false)
        }?
            .queryItems?.first(where: { $0.name == "cursor" })?.value
        URLProtocolStub.requestedCursors.append(cursor)
        let payload: [String: Any]
        if cursor == nil {
            payload = page(cursor: 0, remaining: 1, ids: ["one", "two"])
        } else {
            payload = page(cursor: 2, remaining: 0, ids: ["three"])
        }
        return response(for: request, json: payload)
    }

    nonisolated private static func imageResponse(
        data: Data
    ) -> @Sendable (URLRequest) throws -> (HTTPURLResponse, Data) {
        { request in
            response(for: request, data: data, contentType: "image/png")
        }
    }

    nonisolated private static func delayedImageResponse(
        data: Data
    ) -> @Sendable (URLRequest) throws -> (HTTPURLResponse, Data) {
        { request in
            Thread.sleep(forTimeInterval: 0.05)
            return response(for: request, data: data, contentType: "image/png")
        }
    }

    nonisolated private static func page(cursor: Int, remaining: Int, ids: [String]) -> [String: Any] {
        [
            "response": [
                "cursor": cursor,
                "results": ids.map { ["_id": $0, "Public": true] },
                "count": ids.count,
                "remaining": remaining
            ]
        ]
    }

    nonisolated private static func response(
        for request: URLRequest,
        json: [String: Any]
    ) -> (HTTPURLResponse, Data) {
        let data = try! JSONSerialization.data(withJSONObject: json)
        return response(for: request, data: data, contentType: "application/json")
    }

    nonisolated private static func response(
        for request: URLRequest,
        data: Data,
        contentType: String
    ) -> (HTTPURLResponse, Data) {
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": contentType]
        )!
        return (response, data)
    }

    private func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        return URLSession(configuration: configuration)
    }

    private func makeImageData() -> Data? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20))
        return renderer.image { context in
            UIColor.red.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 20, height: 20))
        }.pngData()
    }
}

private enum StubNetworkError: Error {
    case invalidData
}

private final class URLProtocolStub: URLProtocol, @unchecked Sendable {
    nonisolated(unsafe) static var requestHandler: (@Sendable (URLRequest) throws -> (HTTPURLResponse, Data))?
    nonisolated(unsafe) static var requestCount = 0
    nonisolated(unsafe) static var requestedCursors: [String?] = []

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        Self.requestCount += 1
        do {
            let handler = try #require(Self.requestHandler)
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
