import SwiftUI

struct LoadingLabel: View {
    enum Layout {
        case vertical
        case horizontal
    }

    var layout: Layout = .vertical

    var body: some View {
        switch layout {
        case .vertical:
            VStack(spacing: 8) {
                loadingContent
            }
        case .horizontal:
            HStack(spacing: 8) {
                loadingContent
            }
        }
    }

    @ViewBuilder
    private var loadingContent: some View {
        ProgressView()
        Text("Loading…")
            .font(.body)
    }
}
