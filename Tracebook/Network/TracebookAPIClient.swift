import Foundation

class TracebookAPIClient {
    let token = "3f600fe8b64b951f4dc87d867400f0f4"

    init() {
    }

    func getMicrophoneList() async -> MicrophoneListResponse? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "trace-book.org"
        components.path = "/api/1.1/obj/microphone"

        let url = components.url!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        request.httpMethod = "GET"

        print(url)

        do {
            let (jsonData, _ /* response */ ) = try await URLSession.shared.data(for: request)
            let microphoneListResponse = try JSONDecoder().decode(MicrophoneListResponse.self, from: jsonData)
            return microphoneListResponse
        } catch {
            print("")
            print(error)
        }

        return nil
    }

    func getInterfaceList() async -> InterfaceListResponse? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "trace-book.org"
        components.path = "/api/1.1/obj/interface"

        let url = components.url!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        request.httpMethod = "GET"

        print(url)

        do {
            let (jsonData, _ /* response */ ) = try await URLSession.shared.data(for: request)
            let interfaceListResponse = try JSONDecoder().decode(InterfaceListResponse.self, from: jsonData)
            return interfaceListResponse
        } catch {
            print("")
            print(error)
        }

        return nil
    }

    func getMeasurementContent(id: String) async -> MeasurementContentResponse? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "trace-book.org"
        components.path = "/api/1.1/obj/measurementcontent/\(id)"

        print(id)

        if let url = components.url {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
            request.httpMethod = "GET"

            print(url)

            do {
                let (jsonData, _ /* response */ ) = try await URLSession.shared.data(for: request)
                let measurementContentResponse = try JSONDecoder().decode(MeasurementContentResponse.self, from: jsonData)
                return measurementContentResponse
            } catch {
                print("")
                print(error)
            }
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
                         value: "[ { \"key\": \"public\", \"constraint_type\": \"equals\", \"value\": \"true\"} ]"),
            URLQueryItem(name: "cursor", value: "\(cursor)"),
            URLQueryItem(name: "additional_sort_fields", value: "[ { \"sort_field\": \"Created Date\", \"descending\": \"true\"} ]")
        ]

        let url = components.url!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        request.httpMethod = "GET"

        print(url)

        do {
            let (jsonData, response) = try await URLSession.shared.data(for: request)
            let measurementListResponse = try JSONDecoder().decode(MeasurementListResponse.self, from: jsonData)
            return measurementListResponse

        } catch {
            print(error)
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
                print("loading file error", error)
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
                print("loading file error", error)
            }
        }
        return result
    }
}
