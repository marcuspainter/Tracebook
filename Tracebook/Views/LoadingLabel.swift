import SwiftUI

struct LoadingLabel: View {
    var body: some View {
        VStack(spacing: 8) {
            ProgressView()
            Text("Loading…")
                .font(.body)
        }
    }
}
