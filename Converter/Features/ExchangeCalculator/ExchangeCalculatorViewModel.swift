import Foundation

@MainActor
@Observable
final class ExchangeCalculatorViewModel {
    let branch: BankBranch

    var amount = "100"
    var selectedCurrency: Currency = .usd
    var direction: ExchangeDirection = .buy

    init(branch: BankBranch) {
        self.branch = branch
        if !branch.hasCurrency(selectedCurrency), let first = availableCurrencies.first {
            selectedCurrency = first
        }
    }

    var availableCurrencies: [Currency] {
        Currency.exchangeCalculator.filter { branch.hasCurrency($0) }
    }

    var isSelectedCurrencyAvailable: Bool {
        branch.hasCurrency(selectedCurrency)
    }

    var amountPlaceholder: String {
        direction == .buy ? "Сумма в BYN" : "Сумма в \(selectedCurrency.rawValue)"
    }

    var resultCurrencyLabel: String {
        direction == .buy ? selectedCurrency.rawValue : "BYN"
    }

    var calculatedResult: Double {
        guard let amountValue = amount.replacingOccurrences(of: ",", with: ".").parsedDouble,
              let rate = branch.rate(for: selectedCurrency, direction: direction) else {
            return 0
        }

        return CurrencyConverter.convert(
            amount: amountValue,
            rate: rate,
            denomination: selectedCurrency.denomination,
            direction: direction
        )
    }

    var rateForOneUnit: Double {
        guard let rate = branch.rate(for: selectedCurrency, direction: direction) else { return 0 }
        return CurrencyConverter.ratePerUnit(rate: rate, denomination: selectedCurrency.denomination)
    }

    var apiRate: Double {
        branch.rate(for: selectedCurrency, direction: direction) ?? 0
    }
}
