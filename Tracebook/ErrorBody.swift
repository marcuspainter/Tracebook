//
//  ErrorBody.swift
//  Tracebook
//
//  Created by Marcus Painter on 25/03/2024.
//

import Foundation

struct BubbleErrorBody: Codable, Sendable {
    let status: String?
    let message: String?
}
