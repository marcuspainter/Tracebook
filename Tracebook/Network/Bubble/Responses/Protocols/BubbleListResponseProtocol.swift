//
//  BubbleListResponseProtocol.swift
//  TracebookDB
//
//  Created by Marcus Painter on 13/07/2025.
//

protocol BubbleListResponseProtocol: Codable {
    associatedtype ItemType: Codable
    var response: BubbleListResultsResponse<ItemType> { get }
}
