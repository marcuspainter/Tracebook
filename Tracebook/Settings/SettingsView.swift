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

    let supportURL: String
    let privacyPolicyURL: String

    init() {
        let pList = getSettingsPList()

        if let supportURL = pList["AppSupportURL"] as? String {
            self.supportURL = supportURL
        } else {
            supportURL = ""
        }

        if let privacyPolicyURL = pList["AppPrivacyPolicyURL"] as? String {
            self.privacyPolicyURL = privacyPolicyURL
        } else {
            privacyPolicyURL = ""
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
                        Text(appVersion)
                    } label: {
                        Text("Version")
                    }
                }

                Section(header: Text("Links")) {
                    Link("Support", destination: URL(string: supportURL)!)
                    Link("Privacy Policy", destination: URL(string: privacyPolicyURL)!)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                // DismissButton()
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .navigationBarTitleDisplayMode(.inline)
    }
}

func getSettingsPList() -> Dictionary<String, AnyObject> {
    // Property List file name = regions.plist
    let pListFileURL = Bundle.main.url(forResource: "Settings", withExtension: "plist", subdirectory: "")
    if let pListPath = pListFileURL?.path,
       let pListData = FileManager.default.contents(atPath: pListPath) {
        do {
            let pListObject = try PropertyListSerialization.propertyList(from: pListData, options: PropertyListSerialization.ReadOptions(), format: nil)

            // Cast pListObject - If expected data type is Dictionary
            guard let pListDictionary = pListObject as? Dictionary<String, AnyObject> else {
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
