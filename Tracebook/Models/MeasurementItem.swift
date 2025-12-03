//
//  MeasurementItem.swift
//  TracebookDB
//
//  Created by Marcus Painter on 07/07/2025.
//

import Foundation
import SwiftData

@Model
final class MeasurementItem {
    @Attribute(.unique) var id: String
    @Relationship(deleteRule: .cascade) var content: MeasurementContent?

    var additionalContent: String
    var approved: Bool
    var commentCreator: String
    var productLaunchDateText: String
    var thumbnailImage: String
    var upvotes: String
    var createdDate: Date?
    var createdBy: String
    var modifiedDate: Date?
    var slug: String
    var moderator1: String
    var isPublic: Bool
    var title: String
    var publishDate: Date?
    var admin1Approved: Bool
    var moderator2: String
    var admin2Approved: Bool
    var loudspeakerTags: String
    var emailSent: Bool

    init(id: String,
         additionalContent: String = "",
         approved: Bool = false,
         commentCreator: String = "",
         productLaunchDateText: String = "",
         thumbnailImage: String = "",
         upvotes: String = "",
         createdDate: Date? = nil,
         createdBy: String = "",
         modifiedDate: Date? = nil,
         slug: String = "",
         moderator1: String = "",
         isPublic: Bool = false,
         title: String = "",
         publishDate: Date? = nil,
         admin1Approved: Bool = false,
         moderator2: String = "",
         admin2Approved: Bool = false,
         loudspeakerTags: String = "",
         emailSent: Bool = false,

         content: MeasurementContent? = nil
    ) {
        self.id = id
        self.additionalContent = additionalContent
        self.approved = approved
        self.commentCreator = commentCreator
        self.productLaunchDateText = productLaunchDateText
        self.thumbnailImage = thumbnailImage
        self.upvotes = upvotes
        self.createdDate = createdDate
        self.createdBy = createdBy
        self.modifiedDate = modifiedDate
        self.slug = slug
        self.moderator1 = moderator1
        self.isPublic = isPublic
        self.title = title
        self.publishDate = publishDate
        self.admin1Approved = admin1Approved
        self.moderator2 = moderator2
        self.admin2Approved = admin2Approved
        self.loudspeakerTags = loudspeakerTags
        self.emailSent = emailSent

        self.content = content
    }
}
