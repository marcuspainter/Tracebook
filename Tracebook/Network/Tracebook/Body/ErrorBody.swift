//
//  ErrorBody.swift
//  Tracebook
//
//  Created by Marcus Painter on 25/03/2024.
//

import Foundation

struct BubbleErrorBody: Codable {
    var status: String?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
    }
}
