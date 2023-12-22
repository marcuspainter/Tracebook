//
//  LoginView.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/12/2023.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var message: String = ""

    let tracebookColor = Color(red: 74, green: 15, blue: 235)

    var body: some View {
        Group {
            Image("TracebookLogo")
                .padding(.bottom, 15)
                .padding(.top, 30)

            VStack {
                Text(message).foregroundStyle(.red).padding().frame(height: 20)
                TextField("Email", text: $username)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }.padding(.bottom)

            Button(action: {

            }) {
                Text("Log In")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .padding(.bottom)

            Link("Not a member yet? Sign up here.", destination: URL(string: "https://trace-book.org")!)
            Link("Forgot your password", destination: URL(string: "https://trace-book.org")!)
                .font(.footnote)

            Spacer()

            .navigationTitle("Log in")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    DismissButton()
                }
            }

        }

        .padding()
    }
}

#Preview {
    return LoginView()
}
