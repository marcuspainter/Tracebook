//
//  ErrorResponse.swift
//  Tracebook
//
//  Created by Marcus Painter on 21/12/2023.
//

import Foundation

// MARK: - ErrorResponse
struct ErrorResponse: Codable {
    let statusCode: Int
    let body: ErrorBody
}

// MARK: - ErrorBody
struct ErrorBody: Codable {
    let status: String
    let message: String
}
