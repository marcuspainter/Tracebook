//
//  Interface.swift
//  Tracebook
//
//  Created by Marcus Painter on 10/02/2024.
//

import Foundation

struct InterfaceBody: Codable, Sendable {
    let id: String?
    let brandModel: String?
    let createdBy: String?
    let createdDate: String?
    let modifiedDate: String?
    let maxOutputVoltage: Int?
    let selectableVoltageRange: Bool?

    enum CodingKeys: String, CodingKey {
        case brandModel = "Brand+Model"
        case createdBy = "Created By"
        case createdDate = "Created Date"
        case modifiedDate = "Modified Date"
        case maxOutputVoltage = "Max Output Voltage"
        case id = "_id"
        case selectableVoltageRange = "Selectable Voltage Range"
    }
}
