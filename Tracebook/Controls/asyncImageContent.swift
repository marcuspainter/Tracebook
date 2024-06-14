//
//  AsyncImageNotFound.swift
//  Tracebook
//
//  Created by Marcus Painter on 07/12/2023.
//

// https://www.hackingwithswift.com/forums/swiftui/variables-in-url-string-not-working-for-asyncimage/14244
// https://medium.com/@artemnovichkov/asyncimage-loading-images-in-swiftui-b6d57dee4f0c

import Foundation
import SwiftUI

@ViewBuilder
func asyncImageContent(for phase: AsyncImagePhase) -> some View {
    switch phase {
    case .empty:
        ProgressView()
    case let .success(image):
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
    case .failure:
        Image(systemName: "photo")
            .imageScale(.large)
            .foregroundColor(.gray)
    @unknown default:
        Text("Unknown")
            .foregroundColor(.gray)
    }
}
