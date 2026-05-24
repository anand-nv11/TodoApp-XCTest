import SwiftData
import SwiftUI

@main
struct TodoAppApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            let isUITesting = ProcessInfo.processInfo.arguments.contains("-uiTesting")
            modelContainer = try TodoDatabase.makeModelContainer(inMemory: isUITesting)
        } catch {
            fatalError("Unable to create Todo database: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
