//
//  UserViewModel.swift
//  Tracebook
//
//  Created by Marcus Painter on 02/02/2024.
//

import Foundation

@MainActor
@Observable
final class UserViewModel {
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

    private let tracebookService: TracebookServiceProtocol
    
    init(tracebookService: TracebookServiceProtocol = TracebookService()) {
        self.tracebookService = tracebookService
    }
    
    func getUser(id: String) async throws {
        do {
            if let response = try await tracebookService.getUser(id: id) {
                let user = response.response
                self.id = user.id
                name = user.name ?? ""
                photo = user.photo ?? ""
                location = user.location ?? ""
                measurementsCreatedCount = user.measurementsCreatedCount ?? 0

                followersCount = user.followers?.count ?? 0
                followingCount = user.following?.count ?? 0
            }
        } 
        catch {
        }
    }
}
