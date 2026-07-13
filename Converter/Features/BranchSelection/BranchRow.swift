import SwiftUI

struct BranchRow: View {
    let branch: BankBranch
    let isFavorite: Bool
    let onSelect: () -> Void
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onSelect) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(branch.displayName)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(branch.fullAddress)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if branch.settlementTypeCode != "" {
                        Text(branch.settlementType)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.accentColor.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)

            Button(action: onToggleFavorite) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .font(.title3)
                    .symbolEffect(.bounce, value: isFavorite)
                    .foregroundStyle(isFavorite ? .yellow : .secondary)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
