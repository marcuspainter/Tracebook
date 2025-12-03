//
//  BubbleItemResponse.swift
//  TracebookDB
//
//  Created by Marcus Painter on 07/02/2024.
//

struct BubbleItemResponse<T: Codable>: BubbleItemResponseProtocol {
    let response: T
}
