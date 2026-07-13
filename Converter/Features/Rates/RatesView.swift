import SwiftUI

struct RatesView: View {
    let branch: BankBranch

    var body: some View {
        List {
            currencySection(title: "Основные валюты", currencies: Currency.main)
            currencySection(title: "Другие валюты", currencies: Currency.secondary)
        }
        .listStyle(.grouped)
        .navigationTitle("Курсы валют")
    }

    @ViewBuilder
    private func currencySection(title: String, currencies: [Currency]) -> some View {
        Section(title) {
            ForEach(currencies) { currency in
                if branch.hasCurrency(currency) {
                    CurrencyRow(currency: currency, branch: branch)
                } else {
                    UnavailableCurrencyRow(currency: currency)
                }
            }
        }
    }
}

struct CurrencyRow: View {
    let currency: Currency
    let branch: BankBranch

    var body: some View {
        HStack {
            Text(currency.rawValue)
                .frame(width: 40, alignment: .leading)
                .font(.system(.body, design: .monospaced))

            Spacer()

            rateText(branch.rate(for: currency, direction: .buy), color: .green)
            rateText(branch.rate(for: currency, direction: .sell), color: .red)
        }
        .font(.system(.callout, design: .monospaced))
    }

    @ViewBuilder
    private func rateText(_ rate: Double?, color: Color) -> some View {
        if let rate {
            Text(rate, format: .number.precision(.fractionLength(4)))
                .frame(width: 80, alignment: .trailing)
                .foregroundStyle(color)
        } else {
            Text("-")
                .frame(width: 80, alignment: .trailing)
                .foregroundStyle(.secondary)
        }
    }
}

struct UnavailableCurrencyRow: View {
    let currency: Currency

    var body: some View {
        HStack {
            Text(currency.rawValue)
                .frame(width: 40, alignment: .leading)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(.secondary)

            Spacer()

            Text("Недоступно")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
