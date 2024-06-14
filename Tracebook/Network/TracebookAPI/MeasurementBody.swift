//
//  Measurement.swift
//  Tracebook
//
//  Created by Marcus Painter on 10/02/2024.
//

import Foundation

struct MeasurementBody: Codable, Sendable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: MeasurementBody, rhs: MeasurementBody) -> Bool {
        return lhs.id == rhs.id
    }

    let id: String
    let additionalContent: String?
    let admin1Approved: String?
    let admin2Approved: String?
    let approved: String?
    let commentCreator: String?
    let createdBy: String?
    let createdDate: String?
    let emailSent: Bool?
    // public is reserved word, so resultPublic used instead
    let isPublic: Bool?
    let loudspeakerTags: [String]?
    let moderator1: String?
    let moderator2: String?
    let modifiedDate: String?
    let productLaunchDateText: String?
    let publishDate: String?
    let slug: String?
    let thumbnailImage: String?
    let title: String?
    let upvotes: [String]?

    //let content: MeasurementContentBody?

    // Added properties
    //var tracebookURL: String? { "https://trace-book.org/measurement/\(slug ?? "")" }
    //let tracebookURL: String? = ""

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
