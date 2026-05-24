import SwiftUI

struct NotificationsView: View {
    let viewModel: TodoListViewModel

    private var notifications: [TodoNotification] {
        if viewModel.todos.isEmpty {
            return [
                TodoNotification(title: "No task reminders", message: "Add a todo with date and time to see reminders here.", iconName: "bell.slash", color: .secondary)
            ]
        }

        return viewModel.todos.map { todo in
            TodoNotification(
                title: todo.title,
                message: "Due \(todo.dueDate.formatted(date: .abbreviated, time: .omitted)) at \(todo.dueTime.formatted(date: .omitted, time: .shortened))",
                iconName: todo.isCompleted ? "checkmark.circle.fill" : "bell.badge",
                color: todo.isCompleted ? .green : .blue
            )
        }
    }

    var body: some View {
        List {
            Section {
                HStack(spacing: 14) {
                    Image(systemName: "bell.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .frame(width: 54, height: 54)
                        .background(Color.blue, in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Notifications")
                            .font(.headline.weight(.semibold))
                        Text("Task reminders and status updates")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 6)
            }

            Section("Today") {
                ForEach(notifications) { notification in
                    NotificationRow(notification: notification)
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

private struct TodoNotification: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let iconName: String
    let color: Color
}

private struct NotificationRow: View {
    let notification: TodoNotification

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: notification.iconName)
                .font(.headline)
                .foregroundStyle(notification.color)
                .frame(width: 30, height: 30)
                .background(notification.color.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(notification.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)

                Text(notification.message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    NavigationStack {
        NotificationsView(viewModel: TodoListViewModel())
    }
}
