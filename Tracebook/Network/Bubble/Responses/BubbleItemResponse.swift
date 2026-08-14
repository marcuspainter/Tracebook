//
//  BubbleItemResponse.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/02/2024.
//

struct BubbleItemResponse<T: Codable>: @MainActor BubbleItemResponseProtocol {
    let response: T
}
