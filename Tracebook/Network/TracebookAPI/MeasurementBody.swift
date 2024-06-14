//
//  Measurement.swift
//  Tracebook
//
//  Created by Marcus Painter on 10/02/2024.
//

import Foundation

class MeasurementBody: Codable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: MeasurementBody, rhs: MeasurementBody) -> Bool {
        return lhs.id == rhs.id
    }

    var id: String = ""
    var additionalContent: String?
    var admin1Approved: String?
    var admin2Approved: String?
    var approved: String?
    var commentCreator: String?
    var createdBy: String?
    var createdDate: String?
    var emailSent: Bool?
    // public is reserved word, so resultPublic used instead
    var isPublic: Bool?
    var loudspeakerTags: [String]?
    var moderator1: String?
    var moderator2: String?
    var modifiedDate: String?
    var productLaunchDateText: String?
    var publishDate: String?
    var slug: String?
    var thumbnailImage: String?
    var title: String?
    var upvotes: [String]?

    //var content: MeasurementContentBody?

    // Added properties
    var tracebookURL: String? { "https://trace-book.org/measurement/\(slug ?? "")" }

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        
        case additionalContent = "Additional content"
        case admin1Approved = "Admin1 Approved"
        case admin2Approved = "Admin2 Approved"
        case approved = "Approved"
        case modifiedDate = "Modified Date"
        case commentCreator = "Comment Creator"
        case createdDate = "Created Date"
        case createdBy = "Created By"
        case emailSent = "Email Sent"
        case isPublic = "Public"
        case loudspeakerTags = "Loudspeaker tags"
        case moderator1 = "Moderator1"
        case moderator2 = "Moderator2"
        case productLaunchDateText = "ProductLaunchDate(text)"
        case publishDate = "_Publish Date"
        case slug = "Slug"
        case thumbnailImage = "Thumbnail image"
        case title = "Title"
        case upvotes = "Upvotes"

    }
}
