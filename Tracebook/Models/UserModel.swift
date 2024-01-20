//
//  UserModel.swift
//  Tracebook
//
//  Created by Marcus Painter on 17/01/2024.
//

import Foundation

class UserModel: ObservableObject, Codable {
    var name: String
    var photo: String
    let location: String
    var headline: String
    var firstName, lastName: String
    var followers: [String]
    var following: [String]
    var measurementsCreated: [String]
    var referralCode: String
    var pseudonym: String?
    var measurementsCreatedCount: Int
    var userSignedUp: Bool
    var id: String
}
