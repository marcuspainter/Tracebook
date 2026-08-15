//
//  BubbleAPI.swift
//  Tracebook
//
//  Created by Marcus Painter on 12/07/2025.
//

import Foundation
import Network

enum BubbleAPIError: Error {
    case httpError(Int)
    case jsonError(Error)
}

final class BubbleAPI: Sendable {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // Get an item response
    func getItemResponse<T: BubbleItemResponseProtocol>(_ type: T.Type, for request: BubbleRequest) async throws -> T? {
        let urlRequest = request.urlRequest()
        let (jsonData, urlResponse) = try await session.data(for: urlRequest)
        
        // Cast to HTTPURLResponse to get status code
        if let httpResponse = urlResponse as? HTTPURLResponse {
            guard (200...299).contains(httpResponse.statusCode) else {
                throw BubbleAPIError.httpError(httpResponse.statusCode)
            }
        }

        do {
            return try JSONDecoder().decode(type, from: jsonData)
        } catch {
            throw BubbleAPIError.jsonError(error)
        }
    }

    // Get a list response
    func getListResponse<T: BubbleListResponseProtocol>(_ type: T.Type, for request: BubbleRequest) async throws -> T? {
        let urlRequest = request.urlRequest()
        let (jsonData, urlResponse) = try await session.data(for: urlRequest)

        // Cast to HTTPURLResponse to get status code
        if let httpResponse = urlResponse as? HTTPURLResponse {
            guard (200...299).contains(httpResponse.statusCode) else {
                throw BubbleAPIError.httpError(httpResponse.statusCode)
            }
        }

        do {
            return try JSONDecoder().decode(type, from: jsonData)
        } catch {
            throw BubbleAPIError.jsonError(error)
        }
    }

    func getListResponseLong<T: BubbleListResponseProtocol>(
        _ type: T.Type,
        for initialRequest: BubbleRequest,
        pageSize: Int = 100
    ) async throws -> [T] {
        var responses: [T] = []
        var request = initialRequest
        request.limit = pageSize

        while true {
            guard let response = try await getListResponse(type, for: request) else {
                break
            }

            responses.append(response)

            if response.response.remaining > 0 && response.response.count > 0 {
                let newCursor: Int? = response.response.cursor + response.response.count
                request.cursor = newCursor
            } else {
                break
            }
        }

        return responses
    }
}
