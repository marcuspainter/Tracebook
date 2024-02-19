//
//  InterfaceResponse.swift
//  Tracebook
//
//  Created by Marcus Painter on 21/12/2023.
//

import Foundation

// MARK: - InterfaceListResponse
struct InterfaceListResponse: Codable {
    let response: InterfaceResult
}

// MARK: - InterfaceResult
struct InterfaceResult: Codable {
    let cursor: Int
    let results: [InterfaceItem]
    let count, remaining: Int
}

// MARK: - InterfaceItem
struct InterfaceItem: Codable {
    let brandModel: String?
    let createdBy: String?
    let createdDate: String?
    let modifiedDate: String?
    let maxOutputVoltage: Int?
    let id: String?
    let selectableVoltageRange: Bool?

    enum CodingKeys: String, CodingKey, CaseIterable {
        case brandModel = "Brand+Model"
        case createdBy = "Created By"
        case createdDate = "Created Date"
        case modifiedDate = "Modified Date"
        case maxOutputVoltage = "Max Output Voltage"
        case id = "_id"
        case selectableVoltageRange = "Selectable Voltage Range"
    }
}
