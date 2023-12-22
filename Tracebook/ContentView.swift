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
            .navigationDestination(for: MeasurementModel.self) { measurement in
                MeasurementDetailView(measurement: measurement)
            }
            .navigationTitle("Tracebook")
            .navigationBarTitleDisplayMode(.inline)

            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {

                    // https://stackoverflow.com/questions/64269873/how-can-i-push-a-view-from-a-toolbaritem
                    NavigationLink {
                        // ProfileView(profile: traceListViewModel.profile)
                    } label: {
                        Label("Profile", systemImage: "person")
                    }

                    NavigationLink {
                        SettingsView()
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search loudspeakers")
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
                await measurementListViewModel.getMeasurementList()
            }
        }
    }
}

#Preview {
    ContentView()
}
