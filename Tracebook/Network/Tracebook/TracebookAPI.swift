//
//  MeasurementAPI.swift
//  Tracebook
//
//  Created by Marcus Painter on 25/11/2025.
//

import Foundation
import Network

typealias MeasurementListResponse = BubbleListResponse<MeasurementBody>
typealias MeasurementContentItemResponse = BubbleItemResponse<MeasurementContentBody>
typealias MicrophoneListResponse = BubbleListResponse<MicrophoneBody>
typealias AnalyzerListResponse = BubbleListResponse<AnalyzerBody>
typealias InterfaceListResponse = BubbleListResponse<InterfaceBody>

// Future
typealias UserItemResponse = BubbleItemResponse<UserBody>
typealias UserListResponse = BubbleListResponse<UserBody>

@MainActor
protocol TracebookAPIClient: Sendable {
    func getMeasurementContent(id: String) async throws -> MeasurementContentBody?
    func forEachMeasurementPage(
        modifiedAfter: String?,
        createdBefore: String?,
        _ handlePage: ([MeasurementBody]) throws -> Void
    ) async throws
    func getLastMeasurement() async throws -> MeasurementBody?
    func getMicrophones() async throws -> [MicrophoneBody]
    func getInterfaces() async throws -> [InterfaceBody]
    func getAnalyzers() async throws -> [AnalyzerBody]
}

final class TracebookAPI: TracebookAPIClient, Sendable {
    private let bubbleAPI: BubbleAPI

    init(bubbleAPI: BubbleAPI = BubbleAPI()) {
        self.bubbleAPI = bubbleAPI
    }
    
    func getMeasurementContent(id: String) async throws -> MeasurementContentBody? {
        let bubbleRequest = BubbleRequest(entity: "measurementcontent", id: id)
        
        let response = try await bubbleAPI.getItemResponse(MeasurementContentItemResponse.self, for: bubbleRequest)
        return response?.response
    }
    
    func getMeasurementLong(from: String? = nil, before: String? = nil) async throws -> [MeasurementBody] {
        var items = [MeasurementBody]()

        try await forEachMeasurementPage(modifiedAfter: from, createdBefore: before) { page in
            items += page
        }

        return items
    }

    func forEachMeasurementPage(
        modifiedAfter: String? = nil,
        createdBefore: String? = nil,
        _ handlePage: ([MeasurementBody]) throws -> Void
    ) async throws {
        var bubbleRequest = BubbleRequest(entity: "measurement")
        
        if let modifiedAfter {
            bubbleRequest.constraints.append(BubbleConstraint(key: MeasurementBody.CodingKeys.modifiedDate.rawValue, type: .greaterThan, value: modifiedAfter))
        }
        if let createdBefore {
            bubbleRequest.constraints.append(BubbleConstraint(key: MeasurementBody.CodingKeys.createdDate.rawValue, type: .lessThan, value: createdBefore))
        }
        bubbleRequest.constraints.append(BubbleConstraint(key: MeasurementBody.CodingKeys.isPublic.rawValue, type: .equals, value: "true"))
        let sortField = modifiedAfter == nil
            ? MeasurementBody.CodingKeys.createdDate.rawValue
            : MeasurementBody.CodingKeys.modifiedDate.rawValue
        let sortOrder: BubbleSortKeyOrder = modifiedAfter == nil ? .descending : .ascending
        bubbleRequest.sortKeys.append(BubbleSortKey(sortField: sortField, order: sortOrder))

        while true {
            guard let response = try await bubbleAPI.getListResponse(MeasurementListResponse.self, for: bubbleRequest) else {
                break
            }

            let results: [MeasurementBody] = response.response.results
            try handlePage(results)

            if response.response.remaining > 0 && response.response.count > 0 {
                bubbleRequest.cursor = response.response.cursor + response.response.count
            } else {
                break
            }
        }
    }
    
    func getLastMeasurement() async throws -> MeasurementBody? {
        var bubbleRequest = BubbleRequest(entity: "measurement")
        let fromDate = "2010-01-01T00:00:00Z"
        bubbleRequest.constraints.append(BubbleConstraint(key: MeasurementBody.CodingKeys.isPublic.rawValue, type: .equals, value: "true"))
        bubbleRequest.constraints.append(BubbleConstraint(key: MeasurementBody.CodingKeys.createdDate.rawValue, type: .greaterThan, value: fromDate))
        bubbleRequest.sortKeys.append(BubbleSortKey(sortField: MeasurementBody.CodingKeys.createdDate.rawValue, order: .descending))
        bubbleRequest.limit = 1
        
        let response = try await bubbleAPI.getListResponse(MeasurementListResponse.self, for: bubbleRequest)
        
        let items = response?.response.results ?? []
        return items.first
    }
    
    func getMicrophones() async throws -> [MicrophoneBody] {
        var bubbleRequest = BubbleRequest(entity: "microphone")
        let fromDate = "2000-01-01T00:00:00Z"
        bubbleRequest.constraints.append(BubbleConstraint(key: MicrophoneBody.CodingKeys.createdDate.rawValue, type: .greaterThan, value: fromDate))
        bubbleRequest.sortKeys.append(BubbleSortKey(sortField: MicrophoneBody.CodingKeys.createdDate.rawValue, order: .descending))
        
        let responses = try await bubbleAPI.getListResponseLong(MicrophoneListResponse.self, for: bubbleRequest)
        
        var items = [MicrophoneBody]()
        for response in responses {
            let results: [MicrophoneBody] = response.response.results
            items += results
        }
        return items
    }
    
    func getInterfaces() async throws -> [InterfaceBody] {
        var bubbleRequest = BubbleRequest(entity: "interface")
        let fromDate = "2000-01-01T00:00:00Z"
        bubbleRequest.constraints.append(BubbleConstraint(key: InterfaceBody.CodingKeys.createdDate.rawValue, type: .greaterThan, value: fromDate))
        bubbleRequest.sortKeys.append(BubbleSortKey(sortField: InterfaceBody.CodingKeys.createdDate.rawValue, order: .descending))
        
        let responses = try await bubbleAPI.getListResponseLong(InterfaceListResponse.self, for: bubbleRequest)
        
        var items = [InterfaceBody]()
        for response in responses {
            let results: [InterfaceBody] = response.response.results
            items += results
        }
        return items
    }
    
    func getAnalyzers() async throws -> [AnalyzerBody] {
        var bubbleRequest = BubbleRequest(entity: "analyzer")
        let fromDate = "2000-01-01T00:00:00Z"
        bubbleRequest.constraints.append(BubbleConstraint(key: InterfaceBody.CodingKeys.createdDate.rawValue, type: .greaterThan, value: fromDate))
        bubbleRequest.sortKeys.append(BubbleSortKey(sortField: InterfaceBody.CodingKeys.createdDate.rawValue, order: .descending))
        
        let responses = try await bubbleAPI.getListResponseLong(AnalyzerListResponse.self, for: bubbleRequest)
        
        var items = [AnalyzerBody]()
        for response in responses {
            let results: [AnalyzerBody] = response.response.results
            items += results
        }
        return items
    }
    
    func getUser(id: String) async throws -> UserBody? {
        let bubbleRequest = BubbleRequest(entity: "user", id: id)
        
        let response = try await bubbleAPI.getItemResponse(UserItemResponse.self, for: bubbleRequest)
        
        return response?.response
    }
}
