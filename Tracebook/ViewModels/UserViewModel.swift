//
//  UserViewModel.swift
//  Tracebook
//
//  Created by Marcus Painter on 02/02/2024.
//

import Foundation

@MainActor
class UserViewModel: ObservableObject  {
    
    @Published var name: String = ""
    @Published var photo: String = ""
    
    private var apiClient = TracebookAPIClient()
    
    func getUser(id: String) async {
        if let user = await apiClient.getUser(id: id) {
            self.name = user.response.name ?? ""
            self.photo = user.response.photo ?? ""
        }
    }
}
