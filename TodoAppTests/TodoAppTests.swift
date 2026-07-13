import Foundation
import SwiftData
import XCTest
@testable import TodoApp

@MainActor
final class TodoAppTests: XCTestCase {
    private func makeSUT() throws -> (viewModel: TodoListViewModel, context: ModelContext) {
        let container = try TodoDatabase.makeModelContainer(inMemory: true)
        return (TodoListViewModel(), container.mainContext)
    }
    
    func testAddTodoStoresItemLocally() throws {
        let sut = try makeSUT()
        let dueDate = Date(timeIntervalSince1970: 1_800_000_000)
        let dueTime = Date(timeIntervalSince1970: 1_800_036_000)

        sut.viewModel.addTodo(
            title: "  Buy milk  ",
            details: "From the local store",
            dueDate: dueDate,
            dueTime: dueTime,
            isCompleted: false,
            using: sut.context
        )

        XCTAssertEqual(sut.viewModel.todos.count, 1)
        XCTAssertEqual(sut.viewModel.todos.first?.title, "Buy milk")
        XCTAssertEqual(sut.viewModel.todos.first?.details, "From the local store")
        XCTAssertEqual(sut.viewModel.todos.first?.dueDate, dueDate)
        XCTAssertEqual(sut.viewModel.todos.first?.dueTime, dueTime)
        XCTAssertEqual(sut.viewModel.pendingCount, 1)
        XCTAssertEqual(sut.viewModel.completedCount, 0)
    }

    func testSearchFiltersByTitleAndDescription() throws {
        let sut = try makeSUT()

        sut.viewModel.addTodo(title: "Read docs", details: "SwiftData persistence", dueDate: .now, dueTime: .now, isCompleted: false, using: sut.context)
        sut.viewModel.addTodo(title: "Plan demo", details: "Screens and README", dueDate: .now, dueTime: .now, isCompleted: true, using: sut.context)

        sut.viewModel.searchText = "swiftdata"

        XCTAssertEqual(sut.viewModel.filteredTodos.count, 1)
        XCTAssertEqual(sut.viewModel.filteredTodos.first?.title, "Read docs")
    }

    func testUpdateAndToggleTodo() throws {
        let sut = try makeSUT()
        let originalDate = Date(timeIntervalSince1970: 1_800_000_000)
        let originalTime = Date(timeIntervalSince1970: 1_800_003_600)
        let updatedDate = Date(timeIntervalSince1970: 1_800_086_400)
        let updatedTime = Date(timeIntervalSince1970: 1_800_090_000)

        sut.viewModel.addTodo(title: "Draft", details: "Old details", dueDate: originalDate, dueTime: originalTime, isCompleted: false, using: sut.context)
        let todo = try XCTUnwrap(sut.viewModel.todos.first)

        sut.viewModel.updateTodo(todo, title: "Final", details: "Updated details", dueDate: updatedDate, dueTime: updatedTime, isCompleted: false, using: sut.context)
        sut.viewModel.toggleCompletion(for: todo, using: sut.context)

        XCTAssertEqual(sut.viewModel.todos.first?.title, "Final")
        XCTAssertEqual(sut.viewModel.todos.first?.details, "Updated details")
        XCTAssertEqual(sut.viewModel.todos.first?.dueDate, updatedDate)
        XCTAssertEqual(sut.viewModel.todos.first?.dueTime, updatedTime)
        XCTAssertEqual(sut.viewModel.completedCount, 1)
        XCTAssertEqual(sut.viewModel.pendingCount, 0)
    }

    func testDeleteTodoRemovesStoredItem() throws {
        let sut = try makeSUT()

        sut.viewModel.addTodo(title: "Delete me", details: "Temporary", dueDate: .now, dueTime: .now, isCompleted: false, using: sut.context)
        let todo = try XCTUnwrap(sut.viewModel.todos.first)

        sut.viewModel.delete(todo, using: sut.context)

        XCTAssertTrue(sut.viewModel.todos.isEmpty)
        XCTAssertEqual(sut.viewModel.pendingCount, 0)
        XCTAssertEqual(sut.viewModel.completedCount, 0)
    }
}
