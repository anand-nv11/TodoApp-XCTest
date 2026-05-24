import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        TodoListView()
    }
}

#Preview {
    ContentView()
        .modelContainer(try! TodoDatabase.makeModelContainer(inMemory: true))
}
