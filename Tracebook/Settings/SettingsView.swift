//
//  SettingsView.swift
//  SoundAnalyzer
//
//  Created by Marcus Painter on 25/11/2023.
//

// https://sarunw.com/posts/swiftui-dismiss-sheet/

import SwiftUI

struct SettingsView: View {
    @Environment(TracebookService.self) private var tracebookService
    @Environment(\.appVersion) var appVersion
    @Environment(\.appBuild) var appBuild

    @State private var isShowingResetConfirmation = false
    @State private var isResettingOfflineData = false

    var supportURL: String = ""
    var privacyPolicyURL: String = ""
    var tracebookURL: String = ""
    var facebookGroupURL: String = ""
    private let reviewURL = URL(string: "https://apps.apple.com/app/id6474818065?action=write-review")!

    init() {
        let pList = getSettingsPList()

        if let supportURL = pList["AppSupportURL"] as? String {
            self.supportURL = supportURL
        }
        if let privacyPolicyURL = pList["AppPrivacyPolicyURL"] as? String {
            self.privacyPolicyURL = privacyPolicyURL
        }
        if let tracebookURL = pList["TracebookURL"] as? String {
            self.tracebookURL = tracebookURL
        }
        if let tracebookURL = pList["TracebookURL"] as? String {
            self.tracebookURL = tracebookURL
        }
        if let facebookGroupURL = pList["FacebookGroupURL"] as? String {
            self.facebookGroupURL = facebookGroupURL
        }
    }

    var body: some View {
        Group {
            Form {
                Section(header: Text("Appearance")) {
                    ColorSchemePicker()
                }

                Section(header: Text("About")) {
                    LabeledContent {
                        Text("\(appVersion) (\(appBuild))")
                    } label: {
                        Text("Version")
                    }
                }

                Section(header: Text("Links")) {
                    if let url = URL(string: supportURL) {
                        HStack {
                            Link("Support", destination: url)
                        }
                    }
                    if let url = URL(string: privacyPolicyURL) {
                        HStack {
                            Link("Privacy Policy", destination: url)
                        }
                    }
                    Link("Write a Review", destination: reviewURL)
                }

                Section(header: Text("Tracebook"),
                        footer: Text("Sign up Tracebook to download/upload measurements, comment, " +
                                     "and join the forum at trace-book.org.")) {
                    if let url = URL(string: tracebookURL) {
                        HStack {
                            Link("Tracebook Website", destination: url)
                        }
                    }
                }

                Section(header: Text("Facebook"),
                        footer: Text("The official group on Facebook for connecting, sharing, and learning " +
                                     "with people that have an interest in Tracebook.")) {
                    if let url = URL(string: facebookGroupURL) {
                        HStack {
                            Link("Facebook Group", destination: url)
                        }
                    }
                }

                Section {
                    Button("Clear Data", role: .destructive) {
                        isShowingResetConfirmation = true
                    }
                    .disabled(isResettingOfflineData)

                    Text("Remove downloaded measurements and images from this device. Website data is not affected.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } header: {
                    Text("Database")
                }
            }
            .navigationTitle("Settings")
            .alert(
                "Clear Data?",
                isPresented: $isShowingResetConfirmation
            ) {
                Button("Clear Data", role: .destructive) {
                    resetOfflineData()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Downloaded measurements and thumbnails will be removed from this device. You can download them again by synchronizing.")
            }
            .toolbar {
                // DismissButton()
            }
        }
    }

    private func resetOfflineData() {
        isResettingOfflineData = true
        Task {
            try? await tracebookService.resetOfflineData()
            isResettingOfflineData = false
        }
    }
    
    func getSettingsPList() -> [String: AnyObject] {
        // Property List file name = regions.plist
        let pListFileURL = Bundle.main.url(forResource: "Settings", withExtension: "plist", subdirectory: "")
        if let pListPath = pListFileURL?.path,
           let pListData = FileManager.default.contents(atPath: pListPath) {
            do {
                let pListObject = try PropertyListSerialization.propertyList(
                    from: pListData,
                    options: PropertyListSerialization.ReadOptions(),
                    format: nil)

                // Cast pListObject - If expected data type is Dictionary
                guard let pListDictionary = pListObject as? [String: AnyObject] else {
                    return [:]
                }

                return pListDictionary

                // Cast pListObject - If expected data type is Array of Dict
                // guard let pListArray = pListObject as? [Dictionary<String, AnyObject>] else {
                //    return
                // }

                // Perform actions on pListDict
            } catch {
                print("Error reading settings plist file: \(error)")
                return [:]
            }
        }
        return [:]
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .navigationBarTitleDisplayMode(.inline)
    }
    .environment(TracebookService())
}
