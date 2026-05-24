import SwiftData

enum TodoDatabase {
    static let schema = Schema([
        TodoItem.self
    ])

    static func makeModelContainer(inMemory: Bool = false) throws -> ModelContainer {
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
        return try ModelContainer(for: schema, configurations: [configuration])
    }
}
