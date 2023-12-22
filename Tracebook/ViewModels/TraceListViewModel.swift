//
//  BookViewModel.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/12/2023.
//

import Foundation

@MainActor
class TraceListViewModel: ObservableObject {
    @Published var measurements: [MeasurementModel] = []
    @Published var profile: ProfileModel = .init()
    @Published var isNotAuthorised: Bool = true

    private let apiClient: APIClient = .init()

    func search(text: String) async {
        let measurement = await apiClient.loadItem(id: "X")
        measurements.append(measurement)
    }

    func loadItem(id: String) -> MeasurementModel {
        return apiClient.loadItem(id: "X")
    }

    func getTrace() -> TraceModel {
        return TraceModel(name: "Detail")
    }

    func login(username: String, password: String) -> (result: Bool, message: String) {
        if password == "password" {
            isNotAuthorised = false
            return (true, "")
        }
        isNotAuthorised = true
        return (false, "The email or password is incorrect.")
    }

    func setProperty() {
        isNotAuthorised = true
    }

}
