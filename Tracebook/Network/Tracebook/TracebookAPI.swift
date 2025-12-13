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

final class TracebookAPI: Sendable {
    private let bubbleAPI = BubbleAPI()
    
    func getMeasurementContent(id: String) async throws -> MeasurementContentBody? {
        let bubbleRequest = BubbleRequest(entity: "measurementcontent", id: id)
        
        let response = try await bubbleAPI.getItemResponse(MeasurementContentItemResponse.self, for: bubbleRequest)
        return response?.response
    }
    
    func getMeasurementLong(from: String? = nil) async throws -> [MeasurementBody] {
        var bubbleRequest = BubbleRequest(entity: "measurement")
        
        let fromDate = from ?? "2000-01-01T00:00:00Z"
        
        bubbleRequest.constraints.append(BubbleConstraint(key: MeasurementBody.CodingKeys.createdDate.rawValue, type: .greaterThan, value: fromDate))
        bubbleRequest.constraints.append(BubbleConstraint(key: MeasurementBody.CodingKeys.isPublic.rawValue, type: .equals, value: "true"))
        bubbleRequest.sortKeys.append(BubbleSortKey(sortField: MeasurementBody.CodingKeys.createdDate.rawValue, order: .descending))
        
        let responses = try await bubbleAPI.getListResponseLong(MeasurementListResponse.self, for: bubbleRequest)
        
        var items = [MeasurementBody]()
        for response in responses {
            let results: [MeasurementBody] = response.response.results
            items += results
            //print(results.first?.title)
        }
        return items
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
            //print(results.first?.micBrandModel)
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
            //print(results.first?.brandModel)
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
            //print(results.first?.brandModel)
        }
        return items
    }
    
    func getUser(id: String) async throws -> UserBody? {
        let bubbleRequest = BubbleRequest(entity: "user", id: id)
        
        let response = try await bubbleAPI.getItemResponse(UserItemResponse.self, for: bubbleRequest)
        
        return response?.response
    }
}
