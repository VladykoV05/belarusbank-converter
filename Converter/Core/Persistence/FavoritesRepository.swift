import Foundation
import SwiftData

@MainActor
protocol FavoritesRepositoryProtocol {
    func isFavorite(branchId: String) -> Bool
    func toggleFavorite(branchId: String)
}

@MainActor
final class SwiftDataFavoritesRepository: FavoritesRepositoryProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func isFavorite(branchId: String) -> Bool {
        let predicate = #Predicate<FavoriteBranch> { $0.branchId == branchId }
        let descriptor = FetchDescriptor(predicate: predicate)

        do {
            return try modelContext.fetchCount(descriptor) > 0
        } catch {
            return false
        }
    }

    func toggleFavorite(branchId: String) {
        let predicate = #Predicate<FavoriteBranch> { $0.branchId == branchId }
        let descriptor = FetchDescriptor(predicate: predicate)

        do {
            if let existing = try modelContext.fetch(descriptor).first {
                modelContext.delete(existing)
            } else {
                modelContext.insert(FavoriteBranch(branchId: branchId))
            }
            try modelContext.save()
        } catch {
            return
        }
    }

}
