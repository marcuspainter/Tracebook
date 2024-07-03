//
//  BubbleAPI.swift
//  Tracebook
//
//  Created by Marcus Painter on 30/06/2024.
//

import Foundation

protocol BubbleAPIProtocol: Sendable {
    func getResponse<T: Decodable>(_ type: T.Type, for request: URLRequest) async throws -> T?
}
