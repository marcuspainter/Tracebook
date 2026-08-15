import SwiftUI

struct OfflineNotice: View {
    let retry: () -> Void

    var body: some View {
        HStack {
            Label {
                Text("Offline")
                    .font(.headline)
            } icon: {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.yellow)
            }

            Spacer()

            Button("Try Again", action: retry)
                .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.bar)
    }
}
