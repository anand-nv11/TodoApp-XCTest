import SwiftUI

struct ListsOverviewView: View {
    let viewModel: TodoListViewModel

    private var listSummaries: [ListSummary] {
        [
            ListSummary(title: "Personal Tasks", count: viewModel.pendingCount, iconName: "person.fill", colors: [.pink, .red]),
            ListSummary(title: "Java Exercise", count: 2, iconName: "figure.run", colors: [.orange, .yellow]),
            ListSummary(title: "Swift Writing", count: 13, iconName: "pencil", colors: [.teal, .cyan]),
            ListSummary(title: "Completed", count: viewModel.completedCount, iconName: "checkmark.circle.fill", colors: [.green, .mint])
        ]
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                ForEach(listSummaries) { summary in
                    OverviewCard(summary: summary)
                }
            }
            .padding(18)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Lists")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ListSummary: Identifiable {
    let title: String
    let count: Int
    let iconName: String
    let colors: [Color]

    var id: String { title }
}

private struct OverviewCard: View {
    let summary: ListSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: summary.iconName)
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)

            Spacer(minLength: 18)

            Text(summary.title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            Text("\(summary.count) item")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity, minHeight: 136, alignment: .leading)
        .padding(16)
        .background(
            LinearGradient(colors: summary.colors, startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 8, style: .continuous)
        )
    }
}

#Preview {
    NavigationStack {
        ListsOverviewView(viewModel: TodoListViewModel())
    }
}
