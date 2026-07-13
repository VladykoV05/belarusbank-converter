import SwiftUI

struct ErrorView: View {
    let error: String
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title2)
                .foregroundStyle(.red)

            Text(error)
                .multilineTextAlignment(.center)
                .foregroundStyle(.red)

            Button("Повторить попытку", action: retryAction)
                .buttonStyle(.bordered)
        }
        .padding()
    }
}
