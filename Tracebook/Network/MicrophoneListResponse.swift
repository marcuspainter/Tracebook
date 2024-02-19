//
//  MicrophoneRespone.swift
//  Tracebook
//
//  Created by Marcus Painter on 21/12/2023.
//

import Foundation

// MARK: - MicrophoneListResponse
struct MicrophoneListResponse: Codable {
    let response: MicrophoneResult
}

// MARK: - MicrophoneResult
struct MicrophoneResult: Codable {
    let cursor: Int
    let results: [MicrophoneItem]
    let count: Int
    let remaining: Int
}

// MARK: - MicrophoneItem
struct MicrophoneItem: Codable {
    let micBrandModel: String?
    let createdBy: String?
    let createdDate: String?
    let modifiedDate: String?
    let id: String?

    enum CodingKeys: String, CodingKey, CaseIterable {
        case micBrandModel = "Mic brand+model"
        case createdBy = "Created By"
        case createdDate = "Created Date"
        case modifiedDate = "Modified Date"
        case id = "_id"
    }
}
