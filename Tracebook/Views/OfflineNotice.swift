import SwiftUI

struct OfflineNotice: View {
    let isPresented: Bool
    let retry: () -> Void

    var body: some View {
        Group {
            if isPresented {
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
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.22), value: isPresented)
    }
}
