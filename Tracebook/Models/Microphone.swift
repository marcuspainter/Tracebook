//
//  Microphone.swift
//  TracebookDB
//
//  Created by Marcus Painter on 25/11/2025.
//

import Foundation
import SwiftData

@Model
final class Microphone {
    var id: String
    var brandModel: String?
    var createdBy: String?
    var createdDate: Date?
    var modifiedDate: Date?

    init(
        id: String,
        brandModel: String? = nil,
        createdBy: String? = nil,
        createdDate: Date? = nil,
        modifiedDate: Date? = nil
    ) {
        self.id = id
        self.brandModel = brandModel
        self.createdBy = createdBy
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }

}
