//
//  MeasurementViewModel.swift
//  TracebookDB
//
//  Created by Marcus Painter on 07/07/2025.
//

import Foundation
import Observation
import SwiftData

@Observable
@MainActor
class MeasurementItemViewModel {

    private(set) var items: [MeasurementItem] = []
    var service: TracebookService?
    
    var searchText: String = "" {
           didSet {
               if !searchText.isEmpty {
                   fetchFiltered(titleContains: searchText)
               }
               else {
                   fetchAll()
               }
           }
       }
    
    init(service: TracebookService? = nil) {
        self.service = service
    }

    // Fetch filtered by title
    private func fetchFiltered(titleContains: String) {
        guard let service else { return }
         do {
             items = try service.store.fetchFiltered(searchText: titleContains)
         } catch {
             print("Failed to fetch filtered items: \(error)")
             items = []
         }
     }
    
    func synchronize() async {
        guard let service else { return }
        do {

            try await Task.detached {
                print("Start items...")
                try await service.synchronizeMeasurementItems()
                print("Done")
            }.value

            fetchAll()
            
            try await Task.detached {
                print("Start content...")
                try await service.synchronizeMeasurementContents()
                print("Done")
            }.value
            
            fetchAll()
        } catch {
            print(error)
        }
    }
    
    func refresh() async {
        guard let service else { return }
        do {
            try await service.refreshMeasurementItems()
        } catch {
            print(error)
        }
        fetchAll()
    }
    
    func fetchAll() {
        guard let service else { return }
        do {
            items = try service.store.fetchMeasurementItems()
        } catch {
            print("Failed to fetch items: \(error)")
            items = []
        }
    }
    
    func deleteAll() async {
        guard let service else { return }
        try? service.store.deleteAll()
        items = []
    }
    
}
