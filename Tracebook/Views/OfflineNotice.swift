import SwiftUI

struct OfflineNotice: View {
    let isPresented: Bool
    var isRetrying = false
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

                    Button(action: retry) {
                        Group {
                            if isRetrying {
                                LoadingLabel()
                            } else {
                                Text("Try Again")
                            }
                        }
                        .frame(minWidth: 70)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isRetrying)
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
