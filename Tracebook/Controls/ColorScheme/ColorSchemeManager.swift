//
//  ColorSchemeManager.swift
//  LightOrDark
//
//  Adapted by Marcus Painter on 2023-11-25
//

// https://www.youtube.com/watch?v=PbryeZmJRmA
// https://github.com/StewartLynch/LightOrDark/tree/main
// https://stackoverflow.com/questions/58476048/implement-dark-mode-switch-in-swiftui-app
// https://sarunw.com/posts/swiftui-picker-enum/

import SwiftUI

/// Manages the app color scheme and stores scheme in UserDefaults
public class ColorSchemeManager: ObservableObject {
    /// Shared instance
    public static let shared = ColorSchemeManager()
    /// User default key name
    public static var keyName: String = "colorScheme"

    /// Private initializer.
    private init() {
    }

    /// Color schemes
    enum ColorSchemeType: Int, CaseIterable, Identifiable, CustomStringConvertible {
        case unspecified
        case light
        case dark

        var id: Self { self }

        var description: String {
            switch self {
            case .unspecified:
                return "Auto"
            case .light:
                return "Light"
            case .dark:
                return "Dark"
            }
        }
    }

    /// Sets the color scheme. Setting this property will apply the scheme
    @AppStorage(ColorSchemeManager.keyName) var colorScheme: ColorSchemeType = .unspecified {
        didSet {
            applyColorScheme()
        }
    }

    /// Applys the selected color scheme to the app
    public func applyColorScheme() {
        keyWindow?.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: colorScheme.rawValue)!
    }

    /// Gets the underlying window to apply the color scheme
    private var keyWindow: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return nil
        }
        return window
    }
}
