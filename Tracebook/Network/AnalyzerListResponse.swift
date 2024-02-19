// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let analayzer = try? JSONDecoder().decode(Analayzer.self, from: jsonData)

import Foundation

// MARK: - Analayzer
struct AnalyzerListResponse: Codable {
    let response: AnalyzerResult
}

// MARK: - Response
struct AnalyzerResult: Codable {
    let cursor: Int
    let results: [AnalyzerItem]
    let count: Int
    let remaining: Int
}

// MARK: - Result
struct AnalyzerItem: Codable {
    let name, createdBy, createdDate, modifiedDate: String?
    let id: String?

    enum CodingKeys: String, CodingKey, CaseIterable {
        case name = "Name"
        case createdBy = "Created By"
        case createdDate = "Created Date"
        case modifiedDate = "Modified Date"
        case id = "_id"
    }
}
