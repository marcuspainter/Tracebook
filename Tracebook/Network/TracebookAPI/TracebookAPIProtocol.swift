//
//  TracebookAPIProtocol.swift
//  Tracebook
//
//  Created by Marcus Painter on 21/04/2024.
//

import Foundation

protocol TracebookAPIProtocol {
    func getUser(id: String) async -> UserItemResponse?
    func getAnalyzerList() async -> AnalyzerListResponse?
    func getMicrophoneList() async -> MicrophoneListResponse?
    func getInterfaceList() async -> InterfaceListResponse?
    func getMeasurementContent(id: String) async -> MeasurementContentItemResponse?
    func getMeasurementListByDate(cursor: Int, dateString: String) async -> MeasurementListResponse?
}
