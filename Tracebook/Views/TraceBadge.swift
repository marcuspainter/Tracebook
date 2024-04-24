//
//  TraceBadge.swift
//  Tracebook
//
//  Created by Marcus Painter on 22/04/2024.
//

import Foundation
import SwiftUI

struct TraceBadge: View {
    let text: String
    let color: Color
    let isEnabled: Bool

    var body: some View {
        if isEnabled {
            Text(text)
                .padding(5)
                .background(color)
                .cornerRadius(5)
        } else {
            Text(text)
                .padding(5)
                .foregroundColor(Color(.systemGray))
                .overlay( // apply a rounded border
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 1))
        }
    }
}
