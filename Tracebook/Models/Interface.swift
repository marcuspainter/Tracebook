//
//  Interface.swift
//  Tracebook
//
//  Created by Marcus Painter on 26/11/2025.
//

import Foundation
import SwiftData

@Model
class Interface {
    var id: String
    var brandModel: String
    var createdBy: String?
    var createdDate: Date?
    var modifiedDate: Date?
    var maxOutputVoltage: Int
    var selectableVoltageRange: Bool

    init(
        id: String,
        brandModel: String,
        createdBy: String? = nil,
        createdDate: Date? = nil,
        modifiedDate: Date? = nil,
        maxOutputVoltage: Int,
        selectableVoltageRange: Bool
    ) {
        self.id = id
        self.brandModel = brandModel
        self.createdBy = createdBy
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
        self.maxOutputVoltage = maxOutputVoltage
        self.selectableVoltageRange = selectableVoltageRange
    }
}
