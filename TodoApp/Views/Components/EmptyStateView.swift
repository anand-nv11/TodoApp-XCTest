import SwiftUI

struct EmptyStateView: View {
    let isSearching: Bool

    var body: some View {
        VStack(spacing: 16) {
            if isSearching {
                SearchEmptyImage()
                    .frame(width: 128, height: 112)
            } else {
                MoleculeEmptyImage()
                    .frame(width: 150, height: 126)
            }

            Text(isSearching ? "No Results" : "No Todos Yet")
                .font(.headline.weight(.semibold))

            Text(isSearching ? "Try another title or description." : "Add your first todo to start tracking your work.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
    }
}

private struct MoleculeEmptyImage: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.10), Color.cyan.opacity(0.08), Color.pink.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 126, height: 104)
                .rotationEffect(.degrees(-6))

            moleculeLine(from: CGPoint(x: 38, y: 76), to: CGPoint(x: 70, y: 44))
            moleculeLine(from: CGPoint(x: 70, y: 44), to: CGPoint(x: 108, y: 64))
            moleculeLine(from: CGPoint(x: 70, y: 44), to: CGPoint(x: 64, y: 92))
            moleculeLine(from: CGPoint(x: 108, y: 64), to: CGPoint(x: 120, y: 30))

            moleculeNode(color: .blue, size: 34)
                .position(x: 38, y: 76)

            moleculeNode(color: .purple, size: 42)
                .position(x: 70, y: 44)

            moleculeNode(color: .teal, size: 30)
                .position(x: 108, y: 64)

            moleculeNode(color: .orange, size: 26)
                .position(x: 64, y: 92)

            moleculeNode(color: .pink, size: 24)
                .position(x: 120, y: 30)
        }
        .frame(width: 150, height: 126)
        .accessibilityHidden(true)
    }

    private func moleculeLine(from start: CGPoint, to end: CGPoint) -> some View {
        Path { path in
            path.move(to: start)
            path.addLine(to: end)
        }
        .stroke(Color.blue.opacity(0.22), style: StrokeStyle(lineWidth: 4, lineCap: .round))
    }

    private func moleculeNode(color: Color, size: CGFloat) -> some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [color.opacity(0.95), color.opacity(0.58)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: size, height: size)
            .overlay {
                Circle()
                    .strokeBorder(.white.opacity(0.70), lineWidth: 2)
            }
            .shadow(color: color.opacity(0.25), radius: 8, x: 0, y: 5)
    }
}

private struct SearchEmptyImage: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.10))
                .frame(width: 96, height: 96)

            Image(systemName: "magnifyingglass")
                .font(.system(size: 42, weight: .semibold))
                .foregroundStyle(.blue)
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    EmptyStateView(isSearching: false)
}
