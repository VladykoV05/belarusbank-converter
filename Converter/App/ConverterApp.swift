import SwiftUI
import SwiftData

@main
struct BelarusBankApp: App {
    @State private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.appDependencies, dependencies)
        }
        .modelContainer(dependencies.modelContainer)
    }
}
