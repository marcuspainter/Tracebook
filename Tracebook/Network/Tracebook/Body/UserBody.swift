//
//  UserBody.swift
//  Tracebook
//
//  Created by Marcus Painter on 10/02/2024.
//

import Foundation

struct UserBody: Codable {
    var name: String?
    var photo: String?
    var location: String?
    var headline: String?
    var firstName: String?
    var lastName: String?
    var followers: [String]?
    var following: [String]?
    var measurementsCreated: [String]?
    var referralCode: String?
    var pseudonym: String?
    var measurementsCreatedCount: Int?
    var userSignedUp: Bool?
    var id: String

    enum CodingKeys: String, CodingKey, CaseIterable {
        case name = "Name"
        case photo = "Photo"
        case location = "Location"
        case headline = "Headline"
        case firstName = "First Name"
        case lastName = "Last Name"
        case followers = "Followers"
        case following = "Following"
        case measurementsCreated = "Measurements created"
        case referralCode = "Referral Code"
        case pseudonym = "Pseudonym"
        case measurementsCreatedCount = "Measurements Created Count"
        case userSignedUp = "user_signed_up"
        case id = "_id"
    }
}
