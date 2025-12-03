//
//  BubbleAPI.swift
//  TracebookDB
//
//  Created by Marcus Painter on 12/07/2025.
//

import Foundation
import Network

final class BubbleAPI: Sendable {

    // Get an item response
    func getItemResponse<T: BubbleItemResponseProtocol>(_ type: T.Type, for request: BubbleRequest) async -> T? {
        do {
            let urlRequest = request.urlRequest()
            let (jsonData, urlResponse) = try await URLSession.shared.data(for: urlRequest)

            // Cast to HTTPURLResponse to get status code
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("Invalid response type")
                return nil
            }

            if httpResponse.statusCode != 200 {
            }

            let response = try JSONDecoder().decode(type, from: jsonData)

            return response
        } catch {
            print("Request error: \(error)")
        }
        return nil
    }

    // Get a list response
    func getListResponse<T: BubbleListResponseProtocol>(_ type: T.Type, for request: BubbleRequest) async -> T? {
        do {
            let urlRequest = request.urlRequest()
            let (jsonData, urlResponse) = try await URLSession.shared.data(for: urlRequest)

            // Cast to HTTPURLResponse to get status code
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("Invalid response type")
                return nil

            }
            //print("StatusCode: \(httpResponse.statusCode)")

            let response = try JSONDecoder().decode(type, from: jsonData)

            return response
        } catch {
            print("Request error: \(error)")
        }
        return nil
    }

    func getListResponseLong<T: BubbleListResponseProtocol>(
        _ type: T.Type,
        for initialRequest: BubbleRequest,
        pageSize: Int = 100
    ) async -> [T] {
        var responses: [T] = []
        let request = initialRequest

        while true {
            guard let response = await getListResponse(type, for: request) else {
                break
            }

            responses.append(response)
            print("Count: \(response.response.count) Remaining: \(response.response.remaining)")

            if response.response.remaining > 0 {
                let newCursor: Int? = response.response.cursor + pageSize
                request.cursor = newCursor
            } else {
                break
            }
        }

        return responses
    }
}
