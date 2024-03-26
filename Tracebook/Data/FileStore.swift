//
//  FileStore.swift
//  Tracebook
//
//  Created by Marcus Painter on 22/02/2024.
//

import Foundation

class FileStore<T: Codable> {
    let folderName: String

    init(folderName: String) {
        self.folderName = folderName
    }

    func save(_ object: T, withName name: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents directory not found")
            return
        }

        let folderURL = documentsDirectory.appendingPathComponent(folderName, isDirectory: true)

        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)

            let fileURL = folderURL.appendingPathComponent(name)
            let data = try JSONEncoder().encode(object)
            try data.write(to: fileURL)
            print("Object saved successfully")
        } catch {
            print("Failed to save object:", error.localizedDescription)
        }
    }

    func load(withName name: String) -> T? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents directory not found")
            return nil
        }

        let folderURL = documentsDirectory.appendingPathComponent(folderName, isDirectory: true)
        let fileURL = folderURL.appendingPathComponent(name)

        do {
            let data = try Data(contentsOf: fileURL)
            let object = try JSONDecoder().decode(T.self, from: data)
            print("Object loaded successfully")
            return object
        } catch {
            print("Failed to load object:", error.localizedDescription)
            return nil
        }
    }
}
