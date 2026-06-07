//
//  DataMapperHelper.swift
//  Tracebook
//
//  Created by Marcus Painter on 13/07/2025.
//

import Foundation
struct DataMapperHelper {
    
    static func parseISODate(_ dateString: String?) -> Date? {
        guard let isoString = dateString, !isoString.isEmpty else {
            return nil
        }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: isoString)
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
