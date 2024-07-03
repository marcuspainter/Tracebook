//
//  ContentView.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/12/2023.
//

// https://stackoverflow.com/questions/69511960/customize-searchable-search-field-swiftui-ios-15

import SwiftUI
import Observation

@MainActor
struct ContentView: View {
    @State var measurementListViewModel: MeasurementListViewModel = .init()
    @State var searchText: String = ""
    @State private var path = NavigationPath()

    @State var username: String = ""
    @State var password: String = ""
    @State var isDownloading: Bool = false

    init() {

    }

    var body: some View {
        NavigationStack(path: $path) {

            List {
                ForEach(measurementListViewModel.measurements) { measurement in
                    NavigationLink(value: measurement) {
                        MeasurementItemView(measurement: measurement)
                    }
                }.listRowBackground(Color.clear) // No highlight on selection
            }
            .listStyle(.plain)
            .refreshable {
                // https://stackoverflow.com/questions/74977787/why-is-async-task-cancelled-in-a-refreshable-modifier-on-a-scrollview-ios-16
                print("Pull")
                await Task {
                 
                    if !isDownloading {
                        do {
                            try await measurementListViewModel.loadMeasurements()
                        }
                        catch {
                            print("Error")
                        }
                    }
                 }.value

            }
            .navigationTitle("Tracebook")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: MeasurementModel.self) { measurement in
                MeasurementDetailView(measurement: measurement)
            }

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
        }
        .searchable(text: $searchText, prompt: "Search loudspeakers")
        .overlay {
            if measurementListViewModel.measurements.isEmpty {

                if measurementListViewModel.measurementStore.models.count == 0 && isDownloading {
                    VStack {
                        ProgressView()
                        Text("LOADING").font(.caption)
                    }
                } else {
                    Text("No matches")
                }
            }

        }
        .onChange(of: searchText) { _, newValue in
            print(newValue)
            Task {
                await measurementListViewModel.search(searchText: searchText)
            }
        }
        .sheet(isPresented: .constant(false)) {
            Text("Sheet")
                .presentationDetents([.medium, .large])
        }
        .task {
            isDownloading = true
            
            do {
                try await measurementListViewModel.loadMeasurements()
            }
            catch {
                print(error.localizedDescription)
            }
            print("Done")
            isDownloading = false
        }
        .onAppear {
        
        }
    }
}

#Preview {
    ContentView()
}
