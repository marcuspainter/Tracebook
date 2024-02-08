//
//  ContentView.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/12/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var measurementListViewModel: MeasurementListViewModel = .init()
    @State var searchText: String = ""
    @State private var path = NavigationPath()

    @State var username: String = ""
    @State var password: String = ""

    init() {
        // https://stackoverflow.com/questions/69511960/customize-searchable-search-field-swiftui-ios-15
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
                print("Pull")
                if !measurementListViewModel.isDownloading {
                    Task {
                        await measurementListViewModel.loadMeasurements()
                    }
                }

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
                
                if measurementListViewModel.measurementStore.models.count == 0 {
                    VStack {
                        ProgressView()
                    }
                } else {
                    Text("No matches")
                }
            }
        }
        .onChange(of: searchText) { newValue in
            print(newValue)
            Task {
                await measurementListViewModel.search(searchText: searchText)
            }
        }
        .sheet(isPresented: .constant(false)) {
            Text("Sheet")
                .presentationDetents([.medium, .large])
        }
        .onAppear {
            Task {
                //await measurementListViewModel.getMeasurementList()
                await measurementListViewModel.loadMeasurements()
                //measurementListViewModel.measurementStore.models.removeFirst()
                //measurementListViewModel.measurements.removeFirst()
                print("Done")
            }
        }
    }
}

#Preview {
    ContentView()
}
