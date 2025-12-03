//
//  BubbleResponse.swift
//  TracebookDB
//
//  Created by Marcus Painter on 12/07/2025.
//

protocol BubbleItemResponseProtocol: Codable {
    associatedtype ItemType: Codable
    var response: ItemType { get }
}
