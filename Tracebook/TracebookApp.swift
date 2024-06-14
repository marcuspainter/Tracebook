//
//  TracebookApp.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/12/2023.
//

import SwiftUI

@main
struct TracebookApp: App {
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    ColorSchemeManager.shared.applyColorScheme()
                    // disableUIConstraintBasedLayoutLogUnsatisfiable()
                }
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active {
                        print("Active")
                    } else if newPhase == .inactive {
                        print("Inactive")
                    } else if newPhase == .background {
                        print("Background")
                    }
                }
        }
    }
}
