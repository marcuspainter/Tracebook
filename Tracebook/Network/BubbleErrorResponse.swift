//
//  BubbleError.swift
//  Tracebook
//
//  Created by Marcus Painter on 10/02/2024.
//

import Foundation

struct BubbleErrorResponse: Codable {
    let statusCode: Int
    let body: BubbleErrorBody
}
