//
//  ProfileView.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/12/2023.
//

import SwiftUI

@MainActor
struct UserView: View {
    var userId: String
    @State var user: UserViewModel = UserViewModel()
    
    var body: some View {
        Group {
            AsyncImage(url: URL(string: user.photo), content: asyncImageContent)
                .frame(width: 96, height: 96)

            Text(user.name)
                .font(.title)

            Text(user.location)
                .font(.body)
                .padding(.bottom)

            Text(user.headline)
                .padding(.bottom)

            HStack {
                VStack {
                    Text("Followers")
                    Text(user.followers.formatted()).monospacedDigit()
                }
                Divider()
                VStack {
                    Text("Following")
                    Text(user.following.formatted()).monospacedDigit()
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxHeight: 200)
            .padding(.bottom)

            VStack {
                Text("Uploads")
                Text(user.measurementsCreatedCount.formatted()).monospacedDigit()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    let userId = ""
    return UserView(userId: userId)
}
