//
//  TracebookDBApp.swift
//  TracebookDB
//
//  Created by Marcus Painter on 07/07/2025.
//

import SwiftUI
import SwiftData

@main
struct TracebookApp: App {
    @State var tracebookService  = TracebookService()
    
    var body: some Scene {
        WindowGroup {
            MainView()
            //ContentView()
            //    .modelContainer(for: [MeasurementItem.self, MeasurementContent.self])
        }
        .environment(self.tracebookService)
        
    }
}
