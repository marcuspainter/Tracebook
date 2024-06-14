//
//  BubbleRequest.swift
//  TracebookMV
//
//  Created by Marcus Painter on 11/02/2024.
//

import Foundation

// id
// cursor
// limit
// constraints
//
// [ { "key": "unitname", "constraint_type": "text contains", "value": "Unit” } ,{ "key": "unitnumber", "constraint_type": "greater than", "value": "3" }]

// sort additional_sort_fields
// [ { "sort_field": "unitname", "descending": "false" } ]

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
        components.path = "/api/1.1/obj/\(entity)"

        if let id = id {
            components.path += "/\(id)"
        }

        if cursor != nil || limit != nil || constraints.count > 0 || sortKeys.count > 0 {
            components.queryItems = []

            if let cursor = cursor {
                let queryItem = URLQueryItem(name: "cursor", value: "\(cursor)")
                components.queryItems?.append(queryItem)
            }

            if let limit = limit {
                let queryItem = URLQueryItem(name: "limit", value: "\(limit)")
                components.queryItems?.append(queryItem)
            }

            if constraints.count > 0 {
                let textArray = constraints.map { $0.description }
                let csvString = textArray.joined(separator: ",")
                let jsonString = "[\(csvString)]"
                let queryItem = URLQueryItem(name: "constraints", value: jsonString)
                components.queryItems?.append(queryItem)
            }

            if sortKeys.count > 0 {
                let textArray = sortKeys.map { $0.description }
                let csvString = textArray.joined(separator: ",")
                let jsonString = "[\(csvString)]"
                let queryItem = URLQueryItem(name: "additional_sort_fields", value: jsonString)
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
