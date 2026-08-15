//
//  MeasurementViewModel.swift
//  Tracebook
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
    private var hasRunInitialSync = false
    private(set) var isLoadingInitialData = true
    private(set) var isOffline = false
    
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
    
    func synchronize(reportOfflineFailure: Bool = true) async {
        guard let service else { return }
        do {
            try await service.synchronize()
            isOffline = false
        } catch {
            isOffline = reportOfflineFailure && error.isOfflineConnectivityFailure
        }
        fetchAll()
    }

    func synchronizeIfNeeded() async {
        fetchAll()

        guard !hasRunInitialSync else { return }
        hasRunInitialSync = true

        isLoadingInitialData = items.isEmpty
        defer { isLoadingInitialData = false }
        await synchronize(reportOfflineFailure: false)
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
}
