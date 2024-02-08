//
//  BubbleRequest.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/02/2024.
//

import Foundation

struct BubbleItemResponse<T: Codable> : Codable {
    let response: T
}

struct BubbleListResponse<T: Codable> : Codable {
    let cursor: Int
    let results: [T]
    let count: Int
    let remaining: Int
}

struct BubbleErrorResponse: Codable {
    let statusCode: Int
    let body: BubbleErrorBody
}

struct BubbleErrorBody: Codable {
    let status: String
    let message: String
}

class BubbleExample {
    var a: BubbleItemResponse<ExampleContent>?
    var b: BubbleListResponse<ExampleContent>?
    
    init() {
        let _ = a?.response.name
        let _ = b?.results[0].name
    }
}

struct ExampleContent : Codable {
    let name: String?
}
