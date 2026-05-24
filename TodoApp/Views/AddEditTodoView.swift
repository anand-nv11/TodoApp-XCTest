import SwiftData
import SwiftUI

struct AddEditTodoView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let todo: TodoItem?
    let viewModel: TodoListViewModel

    @State private var title: String
    @State private var details: String
    @State private var dueDate: Date
    @State private var dueTime: Date
    @State private var isCompleted: Bool

    private var isEditing: Bool {
        todo != nil
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init(todo: TodoItem? = nil, viewModel: TodoListViewModel) {
        self.todo = todo
        self.viewModel = viewModel
        _title = State(initialValue: todo?.title ?? "")
        _details = State(initialValue: todo?.details ?? "")
        _dueDate = State(initialValue: todo?.dueDate ?? .now)
        _dueTime = State(initialValue: todo?.dueTime ?? .now)
        _isCompleted = State(initialValue: todo?.isCompleted ?? false)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Todo") {
                    TextField("Title", text: $title)
                        .textInputAutocapitalization(.sentences)
                        .accessibilityIdentifier("todoTitleField")

                    TextField("Description", text: $details, axis: .vertical)
                        .lineLimit(4, reservesSpace: true)
                        .textInputAutocapitalization(.sentences)
                        .accessibilityIdentifier("todoDescriptionField")
                }

                Section("Schedule") {
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }

                Section("Time") {
                    DatePicker("Due Time", selection: $dueTime, displayedComponents: .hourAndMinute)
                        .accessibilityIdentifier("todoDueTimePicker")

                    Toggle("Completed", isOn: $isCompleted)
                }
            }
            .navigationTitle(isEditing ? "Edit Todo" : "Add Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await saveTodo()
                        }
                    }
                    .disabled(!canSave)
                    .accessibilityIdentifier("saveTodoButton")
                }
            }
        }
    }

    private func saveTodo() async {
        if let todo {
            await viewModel.updateTodo(
                todo,
                title: title,
                details: details,
                dueDate: dueDate,
                dueTime: dueTime,
                isCompleted: isCompleted,
                using: modelContext
            )
        } else {
            await viewModel.addTodo(
                title: title,
                details: details,
                dueDate: dueDate,
                dueTime: dueTime,
                isCompleted: isCompleted,
                using: modelContext
            )
        }

        dismiss()
    }
}

#Preview {
    AddEditTodoView(viewModel: TodoListViewModel())
        .modelContainer(try! TodoDatabase.makeModelContainer(inMemory: true))
}
