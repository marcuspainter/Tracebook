//
//  BubbleItemResponseProtocol.swift
//  Tracebook
//
//  Created by Marcus Painter on 12/07/2025.
//

@MainActor
protocol BubbleItemResponseProtocol: Codable {
    associatedtype ItemType: Codable
    var response: ItemType { get }
}
