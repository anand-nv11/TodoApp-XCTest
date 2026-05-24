import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class TodoListViewModel {

    var todos: [TodoItem] = []
    var searchText = ""
    var errorMessage: String?

    var filteredTodos: [TodoItem] {
        let trimmedSearchText = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedSearchText.isEmpty else {
            return todos
        }

        return todos.filter { todo in
            todo.title.localizedCaseInsensitiveContains(trimmedSearchText)
            || todo.details.localizedCaseInsensitiveContains(trimmedSearchText)
        }
    }

    var pendingCount: Int {
        todos.filter { !$0.isCompleted }.count
    }

    var completedCount: Int {
        todos.filter(\.isCompleted).count
    }

    // MARK: - Load

    func loadTodos(using context: ModelContext) {

        do {
            let fetchedTodos = try context.fetch(
                FetchDescriptor<TodoItem>()
            )

            todos = sortTodos(fetchedTodos)
            errorMessage = nil

        } catch {

            todos = []
            errorMessage = "Unable to load todos."
        }
    }

    // MARK: - Add

    func addTodo(
        title: String,
        details: String,
        dueDate: Date,
        dueTime: Date,
        isCompleted: Bool,
        using context: ModelContext
    ) {

        let todo = TodoItem(
            title: title.trimmedForStorage,
            details: details.trimmedForStorage,
            dueDate: dueDate,
            dueTime: dueTime,
            isCompleted: isCompleted
        )

        context.insert(todo)

        save(using: context)
    }

    // MARK: - Update

    func updateTodo(
        _ todo: TodoItem,
        title: String,
        details: String,
        dueDate: Date,
        dueTime: Date,
        isCompleted: Bool,
        using context: ModelContext
    ) {

        todo.title = title.trimmedForStorage
        todo.details = details.trimmedForStorage
        todo.dueDate = dueDate
        todo.dueTime = dueTime
        todo.isCompleted = isCompleted
        todo.updatedAt = .now

        save(using: context)
    }

    // MARK: - Toggle

    func toggleCompletion(
        for todo: TodoItem,
        using context: ModelContext
    ) {

        todo.isCompleted.toggle()
        todo.updatedAt = .now

        save(using: context)
    }

    // MARK: - Delete

    func delete(
        _ todo: TodoItem,
        using context: ModelContext
    ) {

        context.delete(todo)

        save(using: context)
    }

    func delete(
        at offsets: IndexSet,
        using context: ModelContext
    ) {

        let visibleTodos = filteredTodos

        for index in offsets
        where visibleTodos.indices.contains(index) {

            context.delete(visibleTodos[index])
        }

        save(using: context)
    }

    // MARK: - Save

    private func save(using context: ModelContext) {

        do {

            try context.save()

            loadTodos(using: context)

            errorMessage = nil

        } catch {

            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Sort

    private func sortTodos(
        _ todos: [TodoItem]
    ) -> [TodoItem] {

        todos.sorted { first, second in

            if first.isCompleted != second.isCompleted {
                return !first.isCompleted
            }

            let firstDueDateTime =
                Calendar.current.dateByCombining(
                    date: first.dueDate,
                    time: first.dueTime
                )

            let secondDueDateTime =
                Calendar.current.dateByCombining(
                    date: second.dueDate,
                    time: second.dueTime
                )

            if firstDueDateTime != secondDueDateTime {
                return firstDueDateTime < secondDueDateTime
            }

            return first.createdAt > second.createdAt
        }
    }
}

// MARK: - Calendar Extension

extension Calendar {

    func dateByCombining(
        date: Date,
        time: Date
    ) -> Date {

        let dayComponents =
            self.dateComponents(
                [.year, .month, .day],
                from: date
            )

        let clockComponents =
            self.dateComponents(
                [.hour, .minute, .second],
                from: time
            )

        var combinedComponents = DateComponents()

        combinedComponents.year = dayComponents.year
        combinedComponents.month = dayComponents.month
        combinedComponents.day = dayComponents.day
        combinedComponents.hour = clockComponents.hour
        combinedComponents.minute = clockComponents.minute
        combinedComponents.second = clockComponents.second

        return self.date(from: combinedComponents) ?? date
    }
}

// MARK: - String Extension

private extension String {

    var trimmedForStorage: String {

        trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }
}
