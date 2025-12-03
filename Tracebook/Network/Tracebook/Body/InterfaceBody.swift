//
//  InterfaceBody.swift
//  Tracebook
//
//  Created by Marcus Painter on 10/02/2024.
//

import Foundation

struct InterfaceBody: Codable {
    var id: String = ""
    var brandModel: String?
    var createdBy: String?
    var createdDate: String?
    var modifiedDate: String?
    var maxOutputVoltage: Int?
    var selectableVoltageRange: Bool?

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
