//
//  UserViewModel.swift
//  Tracebook
//
//  Created by Marcus Painter on 02/02/2024.
//

import Foundation

@MainActor
class UserViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var photo: String = ""
    @Published var location: String = ""
    @Published var headline: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var followers: [String] = []
    @Published var following: [String] = []
    @Published var measurementsCreated: [String] = []
    @Published var referralCode: String = ""
    @Published var pseudonym: String = ""
    @Published var measurementsCreatedCount: Int = 0
    @Published var userSignedUp: Bool = false
    @Published var id: String = ""
    
    // Derived counts from arrays
    @Published var followersCount: Int = 0
    @Published var followingCount: Int = 0

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
