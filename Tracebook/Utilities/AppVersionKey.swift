//
//  AppVersion.swift
//  MPAudioAnalyzer
//
//  Created by Marcus Painter on 01/12/2023.
//

import Foundation
import SwiftUI

// https://sarunw.com/posts/how-to-define-custom-environment-values-in-swiftui/

private struct AppVersionKey: EnvironmentKey {
    static let defaultValue: String = appVersion()
}

extension EnvironmentValues {
    var appVersion: String {
        { self[AppVersionKey.self] }()
    }
}

func appVersion() -> String {
    let dictionary = Bundle.main.infoDictionary!
    let version = dictionary["CFBundleShortVersionString"] ?? ""
    return "\(version)"
}
