//
//  BubbleRequest.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/02/2024.
//

import Foundation

struct BubbleItemResponse<T: Codable & Sendable>: Codable & Sendable {
    let response: T
}

struct BubbleListResponse<T: Codable & Sendable>: Codable & Sendable {
    let response: BubbleListBody<T>
}

struct BubbleListBody<T: Codable & Sendable>: Codable & Sendable  {
    let cursor: Int
    let results: [T]
    let count: Int
    let remaining: Int
}
