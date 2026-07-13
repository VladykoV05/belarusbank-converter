import Foundation
import SwiftData
import SwiftUI

@MainActor
final class AppDependencies {
    let branchRepository: BranchRepositoryProtocol
    let networkMonitor: NetworkMonitor
    let modelContainer: ModelContainer

    init(
        branchRepository: BranchRepositoryProtocol? = nil,
        networkMonitor: NetworkMonitor? = nil,
        modelContainer: ModelContainer? = nil
    ) {
        self.branchRepository = branchRepository ?? BranchRepository(
            apiClient: ExchangeRateAPIClient(),
            cacheStore: UserDefaultsBranchCacheStore()
        )
        self.networkMonitor = networkMonitor ?? NetworkMonitor()
        self.modelContainer = modelContainer ?? Self.makeModelContainer()
    }

    func makeFavoritesRepository(modelContext: ModelContext) -> FavoritesRepositoryProtocol {
        SwiftDataFavoritesRepository(modelContext: modelContext)
    }

    private static func makeModelContainer() -> ModelContainer {
        do {
            return try ModelContainer(for: FavoriteBranch.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }
}

private struct AppDependenciesKey: EnvironmentKey {
    static let defaultValue: AppDependencies? = nil
}

extension EnvironmentValues {
    var appDependencies: AppDependencies? {
        get { self[AppDependenciesKey.self] }
        set { self[AppDependenciesKey.self] = newValue }
    }
}
