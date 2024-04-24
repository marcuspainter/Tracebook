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
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\MeasurementEntity.createdDate, order: .reverse)]
    ) var measurements: FetchedResults<MeasurementEntity>

    var tracebookProvider = TracebookProvider.shared
    @State private var path = NavigationPath()
    @State var isDownloading: Bool = false
    
    // https://stackoverflow.com/questions/68530633/how-to-use-a-fetchrequest-with-the-new-searchable-modifier-in-swiftui
    @State private var searchText = ""
    var query: Binding<String> {
        Binding {
            searchText
        } set: { newValue in
            searchText = newValue
            if measurements.nsPredicate == nil && newValue.isEmpty { return }
            measurements.nsPredicate = newValue.isEmpty
                           ? nil
                           : NSPredicate(format: "title CONTAINS[c] %@", newValue)
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            
            Button("Delete") {
                tracebookProvider.deleteEntityData()
            }

            Button("Load") {
                Task {
                    do {
                        try await tracebookProvider.fetchMeasurements()
                        try await tracebookProvider.fetchMeasurementContents()
                    }
                    catch {
                        print("Fetch error: \(error)")
                    }
                }
            }
            
            List {
                ForEach(measurements) { measurement in
                    NavigationLink(value: measurement) {
                        MeasurementEntityItemView(measurement: measurement)
                    }
                }.listRowBackground(Color.clear) // No highlight on selection
            }
            .listStyle(.plain)
            .searchable(text: query, prompt: "Search loudspeakers")
            .refreshable {
                // https://stackoverflow.com/questions/74977787/why-is-async-task-cancelled-in-a-refreshable-modifier-on-a-scrollview-ios-16
                print("Pull")
                await Task {
                    if !isDownloading {
                        //try? await tracebookProvider.fetchMeasurements()
                        try? await tracebookProvider.fetchMeasurementContents()
                    }
                 }.value

            }
            .navigationTitle("Tracebook")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: MeasurementEntity.self) { measurement in
                MeasurementEntityDetailView(measurement: measurement)
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
        .overlay {

            if measurements.isEmpty {

                if measurements.count == 0 {
                    VStack {
                        ProgressView()
                        Text("LOADING").font(.caption)
                    }
                } else {
                    Text("No matches")
                }
            }

        }
        .sheet(isPresented: .constant(false)) {
            Text("Sheet")
                .presentationDetents([.medium, .large])
        }
        .task {
            isDownloading = true
            //try? await tracebookProvider.fetchMeasurements()
            //try? await tracebookProvider.fetchMeasurementContents()
            isDownloading = false
            print("Done")
        }
        .onAppear {
        
        }
    }
}

#Preview {
    ContentView()
}
