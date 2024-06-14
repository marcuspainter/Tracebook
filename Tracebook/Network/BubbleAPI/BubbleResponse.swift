//
//  BubbleRequest.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/02/2024.
//

import Foundation

typealias CodableSendable = Codable & Sendable

struct BubbleItemResponse<T: CodableSendable>: CodableSendable {
    let response: T
}

struct BubbleListResponse<T: CodableSendable>: CodableSendable {
    let response: BubbleListBody<T>
}

struct BubbleListBody<T: CodableSendable>: CodableSendable{
    let cursor: Int
    let results: [T]
    let count: Int
    let remaining: Int
}
