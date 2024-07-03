//
//  BubbleAPI.swift
//  Tracebook
//
//  Created by Marcus Painter on 30/06/2024.
//

import Foundation

final class BubbleTestAPI: BubbleAPIProtocol, Sendable {
    
    let settings: BubbleTestAPISettings
    
    init (settings: BubbleTestAPISettings) {
        self.settings = settings
    }
    
    init() {
        
        let urlMap = [
            "/api/1.1/obj/measurement" : "measurement",
            "/api/1.1/obj/measurementcontent" : "measurementcontent",
            "/api/1.1/obj/microphone" : "microphone",
            "/api/1.1/obj/interface" : "interface",
            "/api/1.1/obj/analyzer" : "analyzer"
        ]
        self.settings = BubbleTestAPISettings(urlMap: urlMap)
    }
    
    func getResponse<T: Decodable>(_ type: T.Type, for request: URLRequest) async throws -> T? {
        
        guard let path = request.url?.path else {
            print("No path")
            throw BubbleAPIError.networkError
        }
        
        print(">>> ", path)
        
        guard let filename = settings.urlMap[path] else {
            print("No filename")
            throw BubbleAPIError.networkError
        }
        
        print(">>> ", filename)
        
        do {
            
            if let jsonData = await fileData(filename: filename) {
                
                // Parse JSON
                let jsonResponse = try JSONDecoder().decode(type, from: jsonData)
                return jsonResponse
            }

        } catch {
            print("File error: \(error)")
        }
        throw BubbleAPIError.networkError
    }
    
    func fileData(filename: String) async -> Data? {
        
        if let data = loadJSON(from: filename) {
            return data
        }
        return nil
    }
    
    func loadJSON(from filename: String) -> Data? {
        guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("File not found")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            print("Error reading data: \(error.localizedDescription)")
            return nil
        }
    }
}
