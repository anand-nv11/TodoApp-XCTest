import SwiftData
import SwiftUI

struct TodoDetailView: View {
    @Environment(\.modelContext) private var modelContext

    let todo: TodoItem
    let viewModel: TodoListViewModel

    @State private var isShowingEditTodo = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(todo.title)
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(todo.isCompleted ? .secondary : .primary)
                            .strikethrough(todo.isCompleted, color: .secondary)

                        Spacer()

                        Label(todo.isCompleted ? "Completed" : "Pending", systemImage: todo.isCompleted ? "checkmark.circle.fill" : "clock")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(todo.isCompleted ? .green : .orange)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Label(todo.dueDate.formatted(date: .long, time: .omitted), systemImage: "calendar")
                        Label(todo.dueTime.formatted(date: .omitted, time: .shortened), systemImage: "clock")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding(18)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.headline)

                    Text(todo.details.isEmpty ? "No description added." : todo.details)
                        .font(.body)
                        .foregroundStyle(todo.details.isEmpty ? .secondary : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(18)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                Button {
                    viewModel.toggleCompletion(for: todo, using: modelContext)
                } label: {
                    Label(todo.isCompleted ? "Mark as Pending" : "Mark as Completed", systemImage: todo.isCompleted ? "arrow.uturn.backward.circle" : "checkmark.circle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Todo Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingEditTodo = true
                } label: {
                    Label("Edit Todo", systemImage: "pencil")
                }
            }
        }
        .sheet(isPresented: $isShowingEditTodo) {
            AddEditTodoView(todo: todo, viewModel: viewModel)
        }
    }
}

#Preview {
    NavigationStack {
        TodoDetailView(
            todo: TodoItem(title: "Design todo cards", details: "Keep rows compact and readable.", dueDate: .now),
            viewModel: TodoListViewModel()
        )
    }
    .modelContainer(try! TodoDatabase.makeModelContainer(inMemory: true))
}
