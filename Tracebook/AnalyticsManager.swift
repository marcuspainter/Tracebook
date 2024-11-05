//
//  AnalyticsManager.swift
//  SpeedAir
//
//  Created by Marcus Painter on 05/11/2024.
//

import FirebaseAnalytics
import Foundation

final class AnalyticsManager {
    private init() {
    }

    @MainActor static let shared = AnalyticsManager()

    public func log(_ event: AnalyticsEvent) {
        var parameters: [String: Any] = [:]
        switch event {
        case let .characterSelected(rMCharacterSelectedEvent):
            do {
                let data = try JSONEncoder().encode(rMCharacterSelectedEvent)
                let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
                parameters = dict
            } catch {
            }
        }
        print("Event: \(event.eventName) Params: \(parameters)")
        
        Analytics.logEvent(event.eventName, parameters: parameters)
    }
}

enum AnalyticsEvent {
    case characterSelected(RMCharacterSelectedEvent)

    var eventName: String {
        switch self {
        case .characterSelected: return "character_selected"
        }
    }
}

struct RMCharacterSelectedEvent: Codable {
    let characterName: String
    let origin: String
    let timestamp: Date
}
