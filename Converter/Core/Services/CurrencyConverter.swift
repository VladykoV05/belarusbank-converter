import Foundation

enum CurrencyConverter {
    static func convert(
        amount: Double,
        rate: Double,
        denomination: Double,
        direction: ExchangeDirection
    ) -> Double {
        switch direction {
        case .buy:
            (amount / rate) * denomination
        case .sell:
            (amount * rate) / denomination
        }
    }

    static func ratePerUnit(rate: Double, denomination: Double) -> Double {
        rate / denomination
    }
}
