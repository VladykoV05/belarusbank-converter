import Foundation

@MainActor
@Observable
final class BranchSelectionViewModel {
    private(set) var branches: [BankBranch] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    var searchText = ""
    var selectedCity = FilterOption.allCities
    var selectedType = FilterOption.allTypes
    var showFavoritesOnly = false
    private(set) var favoritesVersion = 0

    private let branchRepository: BranchRepositoryProtocol
    private let favoritesRepository: FavoritesRepositoryProtocol

    enum FilterOption {
        static let allCities = "Все города"
        static let allTypes = "Все типы"
    }

    init(
        branchRepository: BranchRepositoryProtocol,
        favoritesRepository: FavoritesRepositoryProtocol
    ) {
        self.branchRepository = branchRepository
        self.favoritesRepository = favoritesRepository
    }

    var filteredCities: [String] {
        let filtered = selectedType == FilterOption.allTypes
            ? branches
            : branches.filter { $0.settlementType == selectedType }

        return [FilterOption.allCities] + Array(Set(filtered.map(\.cityName))).sorted()
    }

    var branchTypes: [String] {
        [FilterOption.allTypes] + Array(Set(branches.map(\.settlementType))).sorted()
    }

    var filteredBranches: [BankBranch] {
        _ = favoritesVersion

        return branches
            .filter { branch in
                !showFavoritesOnly || favoritesRepository.isFavorite(branchId: branch.id)
            }
            .filter { branch in
                searchText.isEmpty
                    || branch.displayName.localizedCaseInsensitiveContains(searchText)
                    || branch.fullAddress.localizedCaseInsensitiveContains(searchText)
            }
            .filter { branch in
                selectedCity == FilterOption.allCities || branch.cityName == selectedCity
            }
            .filter { branch in
                selectedType == FilterOption.allTypes || branch.settlementType == selectedType
            }
    }

    func resetCityFilter() {
        selectedCity = FilterOption.allCities
    }

    func loadBranches() async {
        isLoading = true
        errorMessage = nil

        if let cached = branchRepository.cachedBranches() {
            branches = cached
        }

        do {
            branches = try await branchRepository.fetchBranches()
            errorMessage = nil
        } catch let error as AppError {
            applyError(error)
        } catch {
            applyError(.invalidResponse)
        }

        isLoading = false
    }

    func isFavorite(branchId: String) -> Bool {
        favoritesRepository.isFavorite(branchId: branchId)
    }

    func toggleFavorite(branchId: String) {
        favoritesRepository.toggleFavorite(branchId: branchId)
        favoritesVersion += 1
    }

    private func applyError(_ error: AppError) {
        guard branches.isEmpty else { return }

        errorMessage = error == .networkUnavailable
            ? AppError.noCachedData.errorDescription
            : error.errorDescription
    }
}
