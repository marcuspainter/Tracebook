//
//  AppConfig.swift
//  Tracebook
//
//  Created by Marcus Painter on 16/01/2024.
//

// https://sarunw.com/posts/how-to-read-plist-file/

import Foundation

class AppConfig {
    var config: [String: Any]?

    init() {
        if let infoPlistPath = Bundle.main.url(forResource: "Config", withExtension: "plist") {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)

                if let dictionary = try PropertyListSerialization.propertyList(from: infoPlistData,
                                                                         options: [],
                                                                         format: nil) as? [String: Any] {
                    config = dictionary
                }
            } catch {
                print(error)
            }
        }
    }
}
