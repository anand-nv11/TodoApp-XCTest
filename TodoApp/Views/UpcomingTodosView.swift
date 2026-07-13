import SwiftData
import SwiftUI

struct UpcomingTodosView: View {
    @Environment(\.modelContext) private var modelContext

    let viewModel: TodoListViewModel

    @State private var searchText = ""
    @State private var isShowingAddTodo = false

    private var upcomingTodos: [TodoItem] {
        let pendingTodos = viewModel.todos.filter { !$0.isCompleted }
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedSearchText.isEmpty else {
            return pendingTodos
        }

        return pendingTodos.filter { todo in
            todo.title.localizedCaseInsensitiveContains(trimmedSearchText)
                || todo.details.localizedCaseInsensitiveContains(trimmedSearchText)
        }
    }

    var body: some View {
        List {
            Button {
                isShowingAddTodo = true
            } label: {
                Label("Add Task", systemImage: "plus")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 14)
                    .frame(height: 46)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .strokeBorder(.blue, lineWidth: 1.5)
                    }
            }
            .buttonStyle(.plain)
            .foregroundStyle(.blue)
            .listRowInsets(EdgeInsets(top: 16, leading: 18, bottom: 10, trailing: 18))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)

            UpcomingSearchRow(searchText: $searchText)
                .listRowInsets(EdgeInsets(top: 4, leading: 18, bottom: 12, trailing: 18))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)

            if upcomingTodos.isEmpty {
                EmptyStateView(isSearching: !searchText.isEmpty)
                    .frame(maxWidth: .infinity, minHeight: 260)
                    .listRowInsets(EdgeInsets(top: 8, leading: 18, bottom: 16, trailing: 18))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(upcomingTodos) { todo in
                    NavigationLink {
                        TodoDetailView(todo: todo, viewModel: viewModel)
                    } label: {
                        TodoCardView(todo: todo) {
                            viewModel.toggleCompletion(for: todo, using: modelContext)
                        }
                    }
                    .buttonStyle(.plain)
                    .listRowInsets(EdgeInsets(top: 6, leading: 18, bottom: 6, trailing: 18))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.delete(todo, using: modelContext)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Tasks")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingAddTodo) {
            AddEditTodoView(viewModel: viewModel)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .task {
            viewModel.loadTodos(using: modelContext)
        }
    }
}

private struct UpcomingSearchRow: View {
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 10) {
                TextField("Search Task", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .accessibilityIdentifier("upcomingSearchField")

                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.primary)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 14)
            .frame(height: 46)
            .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

            Button {} label: {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.headline)
                    .frame(width: 46, height: 46)
                    .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Filter tasks")
        }
    }
}

#Preview {
    NavigationStack {
        UpcomingTodosView(viewModel: TodoListViewModel())
            .modelContainer(try! TodoDatabase.makeModelContainer(inMemory: true))
    }
}
