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
        //UISearchBar.appearance().backgroundColor = UIColor.white
        //UISearchBar.appearance().tintColor = UIColor.white
        //UISearchBar.appearance().barTintColor = UIColor.white
        
        // https://stackoverflow.com/questions/69511960/customize-searchable-search-field-swiftui-ios-15
        //UISearchBar.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setImage(<your search image, e.g., magnifyingGlassImage>, for: .search, state: .normal)
        //    UISearchBar.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setImage(<your clear image, e.g., closeImage>, for: .clear, state: .normal)

        
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
            .navigationDestination(for: MeasurementModel.self) { measurement in
                MeasurementDetailView(measurement: measurement)
            }
            .navigationTitle("Tracebook")
            .navigationBarTitleDisplayMode(.inline)
            //.toolbarBackground(Color("tracebookColor"), for: .navigationBar)
            //.toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)

            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {

                    // https://stackoverflow.com/questions/64269873/how-can-i-push-a-view-from-a-toolbaritem
                    
                    /*
                    NavigationLink {
                        //ProfileView(profile: traceListViewModel.profile)
                    } label: {
                        Label("Profile", systemImage: "person")
                    }
                    */
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
            //UISearchBar.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = UIColor.tintColor
            //UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.label
            //UISearchTextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.black
           // UISearchTextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search", attributes: [.foregroundColor: UIColor.red])
            
            Task {
                await measurementListViewModel.getMeasurementList()
            }
        }
    }
}

#Preview {
    ContentView()
}
