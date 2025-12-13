//
//  ContentView.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/07/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var path = [MeasurementItem]()
    @State private var sortOrder = SortDescriptor(\MeasurementItem.createdDate, order: .reverse)
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                MeasurementListView(sort: sortOrder, searchText: searchText)
            }
            .navigationTitle("TracebookDB")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: MeasurementItem.self, destination: MeasurementDetailView.init)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // https://stackoverflow.com/questions/64269873/how-can-i-push-a-view-from-a-toolbaritem
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .searchable(text: $searchText)
        }
    }
}

#Preview {
    ContentView()
}
