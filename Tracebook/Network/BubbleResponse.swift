//
//  BubbleRequest.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/02/2024.
//

import Foundation

struct BubbleItemResponse<T: Codable>: Codable {
    let response: T
}

struct BubbleListResponse<T: Codable>: Codable {
    let response: BubbleListBody<T>
}

struct BubbleListBody<T: Codable>: Codable {
    let cursor: Int
    let results: [T]
    let count: Int
    let remaining: Int
}
