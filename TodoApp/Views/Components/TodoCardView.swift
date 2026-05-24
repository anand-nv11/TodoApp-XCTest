import SwiftUI

struct TodoCardView: View {
    let todo: TodoItem
    let toggleCompletion: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Button(action: toggleCompletion) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(todo.isCompleted ? .green : .secondary)
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(todo.isCompleted ? "Mark as pending" : "Mark as completed")

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(todo.title)
                        .font(.headline)
                        .foregroundStyle(todo.isCompleted ? .secondary : .primary)
                        .strikethrough(todo.isCompleted, color: .secondary)
                        .lineLimit(2)

                    Spacer(minLength: 8)

                    StatusBadge(isCompleted: todo.isCompleted)
                }

                if !todo.details.isEmpty {
                    Text(todo.details)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                HStack(spacing: 12) {
                    MetadataLabel(
                        title: todo.dueTime.formatted(date: .omitted, time: .shortened),
                        systemImage: "clock"
                    )

                    MetadataLabel(
                        title: todo.dueDate.formatted(date: .abbreviated, time: .omitted),
                        systemImage: "calendar"
                    )
                }
            }
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(.separator.opacity(0.35))
        }
        .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

private struct MetadataLabel: View {
    let title: String
    let systemImage: String

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.caption)
            .foregroundStyle(.secondary)
            .lineLimit(1)
    }
}

private struct StatusBadge: View {
    let isCompleted: Bool

    var body: some View {
        Text(isCompleted ? "Completed" : "Pending")
            .font(.caption.weight(.semibold))
            .foregroundStyle(isCompleted ? .green : .orange)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background((isCompleted ? Color.green : Color.orange).opacity(0.12), in: Capsule())
    }
}

#Preview {
    TodoCardView(
        todo: TodoItem(title: "Prepare demo", details: "Review MVVM structure and local storage.", dueDate: .now),
        toggleCompletion: {}
    )
    .padding()
}
