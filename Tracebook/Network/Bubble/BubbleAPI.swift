//
//  BubbleAPI.swift
//  Tracebook
//
//  Created by Marcus Painter on 30/06/2024.
//

import Foundation

final class BubbleAPI: BubbleAPIProtocol, Sendable {
    
    func getResponse<T: Decodable>(_ type: T.Type, for request: URLRequest) async throws -> T? {
        do {
            let (jsonData, response) = try await URLSession.shared.data(for: request)

            // Cast to get status code
            guard let httpResponse = response as? HTTPURLResponse else {
                throw BubbleAPIError.networkError
            }

            // HTTP status code
            let status = httpResponse.statusCode
            if status < 200 || status > 299 {
                throw BubbleAPIError.networkError
            }

            // Parse JSON
            let jsonResponse = try JSONDecoder().decode(type, from: jsonData)
            return jsonResponse

        } catch {
            print("Request error: \(error)")
            throw BubbleAPIError.networkError
        }
    }
}
