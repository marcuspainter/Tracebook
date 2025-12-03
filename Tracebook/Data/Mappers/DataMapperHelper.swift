//
//  DataMapperHelper.swift
//  TracebookDB
//
//  Created by Marcus Painter on 13/07/2025.
//

import Foundation
import SwiftData

struct DataMapperHelper {
    
    static func parseISODate(_ dateString: String?) -> Date {
        let isoString = dateString ?? ""
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = formatter.date(from: isoString) ?? Date()
        return date
    }

    static func parseDoubleArray(_ arrayString: String) -> [Double] {
        guard !arrayString.isEmpty else {
            return []
        }

        return arrayString
            .split(separator: ",")
            .map { substring in
                let trimmed = substring.trimmingCharacters(in: .whitespaces)
                return Double(trimmed) ?? 0.0
            }
    }
}
