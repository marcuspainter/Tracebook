import SwiftUI

struct LoadingLabel: View {
    var body: some View {
        HStack(spacing: 8) {
            ProgressView()
                .controlSize(.small)
            Text("Loading…")
        }
    }
}
