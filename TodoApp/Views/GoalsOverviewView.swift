import SwiftUI

struct GoalsOverviewView: View {
    private let goals = [
        GoalSummary(title: "Weekly Goals", subtitle: "Plan and finish weekly priorities", progress: 0.20, iconName: "square.stack.3d.up.fill", colors: [.blue, .cyan]),
        GoalSummary(title: "Books", subtitle: "Keep a steady reading habit", progress: 0.40, iconName: "book.closed.fill", colors: [.indigo, .blue]),
        GoalSummary(title: "Focus", subtitle: "Reduce overdue pending tasks", progress: 0.65, iconName: "target", colors: [.purple, .pink]),
        GoalSummary(title: "Routine", subtitle: "Review tasks every morning", progress: 0.80, iconName: "sun.max.fill", colors: [.orange, .yellow])
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                ForEach(goals) { goal in
                    GoalDetailCard(goal: goal)
                }
            }
            .padding(18)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct GoalSummary: Identifiable {
    let title: String
    let subtitle: String
    let progress: Double
    let iconName: String
    let colors: [Color]

    var id: String { title }
}

private struct GoalDetailCard: View {
    let goal: GoalSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                Image(systemName: goal.iconName)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(.white.opacity(0.18), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)
                    Text(goal.subtitle)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.84))
                }
            }

            ProgressView(value: goal.progress)
                .tint(.white)

            Text("\(Int(goal.progress * 100))% complete")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.90))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(colors: goal.colors, startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 8, style: .continuous)
        )
    }
}

#Preview {
    NavigationStack {
        GoalsOverviewView()
    }
}
