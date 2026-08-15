//
//  TracebookApp.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/07/2025.
//

import SwiftUI

@main
struct TracebookApp: App {
    var body: some Scene {
        WindowGroup {
            AppBootstrapView()
        }
    }
}

@MainActor
private struct AppBootstrapView: View {
    @State private var tracebookService: TracebookService?

    var body: some View {
        Group {
            if let tracebookService {
                MainView()
                    .environment(tracebookService)
            } else {
                ProgressView("Loading…")
                    .task {
                        await Task.yield()
                        tracebookService = TracebookService()
                    }
            }
        }
    }
}
