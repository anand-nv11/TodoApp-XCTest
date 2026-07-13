import Foundation
import SwiftData

enum TodoDatabase {
    static let schema = Schema([
        TodoItem.self
    ])

    static func makeModelContainer(inMemory: Bool = false) throws -> ModelContainer {
        let configuration: ModelConfiguration

        if inMemory {
            configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        } else {
            let storeURL = try persistentStoreURL()
            configuration = ModelConfiguration(schema: schema, url: storeURL)
        }

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            guard !inMemory else {
                throw error
            }

            try resetPersistentStore()
            return try ModelContainer(for: schema, configurations: [configuration])
        }
    }

    private static func persistentStoreURL() throws -> URL {
        let directoryURL = try persistentStoreDirectoryURL()
        try FileManager.default.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )

        return directoryURL.appending(path: "TodoApp.sqlite")
    }

    private static func persistentStoreDirectoryURL() throws -> URL {
        try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        .appending(path: "TodoApp", directoryHint: .isDirectory)
    }

    private static func resetPersistentStore() throws {
        let directoryURL = try persistentStoreDirectoryURL()

        guard FileManager.default.fileExists(atPath: directoryURL.path) else {
            return
        }

        try FileManager.default.removeItem(at: directoryURL)
    }
}
