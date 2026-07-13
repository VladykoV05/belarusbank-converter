import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.appDependencies) private var dependencies

    @State private var viewModel: BranchSelectionViewModel?
    @State private var selectedBranch: BankBranch?

    var body: some View {
        Group {
            if let dependencies {
                NavigationStack {
                    rootContent(dependencies: dependencies)
                }
                .task {
                    let vm: BranchSelectionViewModel
                    if let existing = viewModel {
                        vm = existing
                    } else {
                        vm = BranchSelectionViewModel(
                            branchRepository: dependencies.branchRepository,
                            favoritesRepository: dependencies.makeFavoritesRepository(
                                modelContext: modelContext
                            )
                        )
                        viewModel = vm
                    }
                    await vm.loadBranches()
                }
            } else {
                ProgressView()
            }
        }
    }

    @ViewBuilder
    private func rootContent(dependencies: AppDependencies) -> some View {
        if let branch = selectedBranch {
            BranchTabView(branch: branch)
                .navigationTitle(branch.displayName)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button("Сменить отделение") {
                        selectedBranch = nil
                    }
                }
        } else if let viewModel {
            branchSelectionScreen(viewModel: viewModel, networkMonitor: dependencies.networkMonitor)
        } else {
            ProgressView()
        }
    }

    private func branchSelectionScreen(
        viewModel: BranchSelectionViewModel,
        networkMonitor: NetworkMonitor
    ) -> some View {
        VStack(spacing: 0) {
            if !networkMonitor.isConnected {
                OfflineBanner()
            }

            if let error = viewModel.errorMessage {
                ErrorView(error: error) {
                    Task { await viewModel.loadBranches() }
                }
            }

            BranchSelectionView(viewModel: viewModel, selectedBranch: $selectedBranch)
        }
        .navigationTitle("Отделения Беларусбанка")
    }

}
