//
//  Analyzer.swift
//  Tracebook
//
//  Created by Marcus Painter on 26/11/2025.
//

import Foundation
import SwiftData

@Model
class Analyzer {
    var id: String
    var name: String
    var createdBy: String
    var createdDate: Date?
    var modifiedDate: Date?

    init(id: String, name: String, createdBy: String, createdDate: Date? = nil, modifiedDate: Date? = nil) {
        self.id = id
        self.name = name
        self.createdBy = createdBy
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }
}
