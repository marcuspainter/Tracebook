//
//  BubbleErrorResponse.swift
//  TracebookDB
//
//  Created by Marcus Painter on 10/02/2024.
//

struct BubbleErrorResponse: Codable {
    let statusCode: Int
    let body: BubbleErrorBody
}
