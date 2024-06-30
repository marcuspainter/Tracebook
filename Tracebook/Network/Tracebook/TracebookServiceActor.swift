//
//  TracebookAPIActor.swift
//  Tracebook
//
//  Created by Marcus Painter on 30/06/2024.
//

import Foundation

actor TracebookServiceActor: TracebookServiceProtocol {
    
    private let bubbleAPI: BubbleAPI
    
    init(bubbleAPI: BubbleAPI = BubbleAPI()) {
        self.bubbleAPI = bubbleAPI
    }
    
    func getUser(id: String) async throws -> UserItemResponse? {
        let bubbleRequest = BubbleRequest(entity: "user")
        let urlRequest = bubbleRequest.makeGetUrlRequest()
        do {
            let response = try await bubbleAPI.getResponse(UserItemResponse.self, for: urlRequest)
            return response
        } catch {
            throw error
        }
    }

    func getAnalyzerList() async throws -> AnalyzerListResponse? {
        let bubbleRequest = BubbleRequest(entity: "analyzer")
        let urlRequest = bubbleRequest.makeGetUrlRequest()
        do {
            let response = try await bubbleAPI.getResponse(AnalyzerListResponse.self, for: urlRequest)
            return response
        } catch {
            throw error
        }
    }

    func getMicrophoneList() async throws -> MicrophoneListResponse? {
        let bubbleRequest = BubbleRequest(entity: "microphone")
        let urlRequest = bubbleRequest.makeGetUrlRequest()
        do {
            let response = try await bubbleAPI.getResponse(MicrophoneListResponse.self, for: urlRequest)
            return response
        } catch {
            throw error
        }
    }

    func getInterfaceList() async throws -> InterfaceListResponse? {
        let bubbleRequest = BubbleRequest(entity: "interface")
        let urlRequest = bubbleRequest.makeGetUrlRequest()
        do {
            let response = try await bubbleAPI.getResponse(InterfaceListResponse.self, for: urlRequest)
            return response
        } catch {
            throw error
        }
    }

    func getMeasurementContent(id: String) async throws -> MeasurementContentItemResponse? {
        let bubbleRequest = BubbleRequest(entity: "measurementcontent", id: id)
        let urlRequest = bubbleRequest.makeGetUrlRequest()
        do {
            let response = try await bubbleAPI.getResponse(MeasurementContentItemResponse.self, for: urlRequest)
            return response
        } catch {
            throw error
        }
    }

    func getMeasurementListByDate(cursor: Int = 0, dateString: String) async throws -> MeasurementListResponse? {
        print(dateString)

        let bubbleRequest = BubbleRequest(entity: "measurement")
        bubbleRequest.cursor = cursor
        bubbleRequest.constraints.append(
            BubbleConstraint(key: MeasurementBody.CodingKeys.isPublic.rawValue, type: .equals, value: "true"))
        bubbleRequest.constraints.append(
            BubbleConstraint(key: MeasurementBody.CodingKeys.createdDate.rawValue, type: .greaterThan, value: dateString))
        bubbleRequest.sortKeys.append(
            BubbleSortKey(sortField: MeasurementBody.CodingKeys.createdDate.rawValue, order: .descending))

        let urlRequest = bubbleRequest.makeGetUrlRequest()
        print(urlRequest.mainDocumentURL as Any)
        do {
            let response = try await bubbleAPI.getResponse(MeasurementListResponse.self, for: urlRequest)
            return response
        } catch {
            throw error
        }
    }
    
}
