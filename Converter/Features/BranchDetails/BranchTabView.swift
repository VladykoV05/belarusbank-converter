import SwiftUI

struct BranchTabView: View {
    let branch: BankBranch

    var body: some View {
        TabView {
            RatesView(branch: branch)
                .tabItem {
                    Label("Курсы", systemImage: "list.dash")
                }

            ExchangeCalculatorView(branch: branch)
                .tabItem {
                    Label("Калькулятор", systemImage: "arrow.left.arrow.right")
                }
        }
    }
}
