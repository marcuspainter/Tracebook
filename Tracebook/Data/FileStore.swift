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

import Foundation

enum FileStoreError: Error {
    case documentsDirectoryNotFound
    case dataEncodingFailed
    case dataWritingFailed
    case dataReadingFailed
    case dataDecodingFailed
}

struct ExampleStruct: Codable {
    var id: Int
    var name: String
    
    mutating func x() {
        id = 1
    }
}

func doSomething() async {
    let object = ExampleStruct(id: 1, name: "Thing")
    let exampleClass = ExampleClass<ExampleStruct>()
    await exampleClass.save(object)
}

class ExampleClass<T: Codable & Sendable> {
    
    func save(_ object: T) async {
        //let data = try! JSONEncoder().encode(object)
    }
}

class FileStore2<T: Codable & Sendable> {
    let folderName: String

    init(folderName: String) {
        self.folderName = folderName
    }
    
    func doSomething(object: T) async {
        let object = ExampleStruct(id: 1, name: "Thing")
        try! await save(object as! T, withName: "X")
    }

    func save(_ object: T, withName name: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    throw FileStoreError.documentsDirectoryNotFound
                }

                let folderURL = documentsDirectory.appendingPathComponent(folderName, isDirectory: true)
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)

                let fileURL = folderURL.appendingPathComponent(name)
                let data = try JSONEncoder().encode(object)
                try data.write(to: fileURL)
                print("Object saved successfully")
                continuation.resume(returning: ())
            } catch {
                continuation.resume(with: .failure(error))
            }
        }
    }

    func load(withName name: String) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    throw FileStoreError.documentsDirectoryNotFound
                }

                let folderURL = documentsDirectory.appendingPathComponent(folderName, isDirectory: true)
                let fileURL = folderURL.appendingPathComponent(name)

                let data = try Data(contentsOf: fileURL)
                let object = try JSONDecoder().decode(T.self, from: data)
                print("Object loaded successfully")
                continuation.resume(returning: object)
            } catch {
                continuation.resume(with: .failure(error))
            }
        }
    }
}


actor FileStoreManager {
    static let shared = FileStoreManager()

    init() {}

    func save<T: Encodable>(_ object: T, withName name: String, inFolder folderName: String) async throws {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileStoreError.documentsDirectoryNotFound
        }

        let folderURL = documentsDirectory.appendingPathComponent(folderName, isDirectory: true)
        try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)

        let fileURL = folderURL.appendingPathComponent(name)
        let data = try JSONEncoder().encode(object)
        try data.write(to: fileURL)
        print("Object saved successfully")
    }

    func load<T: Decodable>(withName name: String, fromFolder folderName: String) async throws -> T {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileStoreError.documentsDirectoryNotFound
        }

        let folderURL = documentsDirectory.appendingPathComponent(folderName, isDirectory: true)
        let fileURL = folderURL.appendingPathComponent(name)

        let data = try Data(contentsOf: fileURL)
        let object = try JSONDecoder().decode(T.self, from: data)
        print("Object loaded successfully")
        return object
    }
}

/*
// Define a global actor
@globalActor
actor GlobalFileStore {
    
    static let shared = FileStoreManager()
    
    static func save<T: Codable, Sendable>(_ object: T, withName name: String, inFolder folderName: String) async throws {
        try await shared.save(object, withName: name, inFolder: folderName)
    }
    
    static func load<T: Codable>(withName name: String, fromFolder folderName: String) async throws -> T {
        return try await shared.load(withName: name, fromFolder: folderName)
    }
}
*/
