//
//  BubbleRequest.swift
//  TracebookDB
//
//  Created by Marcus Painter on 11/02/2024.
//

import Foundation
import Network

class BubbleRequest {
    var entity: String
    var id: String?
    var cursor: Int?
    var limit: Int?
    var constraints: [BubbleConstraint] = []
    var sortKeys: [BubbleSortKey] = []

    init(entity: String, id: String? = nil) {
        self.entity = entity
        self.id = id
    }

    func urlRequest() -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "trace-book.org"
        components.path = "/api/1.1/obj"
        components.path += "/\(entity)"

        if let id = self.id {
            components.path += "/\(id)"
        }

        if cursor != nil || limit != nil || constraints.count > 0 || sortKeys.count > 0 {
            components.queryItems = []

            if let cursor = self.cursor {
                let queryItem = URLQueryItem(name: "cursor", value: "\(cursor)")
                components.queryItems?.append(queryItem)
            }

            if let limit = self.limit {
                let queryItem = URLQueryItem(name: "limit", value: "\(limit)")
                components.queryItems?.append(queryItem)
            }

            if constraints.count > 0 {
                let textArray = constraints.map { $0.description }
                let csvString = textArray.joined(separator: ",")
                let JSONString = "[" + csvString + "]"
                let queryItem = URLQueryItem(name: "constraints", value: JSONString)
                components.queryItems?.append(queryItem)
            }

            if sortKeys.count > 0 {
                let textArray = sortKeys.map { $0.description }
                let csvString = textArray.joined(separator: ",")
                let JSONString = "[" + csvString + "]"
                let queryItem = URLQueryItem(name: "additional_sort_fields", value: JSONString)
                components.queryItems?.append(queryItem)
            }
        }

        let url = components.url!
        var request = URLRequest(url: url)
        // request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        request.httpMethod = "GET"

        return request
    }

}
