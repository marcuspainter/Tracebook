import Foundation

class TracebookAPI {
    // Tokens look like this (Sample expired token)
    let token = "3f600fe8b64b951f4dc87d867400f0f4"
    let startDate: Date = ISO8601DateFormatter().date(from: "2022-01-31T02:22:40Z")!

    init() {
    }

    func buildRequest(entity: String) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "trace-book.org"
        components.path = "/api/1.1/obj/\(entity)"

        let url = components.url!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        // request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        request.httpMethod = "GET"

        return request
    }
    
    func getResponse<T: Decodable>(_ type: T.Type, for request: URLRequest) async -> T? {
        do {
            let (jsonData, _ /* response */ ) = try await URLSession.shared.data(for: request)
            let reponse = try JSONDecoder().decode(type, from: jsonData)
            return reponse
        } catch {
            print("Request error: \(error)")
        }
        return nil
    }

    func getUser(id: String) async -> UserResponse? {
        let request = buildRequest(entity: "user")
        
        let userResponse =  await getResponse(UserResponse.self, for: request)

        do {
            let (jsonData, _ /* response */ ) = try await URLSession.shared.data(for: request)
            let userResponse = try JSONDecoder().decode(UserResponse.self, from: jsonData)
            return userResponse
        } catch {
            print("User \(id): \(error)")
        }

        return nil
    }

    func getAnalyzerList() async -> AnalyzerListResponse? {
        let request = buildRequest(entity: "analyzer")

        do {
            let (jsonData, _ /* response */ ) = try await URLSession.shared.data(for: request)
            let analyzerListResponse = try JSONDecoder().decode(AnalyzerListResponse.self, from: jsonData)
            return analyzerListResponse
        } catch {
            print("Analyzer List: \(error)")
        }

        return nil
    }

    func getMicrophoneList() async -> MicrophoneListResponse? {
        let request = buildRequest(entity: "microphone")

        do {
            let (jsonData, _ /* response */ ) = try await URLSession.shared.data(for: request)
            let microphoneListResponse = try JSONDecoder().decode(MicrophoneListResponse.self, from: jsonData)
            return microphoneListResponse
        } catch {
            print("Microphone List: \(error)")
        }

        return nil
    }

    func getInterfaceList() async -> InterfaceListResponse? {
        let request = buildRequest(entity: "interface")

        do {
            let (jsonData, _ /* response */ ) = try await URLSession.shared.data(for: request)
            let interfaceListResponse = try JSONDecoder().decode(InterfaceListResponse.self, from: jsonData)
            return interfaceListResponse
        } catch {
            print("Interface List: \(error)")
        }

        return nil
    }

    func getMeasurementContent(id: String) async -> MeasurementContentResponse? {
        let request = buildRequest(entity: "measurementcontent/\(id)")

        do {
            let (jsonData, _ /* response */ ) = try await URLSession.shared.data(for: request)
            let measurementContentResponse = try JSONDecoder().decode(MeasurementContentResponse.self, from: jsonData)
            return measurementContentResponse
        } catch {
            print("Measurement \(id):  \(error)")
        }

        return nil
    }

    func getMeasurementList(cursor: Int = 0) async -> MeasurementListResponse? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "trace-book.org"
        components.path = "/api/1.1/obj/measurement"
        components.queryItems = [
            URLQueryItem(name: "constraints",
                         value: #"[ { "key": "public", "constraint_type": "equals", "value": "true"} ]"#),
            URLQueryItem(name: "cursor", value: "\(cursor)"),
            URLQueryItem(name: "additional_sort_fields",
                         value: #"[ { "sort_field": "Created Date", "descending": "true"} ]"#)
        ]

        let url = components.url!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        // request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        request.httpMethod = "GET"

        do {
            let (jsonData, _ /* response */ ) = try await URLSession.shared.data(for: request)
            let measurementListResponse = try JSONDecoder().decode(MeasurementListResponse.self, from: jsonData)
            return measurementListResponse
        } catch {
            print("Measurement List: \(error)")
        }

        return nil
    }
    
    func getMeasurementListbyDate(cursor: Int = 0, dateString: String) async -> MeasurementListResponse? {
        //let formatter = ISO8601DateFormatter()
        //let dateString = formatter.string(from: date)
        print(dateString)
              
        let query = 
            #"[ { "key": "public", "constraint_type": "equals", "value": "true"},"#
            + #"{ "key": "Created Date", "constraint_type": "greater than", "value": ""# + dateString + #"" }]"#
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "trace-book.org"
        components.path = "/api/1.1/obj/measurement"
        components.queryItems = [
            URLQueryItem(name: "constraints", value: query),
            URLQueryItem(name: "cursor", value: "\(cursor)"),
            URLQueryItem(name: "additional_sort_fields",
                         value: #"[ { "sort_field": "Created Date", "descending": "true"} ]"#)
        ]

        let url = components.url!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        // request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        request.httpMethod = "GET"

        do {
            let (jsonData, _ /* response */ ) = try await URLSession.shared.data(for: request)
            let measurementListResponse = try JSONDecoder().decode(MeasurementListResponse.self, from: jsonData)
            return measurementListResponse
        } catch {
            print("Measurement List: \(error)")
        }

        return nil
    }

    func loadList() -> MeasurementListResponse? {
        var result: MeasurementListResponse?

        if let fileURL = Bundle.main.url(forResource: "measurement", withExtension: "json") {
            print("Found file")
            do {
                let jsonData = try Data(contentsOf: fileURL)
                result = try JSONDecoder().decode(MeasurementListResponse.self, from: jsonData)
            } catch {
                print("Loading file error", error)
            }
        }
        return result
    }

    func loadContent(id: String) -> MeasurementContentResponse? {
        var result: MeasurementContentResponse?

        if let fileURL = Bundle.main.url(forResource: "measurementcontent", withExtension: "json") {
            print("Found file")
            do {
                let jsonData = try Data(contentsOf: fileURL)
                result = try JSONDecoder().decode(MeasurementContentResponse.self, from: jsonData)
            } catch {
                print("Loading file error", error)
            }
        }
        return result
    }
}

extension Date {
    init?(iso: String) {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: iso) else {
            return nil
        }
        self = date
    }
}
