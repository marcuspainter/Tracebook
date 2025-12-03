//
//  MeasurementBody.swift
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
    var approved: String?
    var commentCreator: String?
    var productLaunchDateText: String?
    var thumbnailImage: String?
    var upvotes: [String]?
    var createdDate: String?
    var createdBy: String?
    var modifiedDate: String?
    var slug: String?
    var moderator1: String?
    var isPublic: Bool?
    var title: String?
    var publishDate: String?
    var admin1Approved: String?
    var moderator2: String?
    var admin2Approved: String?
    var loudspeakerTags: [String]?
    var emailSent: Bool?

    var content: MeasurementContentBody?

    // Added properties
    var tracebookURL: String? { "https://trace-book.org/measurement/\(slug ?? "")" }

    enum CodingKeys: String, CodingKey {
        case additionalContent = "Additional content"
        case approved = "Approved"
        case commentCreator = "Comment Creator"
        case productLaunchDateText = "ProductLaunchDate(text)"
        case thumbnailImage = "Thumbnail image"
        case upvotes = "Upvotes"
        case createdDate = "Created Date"
        case createdBy = "Created By"
        case modifiedDate = "Modified Date"
        case slug = "Slug"
        case moderator1 = "Moderator1"
        case isPublic = "Public"
        case title = "Title"
        case publishDate = "_Publish Date"
        case admin1Approved = "Admin1 Approved"
        case moderator2 = "Moderator2"
        case admin2Approved = "Admin2 Approved"
        case id = "_id"
        case loudspeakerTags = "Loudspeaker tags"
        case emailSent = "Email Sent"
    }
}
