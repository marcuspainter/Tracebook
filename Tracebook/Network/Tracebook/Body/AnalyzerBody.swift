//
//  AnalyzerBody.swift
//  Tracebook
//
//  Created by Marcus Painter on 10/02/2024.
//

import Foundation

struct AnalyzerBody: Codable {
    var id: String = ""
    var name: String?
    var createdBy: String?
    var createdDate: String?
    var modifiedDate: String?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case createdBy = "Created By"
        case createdDate = "Created Date"
        case modifiedDate = "Modified Date"
        case id = "_id"
    }
}
