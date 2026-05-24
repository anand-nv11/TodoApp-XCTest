# TodoApp

A small SwiftUI todo demo app built with MVVM and SwiftData local persistence. The project focuses on a clean native iOS interface, readable code, and a structure that can be extended without adding unnecessary complexity.

## Features

- Add, edit, and delete todos
- Mark todos as completed or pending
- Store todos locally with SwiftData
- Swipe to delete from the todo list
- Search by title or description
- Empty state for no todos and no search results
- Todo details screen
- Native dark mode support

## Screenshots

| Todo List | Add/Edit Todo | Todo Details |
| --- | --- | --- |
| Add `Screenshots/todo-list.png` | Add `Screenshots/add-edit-todo.png` | Add `Screenshots/todo-details.png` |

## Tech Stack

- SwiftUI
- SwiftData
- MVVM
- Async/Await
- Swift Testing
- XCUIAutomation

## Project Structure

```text
TodoApp/
  Database/
    TodoDatabase.swift
  Models/
    TodoItem.swift
  ViewModels/
    TodoListViewModel.swift
  Views/
    AddEditTodoView.swift
    TodoDetailView.swift
    TodoListView.swift
    Components/
      EmptyStateView.swift
      TodoCardView.swift
```

## Installation

1. Open `TodoApp.xcodeproj` in Xcode.
2. Select the `TodoApp` scheme.
3. Choose an iOS simulator or a connected device.
4. Build and run with `Command + R`.

## Notes

The app uses SwiftData through a shared `ModelContainer` configured in `TodoAppApp`. The view model owns todo loading, filtering, and CRUD operations, while SwiftUI views stay focused on layout and user interaction.
