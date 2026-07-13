import SwiftUI

struct BranchSelectionView: View {
    @Bindable var viewModel: BranchSelectionViewModel
    @Binding var selectedBranch: BankBranch?

    var body: some View {
        VStack(spacing: 12) {
            SearchBar(text: $viewModel.searchText)
                .padding(.horizontal)

            HStack {
                Picker("Город", selection: $viewModel.selectedCity) {
                    ForEach(viewModel.filteredCities, id: \.self) { city in
                        Text(city).tag(city)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
                .disabled(
                    viewModel.selectedType != BranchSelectionViewModel.FilterOption.allTypes
                    && viewModel.filteredCities.count == 1
                )

                Picker("Тип", selection: $viewModel.selectedType) {
                    ForEach(viewModel.branchTypes, id: \.self) { type in
                        Text(type).tag(type)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
                .onChange(of: viewModel.selectedType) { _, _ in
                    viewModel.resetCityFilter()
                }
            }
            .padding(.horizontal)

            Toggle("Только избранные", isOn: $viewModel.showFavoritesOnly)
                .padding(.horizontal)

            branchList
        }
    }

    @ViewBuilder
    private var branchList: some View {
        if viewModel.isLoading {
            ProgressView("Загрузка отделений...")
                .frame(maxHeight: .infinity)
        } else if viewModel.filteredBranches.isEmpty {
            ContentUnavailableView(
                viewModel.showFavoritesOnly ? "Нет избранных отделений" : "Нет данных об отделениях",
                systemImage: viewModel.showFavoritesOnly ? "star.slash" : "building.2"
            )
            .frame(maxHeight: .infinity)
        } else {
            List(viewModel.filteredBranches) { branch in
                BranchRow(
                    branch: branch,
                    isFavorite: viewModel.isFavorite(branchId: branch.id),
                    onSelect: { selectedBranch = branch },
                    onToggleFavorite: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            viewModel.toggleFavorite(branchId: branch.id)
                        }
                    }
                )
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
    }
}
