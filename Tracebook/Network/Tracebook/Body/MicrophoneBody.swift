//
//  MicrophoneBody.swift
//  Tracebook
//
//  Created by Marcus Painter on 10/02/2024.
//

import Foundation

struct MicrophoneBody: Codable {
    var id: String = ""
    var brandModel: String?
    var createdBy: String?
    var createdDate: String?
    var modifiedDate: String?

    enum CodingKeys: String, CodingKey {
        case brandModel = "Mic brand+model"
        case createdBy = "Created By"
        case createdDate = "Created Date"
        case modifiedDate = "Modified Date"
        case id = "_id"
    }
}
