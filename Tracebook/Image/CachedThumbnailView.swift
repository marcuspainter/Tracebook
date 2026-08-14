//
//  CachedThumbnailView.swift
//  Tracebook
//

import SwiftUI

struct CachedThumbnailView: View {
    let measurementID: String
    let remotePath: String

    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: "photo")
                    .imageScale(.large)
                    .foregroundStyle(.gray)
            }
        }
        .task(id: "\(measurementID)|\(remotePath)") {
            image = await ThumbnailStore.shared.image(
                for: measurementID,
                remotePath: remotePath
            )
        }
    }
}
