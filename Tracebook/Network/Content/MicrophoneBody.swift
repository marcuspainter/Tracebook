//
//  Microphone.swift
//  Tracebook
//
//  Created by Marcus Painter on 10/02/2024.
//

import Foundation

struct MicrophoneBody: Codable {
    let micBrandModel: String?
    let createdBy: String?
    let createdDate: String?
    let modifiedDate: String?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case micBrandModel = "Mic brand+model"
        case createdBy = "Created By"
        case createdDate = "Created Date"
        case modifiedDate = "Modified Date"
        case id = "_id"
    }
}
