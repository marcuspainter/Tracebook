//
//  MainView.swift
//  Tracebook
//
//  Created by Marcus Painter on 25/11/2025.
//

// https://www.createwithswift.com/display-empty-states-with-contentunavailableview-in-swiftui/

import Foundation
import SwiftUI
import SwiftData

@MainActor
struct MainView: View {
    @Environment(TracebookService.self) private var tracebookService
    @State private var viewModel = MeasurementItemViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                    List {
                        ForEach(viewModel.items) { measurement in
                            NavigationLink(value: measurement) {
                                MeasurementItemView(measurement: measurement)
                            }
                        }.listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .overlay {
                        if viewModel.items.isEmpty && !viewModel.searchText.isEmpty {
                            /// In case there aren't any search results, we can
                            /// show the new content unavailable view.
                            ContentUnavailableView.search
                        } else if viewModel.items.isEmpty {
                            ContentUnavailableView(
                                "No Traces",
                                systemImage: "doc.text")
                        }
                    }
                    .refreshable {
// https://stackoverflow.com/questions/74977787/why-is-async-task-cancelled-in-a-refreshable-modifier-on-a-scrollview-ios-16
                        print("Pull")
                        await Task {
                            synchronize()
                        }.value
                        print("Done")
                    }
            }
            .navigationTitle("Tracebook")
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
            .task {
                viewModel.service = self.tracebookService
                viewModel.fetchAll()
                //await viewModel.synchronize()
            }
            .searchable(text: $viewModel.searchText)
        }
    }
    
    func synchronize() {
        Task {
            await viewModel.synchronize()
        }
    }
}

#Preview {
    //  MainView()
}
