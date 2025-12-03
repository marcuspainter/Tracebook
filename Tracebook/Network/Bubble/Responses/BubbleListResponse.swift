//
//  BubbleListResponse.swift
//  TracebookDB
//
//  Created by Marcus Painter on 08/07/2025.
//

struct BubbleListResponse<T: Codable>: BubbleListResponseProtocol {
    let response: BubbleListResultsResponse<T>
}
