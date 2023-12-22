//
//  SettingsView.swift
//  SoundAnalyzer
//
//  Created by Marcus Painter on 25/11/2023.
//

// https://sarunw.com/posts/swiftui-dismiss-sheet/

import SwiftUI

struct SettingsView: View {
    @Environment(\.appVersion) var appVersion

    var body: some View {
        Group {
            Form {
                Section(header: Text("Appearance")) {
                    ColorSchemePicker()
                }

                Section(header: Text("About")) {
                    LabeledContent {
                        Text(appVersion)
                    } label: {
                        Text("Version")
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                DismissButton()
            }
        }
    }
}

#Preview {
    SettingsView()
}
