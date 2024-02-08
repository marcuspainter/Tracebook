//
//  DismissButton.swift
//  MPAudioAnalyzer
//
//  Created by Marcus Painter on 01/12/2023.
//

import Foundation
import SwiftUI


struct DismissButton: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image(systemName: "xmark.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color.primary)
        })
    }
}
