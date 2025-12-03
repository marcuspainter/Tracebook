//
//  BubbleListResultsResponse.swift
//  TracebookDB
//
//  Created by Marcus Painter on 08/07/2025.
//

struct BubbleListResultsResponse<T: Codable>: Codable {
    let cursor: Int
    let results: [T]
    let count: Int
    let remaining: Int
}
