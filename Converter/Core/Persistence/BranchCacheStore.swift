import Foundation

protocol BranchCacheStoreProtocol {
    func save(_ branches: [BankBranch])
    func load() -> [BankBranch]?
}

final class UserDefaultsBranchCacheStore: BranchCacheStoreProtocol {
    private let branchesKey = "cachedBranches"
    private let lastUpdateKey = "lastCacheUpdate"
    private let defaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        defaults: UserDefaults = .standard,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.defaults = defaults
        self.encoder = encoder
        self.decoder = decoder
    }

    func save(_ branches: [BankBranch]) {
        guard let data = try? encoder.encode(branches) else { return }
        defaults.set(data, forKey: branchesKey)
        defaults.set(Date(), forKey: lastUpdateKey)
    }

    func load() -> [BankBranch]? {
        guard let data = defaults.data(forKey: branchesKey),
              let lastUpdate = defaults.object(forKey: lastUpdateKey) as? Date,
              Date().timeIntervalSince(lastUpdate) <= APIConfig.cacheExpiration,
              let branches = try? decoder.decode([BankBranch].self, from: data) else {
            return nil
        }
        return branches
    }
}
