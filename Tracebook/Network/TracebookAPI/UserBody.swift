//
//  User.swift
//  Tracebook
//
//  Created by Marcus Painter on 10/02/2024.
//

import Foundation

struct UserBody: Codable, Sendable {
    let id: String
    let name: String?
    let photo: String?
    let location: String?
    let headline: String?
    let firstName: String?
    let lastName: String?
    let followers: [String]?
    let following: [String]?
    let measurementsCreated: [String]?
    let referralCode: String?
    let pseudonym: String?
    let measurementsCreatedCount: Int?
    let userSignedUp: Bool?


    enum CodingKeys: String, CodingKey, CaseIterable, Sendable {
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
