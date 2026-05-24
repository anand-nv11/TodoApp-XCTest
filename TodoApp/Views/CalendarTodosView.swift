import SwiftData
import SwiftUI

struct CalendarTodosView: View {
    @Environment(\.modelContext) private var modelContext

    let viewModel: TodoListViewModel

    @State private var selectedDate = Date.now
    @State private var isShowingAddTodo = false

    private var selectedDayTodos: [TodoItem] {
        viewModel.todos.filter { Foundation.Calendar.current.isDate($0.dueDate, inSameDayAs: selectedDate) }
    }

    private var groupedTodos: [TodoDayGroup] {
        let grouped = Dictionary(grouping: viewModel.todos) { todo in
            Foundation.Calendar.current.startOfDay(for: todo.dueDate)
        }

        return grouped
            .map { date, todos in
                TodoDayGroup(date: date, todos: todos.sorted { first, second in
                    Foundation.Calendar.current.dateByCombining(date: first.dueDate, time: first.dueTime)
                        < Foundation.Calendar.current.dateByCombining(date: second.dueDate, time: second.dueTime)
                })
            }
            .sorted { $0.date < $1.date }
    }

    var body: some View {
        List {
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding(12)
                .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .listRowInsets(EdgeInsets(top: 16, leading: 18, bottom: 10, trailing: 18))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)

            CalendarSectionHeader(title: "Selected Day", count: selectedDayTodos.count)
                .listRowInsets(EdgeInsets(top: 10, leading: 18, bottom: 4, trailing: 18))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)

            if selectedDayTodos.isEmpty {
                Text("No tasks scheduled for this date.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .listRowInsets(EdgeInsets(top: 4, leading: 18, bottom: 16, trailing: 18))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(selectedDayTodos) { todo in
                    todoRow(todo)
                }
            }

            CalendarSectionHeader(title: "All Task Events", count: viewModel.todos.count)
                .listRowInsets(EdgeInsets(top: 16, leading: 18, bottom: 4, trailing: 18))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)

            if groupedTodos.isEmpty {
                EmptyStateView(isSearching: false)
                    .frame(maxWidth: .infinity, minHeight: 220)
                    .listRowInsets(EdgeInsets(top: 4, leading: 18, bottom: 24, trailing: 18))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(groupedTodos) { group in
                    Section {
                        ForEach(group.todos) { todo in
                            todoRow(todo)
                        }
                    } header: {
                        Text(group.date.formatted(date: .complete, time: .omitted))
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.blue)
                            .textCase(nil)
                    }
                    .listRowInsets(EdgeInsets(top: 6, leading: 18, bottom: 6, trailing: 18))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Calendar")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingAddTodo = true
                } label: {
                    Label("Add Todo", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $isShowingAddTodo) {
            AddEditTodoView(viewModel: viewModel)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .task {
            await viewModel.loadTodos(using: modelContext)
        }
    }

    private func todoRow(_ todo: TodoItem) -> some View {
        NavigationLink {
            TodoDetailView(todo: todo, viewModel: viewModel)
        } label: {
            TodoCardView(todo: todo) {
                Task {
                    await viewModel.toggleCompletion(for: todo, using: modelContext)
                }
            }
        }
        .buttonStyle(.plain)
        .listRowInsets(EdgeInsets(top: 6, leading: 18, bottom: 6, trailing: 18))
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                Task {
                    await viewModel.delete(todo, using: modelContext)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

private struct TodoDayGroup: Identifiable {
    let date: Date
    let todos: [TodoItem]

    var id: Date { date }
}

private struct CalendarSectionHeader: View {
    let title: String
    let count: Int

    var body: some View {
        HStack {
            Text(title)
                .font(.headline.weight(.semibold))
            Spacer()
            Text("\(count)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.blue)
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(Color.blue.opacity(0.12), in: Capsule())
        }
    }
}

#Preview {
    NavigationStack {
        CalendarTodosView(viewModel: TodoListViewModel())
            .modelContainer(try! TodoDatabase.makeModelContainer(inMemory: true))
    }
}
