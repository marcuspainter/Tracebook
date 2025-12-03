//
//  AppVersion.swift
//  MPAudioAnalyzer
//
//  Created by Marcus Painter on 01/12/2023.
//

// https://sarunw.com/posts/how-to-define-custom-environment-values-in-swiftui/

import Foundation
import SwiftUI

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

private struct AppBuildKey: EnvironmentKey {
    static let defaultValue: String = appBuild()
}

extension EnvironmentValues {
    var appBuild: String {
        { self[AppBuildKey.self] }()
    }
}

func appBuild() -> String {
    let dictionary = Bundle.main.infoDictionary!
    let build = dictionary["CFBundleVersion"] ?? ""
    return "\(build)"
}
