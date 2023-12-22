//
//  ProfileView.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/12/2023.
//

import SwiftUI

struct ProfileView: View {
    var profile: ProfileModel

    var body: some View {
        Group {
            AsyncImage(url: URL(string: profile.image), content: asyncImageContent)
                .frame(width: 96, height: 96)

            Text(profile.name)
                .font(.title)

            Text(profile.location)
                .font(.body)
                .padding(.bottom)

            Text(profile.company)
                .padding(.bottom)

            HStack {
                VStack {
                    Text("Followers")
                    Text(profile.followers.formatted()).monospacedDigit()
                }
                Divider()
                VStack {
                    Text("Following")
                    Text(profile.following.formatted()).monospacedDigit()
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxHeight: 200)
            .padding(.bottom)

            VStack {
                Text("Uploads")
                Text(profile.uploads.formatted()).monospacedDigit()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    let profile = ProfileModel()
    return ProfileView(profile: profile)
}
