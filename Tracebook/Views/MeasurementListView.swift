//
//  MeasurementListView.swift
//  TracebookDB
//
//  Created by Marcus Painter on 07/07/2025.
//

import SwiftData
import SwiftUI

struct MeasurementListView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\MeasurementItem.createdDate, order: .reverse)]) var measurements: [MeasurementItem]

    let searchText: String

    init(sort: SortDescriptor<MeasurementItem>, searchText: String) {
        self.searchText = searchText
        _measurements = Query(filter: #Predicate {
            if searchText.isEmpty {
                return true
            } else {
                return $0.title.localizedStandardContains(searchText)
            }
        }, sort: [sort])
    }

    var body: some View {
        List {
            ForEach(measurements) { measurement in
                NavigationLink(value: measurement) {
                   MeasurementItemView(measurement: measurement)
                }
            }.listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .refreshable {
            // https://stackoverflow.com/questions/74977787/why-is-async-task-cancelled-in-a-refreshable-modifier-on-a-scrollview-ios-16
            print("Pull")
            await Task {
                try? await Task.sleep(for: .seconds(5))
             }.value
            print("Done")
        }
        
        .overlay {
            if measurements.isEmpty && !searchText.isEmpty {
                /// In case there aren't any search results, we can
                /// show the new content unavailable view.
                ContentUnavailableView.search
            }
        }
    }
}

#Preview {
   // MeasurementListView(sort: SortDescriptor(\MeasurementItem.createdDate, order: .reverse), searchText: "")
}

