import Foundation

typealias MeasurementListResponse = BubbleListResponse<MeasurementBody>
typealias MeasurementContentItemResponse = BubbleItemResponse<MeasurementContentBody>
typealias MicrophoneListResponse = BubbleListResponse<MicrophoneBody>
typealias AnalyzerListResponse = BubbleListResponse<AnalyzerBody>
typealias InterfaceListResponse = BubbleListResponse<InterfaceBody>

// Future
typealias UserItemResponse = BubbleItemResponse<UserBody>
typealias UserListResponse = BubbleListResponse<UserBody>

final class TracebookAPI: Sendable {
    // Tokens look like this (Sample expired token)
    let token = "3f600fe8b64b951f4dc87d867400f0f4"

    private func getResponse<T: Decodable>(_ type: T.Type, for request: URLRequest) async -> T? {
        do {
            let (jsonData, _ /* response */ ) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(type, from: jsonData)
            return response
        } catch {
            print("Request error: \(error)")
        }
        return nil
    }
/*
    func getUser(id: String) async -> UserItemResponse? {
        let bubbleRequest = BubbleRequest(entity: "user")
        let urlRequest = bubbleRequest.urlRequest()
        let response = await getResponse(UserItemResponse.self, for: urlRequest)
        return response
    }
*/
    func getAnalyzerList() async -> AnalyzerListResponse? {
        let bubbleRequest = BubbleRequest(entity: "analyzer")
        let urlRequest = bubbleRequest.urlRequest()
        let response = await getResponse(AnalyzerListResponse.self, for: urlRequest)
        return response
    }

    func getMicrophoneList() async -> MicrophoneListResponse? {
        let bubbleRequest = BubbleRequest(entity: "microphone")
        let urlRequest = bubbleRequest.urlRequest()
        let response = await getResponse(MicrophoneListResponse.self, for: urlRequest)
        return response
    }

    func getInterfaceList() async -> InterfaceListResponse? {
        let bubbleRequest = BubbleRequest(entity: "interface")
        let urlRequest = bubbleRequest.urlRequest()
        let response = await getResponse(InterfaceListResponse.self, for: urlRequest)
        return response
    }

    func getMeasurementContent(id: String) async -> MeasurementContentItemResponse? {
        let bubbleRequest = BubbleRequest(entity: "measurementcontent", id: id)
        let urlRequest = bubbleRequest.urlRequest()
        let response = await getResponse(MeasurementContentItemResponse.self, for: urlRequest)
        return response
    }

    func getMeasurementListByDate(cursor: Int = 0, dateString: String = "2001-01-01T00:00:00.000Z") async -> MeasurementListResponse? {
        let bubbleRequest = BubbleRequest(entity: "measurement")
        bubbleRequest.cursor = cursor
        bubbleRequest.constraints.append(BubbleConstraint(key: MeasurementBody.CodingKeys.isPublic.rawValue, type: .equals, value: "true"))
        bubbleRequest.constraints.append(BubbleConstraint(key: MeasurementBody.CodingKeys.createdDate.rawValue, type: .greaterThan, value: dateString))
        bubbleRequest.sortKeys.append(BubbleSortKey(sortField: MeasurementBody.CodingKeys.createdDate.rawValue, order: .descending))

        let urlRequest = bubbleRequest.urlRequest()
        let response = await getResponse(MeasurementListResponse.self, for: urlRequest)
        return response
    }
}
