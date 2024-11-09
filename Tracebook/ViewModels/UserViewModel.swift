//
//  UserViewModel.swift
//  Tracebook
//
//  Created by Marcus Painter on 02/02/2024.
//

import Foundation

@MainActor

class UserViewModel: ObservableObject {
    var name: String = ""
    var photo: String = ""
    var location: String = ""
    var headline: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var followers: [String] = []
    var following: [String] = []
    var measurementsCreated: [String] = []
    var referralCode: String = ""
    var pseudonym: String = ""
    var measurementsCreatedCount: Int = 0
    var userSignedUp: Bool = false
    var id: String = ""

    // Derived counts from arrays
    var followersCount: Int = 0
    var followingCount: Int = 0

    private var tracebookAPI = TracebookAPI()

    func getUser(id: String) async {
        if let response = await tracebookAPI.getUser(id: id) {
            let user = response.response
            self.id = user.id
            self.name = user.name ?? ""
            self.photo = user.photo ?? ""
            self.location = user.location ?? ""
            self.measurementsCreatedCount = user.measurementsCreatedCount ?? 0

            self.followersCount = user.followers?.count ?? 0
            self.followingCount = user.following?.count ?? 0
        }
    }
}
