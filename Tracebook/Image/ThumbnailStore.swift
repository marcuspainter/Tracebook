//
//  ThumbnailStore.swift
//  Tracebook
//

import CryptoKit
import Foundation
import ImageIO
import UIKit

struct ThumbnailRequest: Sendable {
    let measurementID: String
    let remotePath: String
}

actor ThumbnailStore {
    static let shared = ThumbnailStore()

    private let memoryCache = NSCache<NSString, UIImage>()
    private let maximumPixelSize = 225
    private let jpegQuality = 0.78
    private let session: URLSession
    private let directoryURL: URL?
    private var generation = 0

    init(session: URLSession = .shared, directoryURL: URL? = nil) {
        self.session = session
        self.directoryURL = directoryURL
    }

    func image(for measurementID: String, remotePath: String) async -> UIImage? {
        guard let remoteURL = Self.remoteURL(from: remotePath) else { return nil }
        let requestGeneration = generation

        let cacheKey = Self.cacheKey(measurementID: measurementID, remoteURL: remoteURL)
        if let cachedImage = memoryCache.object(forKey: cacheKey as NSString) {
            return cachedImage
        }

        guard let fileURL = try? fileURL(for: cacheKey) else { return nil }
        if let image = UIImage(contentsOfFile: fileURL.path) {
            memoryCache.setObject(image, forKey: cacheKey as NSString)
            return image
        }

        do {
            let (data, response) = try await session.data(from: remoteURL)
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else { return nil }
            }
            guard let thumbnail = Self.downsample(data: data, maximumPixelSize: maximumPixelSize),
                  let jpegData = thumbnail.jpegData(compressionQuality: jpegQuality) else {
                return nil
            }
            guard requestGeneration == generation else { return nil }

            try removeObsoleteThumbnails(for: measurementID, keeping: fileURL)
            try jpegData.write(to: fileURL, options: .atomic)
            memoryCache.setObject(thumbnail, forKey: cacheKey as NSString)
            return thumbnail
        } catch {
            return nil
        }
    }

    func prefetch(_ requests: [ThumbnailRequest]) async {
        var iterator = requests.filter { !$0.remotePath.isEmpty }.makeIterator()

        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<4 {
                guard let request = iterator.next() else { break }
                group.addTask {
                    _ = await self.image(
                        for: request.measurementID,
                        remotePath: request.remotePath
                    )
                }
            }

            while await group.next() != nil {
                guard let request = iterator.next() else { continue }
                group.addTask {
                    _ = await self.image(
                        for: request.measurementID,
                        remotePath: request.remotePath
                    )
                }
            }
        }
    }

    func removeAll() throws {
        generation += 1
        memoryCache.removeAllObjects()

        let directory = try thumbnailDirectory()
        let files = try FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: nil
        )
        for fileURL in files {
            try FileManager.default.removeItem(at: fileURL)
        }
    }

    private func fileURL(for cacheKey: String) throws -> URL {
        let directory = try thumbnailDirectory()
        return directory.appendingPathComponent(cacheKey).appendingPathExtension("jpg")
    }

    private func thumbnailDirectory() throws -> URL {
        if let directoryURL {
            if !FileManager.default.fileExists(atPath: directoryURL.path) {
                try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            }
            return directoryURL
        }

        let applicationSupport = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let directory = applicationSupport.appendingPathComponent("Thumbnails", isDirectory: true)

        if !FileManager.default.fileExists(atPath: directory.path) {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            var values = URLResourceValues()
            values.isExcludedFromBackup = true
            var mutableDirectory = directory
            try mutableDirectory.setResourceValues(values)
        }

        return directory
    }

    private func removeObsoleteThumbnails(for measurementID: String, keeping fileURL: URL) throws {
        let directory = try thumbnailDirectory()
        let prefix = Self.safeIdentifier(measurementID) + "-"
        let files = try FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: nil
        )

        for existingURL in files where existingURL.lastPathComponent.hasPrefix(prefix) && existingURL != fileURL {
            try? FileManager.default.removeItem(at: existingURL)
        }
    }

    private static func cacheKey(measurementID: String, remoteURL: URL) -> String {
        let digest = SHA256.hash(data: Data(remoteURL.absoluteString.utf8))
        let urlHash = digest.prefix(8).map { String(format: "%02x", $0) }.joined()
        return "\(safeIdentifier(measurementID))-\(urlHash)"
    }

    private static func safeIdentifier(_ value: String) -> String {
        value.map { character in
            character.isLetter || character.isNumber || character == "-" || character == "_"
                ? character
                : "_"
        }.reduce(into: "") { $0.append($1) }
    }

    private static func remoteURL(from path: String) -> URL? {
        guard !path.isEmpty else { return nil }
        if path.hasPrefix("//") {
            return URL(string: "https:\(path)")
        }
        if path.hasPrefix("http://") || path.hasPrefix("https://") {
            return URL(string: path)
        }
        return URL(string: "https://\(path)")
    }

    private static func downsample(data: Data, maximumPixelSize: Int) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maximumPixelSize,
            kCGImageSourceShouldCacheImmediately: true
        ]
        guard let image = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
            return nil
        }
        return UIImage(cgImage: image)
    }
}
