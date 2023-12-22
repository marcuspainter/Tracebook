//
//  MeasurementListModel.swift
//  Tracebook
//
//  Created by Marcus Painter on 20/12/2023.
//

import Foundation

class MeasurementListModel: ObservableObject, Codable {

    var additionalContent: String = ""
    var approved: String = ""
    var commentCreator: String? = ""
    var productLaunchDateText: String = ""
    var thumbnailImage: String? = ""
    var upvotes: [String]? = []
    var createdDate: String = ""
    var createdBy: String = ""
    var modifiedDate: String = ""
    var slug: String = ""
    var moderator1: String = ""
    var resultPublic: Bool = false
    var title: String? = ""
    var publishDate: String? = ""
    var admin1Approved: String? = ""
    var moderator2: String? = ""
    var admin2Approved: String? = ""
    var id: String = ""
    var loudspeakerTags: [String]? = []
    var emailSent: Bool? = false

}
