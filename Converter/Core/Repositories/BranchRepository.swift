import Foundation

protocol BranchRepositoryProtocol {
    func cachedBranches() -> [BankBranch]?
    func fetchBranches() async throws -> [BankBranch]
}

final class BranchRepository: BranchRepositoryProtocol {
    private let apiClient: ExchangeRateAPIClientProtocol
    private let cacheStore: BranchCacheStoreProtocol

    init(
        apiClient: ExchangeRateAPIClientProtocol,
        cacheStore: BranchCacheStoreProtocol
    ) {
        self.apiClient = apiClient
        self.cacheStore = cacheStore
    }

    func cachedBranches() -> [BankBranch]? {
        cacheStore.load()
    }

    func fetchBranches() async throws -> [BankBranch] {
        let branches = try await apiClient.fetchBranches()
        cacheStore.save(branches)
        return branches
    }
}
