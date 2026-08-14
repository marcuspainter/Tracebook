//
//  BubbleListResponseProtocol.swift
//  Tracebook
//
//  Created by Marcus Painter on 13/07/2025.
//

@MainActor
protocol BubbleListResponseProtocol: Codable {
    associatedtype ItemType: Codable
    var response: BubbleListResultsResponse<ItemType> { get }
}
