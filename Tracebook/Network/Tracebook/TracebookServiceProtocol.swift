//
//  TracebookAPIProtocol.swift
//  Tracebook
//
//  Created by Marcus Painter on 30/06/2024.
//

import Foundation

protocol TracebookServiceProtocol: Sendable {
    func getMeasurementListByDate(cursor: Int, dateString: String) async throws -> MeasurementListResponse?
    func getMeasurementContent(id: String) async throws -> MeasurementContentItemResponse?
    func getUser(id: String) async throws -> UserItemResponse?
    func getAnalyzerList() async throws -> AnalyzerListResponse?
    func getMicrophoneList() async throws -> MicrophoneListResponse?
    func getInterfaceList() async throws -> InterfaceListResponse?
}
