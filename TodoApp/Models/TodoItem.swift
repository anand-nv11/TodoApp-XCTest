import Foundation
import SwiftData

@Model
final class TodoItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var details: String
    var dueDate: Date
    var dueTime: Date
    var isCompleted: Bool
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        details: String,
        dueDate: Date,
        dueTime: Date = .now,
        isCompleted: Bool = false,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.details = details
        self.dueDate = dueDate
        self.dueTime = dueTime
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
