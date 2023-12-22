import Foundation

// MARK: - MeasurementListResponse
struct MeasurementListResponse: Codable {
    let response: MeasurementListResult
}

// MARK: - MeasurementListResult
struct MeasurementListResult: Codable {
    let cursor: Int
    let results: [MeasurementItem]
    let count, remaining: Int
}

// MARK: - MeasurementItem
struct MeasurementItem: Codable {
    let additionalContent: String?
    let approved: String?
    let commentCreator: String?
    let productLaunchDateText: String?
    let thumbnailImage: String?
    let upvotes: [String]?
    let createdDate: String?
    let createdBy: String?
    let modifiedDate: String?
    let slug: String?
    let moderator1: String?
    let resultPublic: Bool?
    let title, publishDate: String?
    let admin1Approved: String?
    let moderator2: String?
    let admin2Approved: String?
    let id: String?
    let loudspeakerTags: [String]?
    let emailSent: Bool?

    enum CodingKeys: String, CodingKey {
        case additionalContent = "Additional content"
        case approved = "Approved"
        case commentCreator = "Comment Creator"
        case productLaunchDateText = "ProductLaunchDate(text)"
        case thumbnailImage = "Thumbnail image"
        case upvotes = "Upvotes"
        case createdDate = "Created Date"
        case createdBy = "Created By"
        case modifiedDate = "Modified Date"
        case slug = "Slug"
        case moderator1 = "Moderator1"
        case resultPublic = "Public"
        case title = "Title"
        case publishDate = "_Publish Date"
        case admin1Approved = "Admin1 Approved"
        case moderator2 = "Moderator2"
        case admin2Approved = "Admin2 Approved"
        case id = "_id"
        case loudspeakerTags = "Loudspeaker tags"
        case emailSent = "Email Sent"
    }
}

enum Approved: String, Codable {
    case approved = "Approved"
    case incomplete = "Incomplete"
}

enum LoudspeakerTag: String, Codable {
    case activeSystem = "Active System"
    case asymmetricalHorn = "Asymmetrical Horn"
    case lineArray = "Line Array"
    case passiveSystem = "Passive System"
    case pointSource = "Point Source"
    case rotatableHorn = "Rotatable Horn"
    case selfPowered = "Self-powered"
    case selfPoweredLoudspeaker = "Self-Powered Loudspeaker"
    case stageMonitor = "Stage Monitor"
    case studioMonitor = "Studio Monitor"
    case subwoofer = "Subwoofer"
}

enum Moderator: String, Codable {
    case the1600973407305X257296595428260670 = "1600973407305x257296595428260670"
    case the1607464137603X589364309815884300 = "1607464137603x589364309815884300"
    case the1607527700369X329045818913127100 = "1607527700369x329045818913127100"
    case the1608257411722X564547349185951170 = "1608257411722x564547349185951170"
}
