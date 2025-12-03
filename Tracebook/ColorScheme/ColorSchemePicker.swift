//
//  ColorSchemePicker.swift
//  SoundAnalyzer
//
//  Created by Marcus Painter on 25/11/2023.
//

import SwiftUI

struct ColorSchemePicker: View {
    @ObservedObject var colorSchemeManager = ColorSchemeManager.shared
    let text: String

    init(_ text: String = "Color Scheme") {
        self.text = text
    }

    var body: some View {
        Picker(text, selection: $colorSchemeManager.colorScheme) {
            ForEach(ColorSchemeManager.ColorSchemeType.allCases) { scheme in
                Text(String(describing: scheme))
            }
        }
    }
}

#Preview {
    ColorSchemePicker()
}
