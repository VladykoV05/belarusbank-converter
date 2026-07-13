import Foundation

enum Currency: String, CaseIterable, Identifiable, Codable, Hashable {
    case usd = "USD"
    case eur = "EUR"
    case rub = "RUB"
    case gbp = "GBP"
    case cad = "CAD"
    case pln = "PLN"
    case sek = "SEK"
    case chf = "CHF"
    case jpy = "JPY"
    case cny = "CNY"
    case czk = "CZK"
    case nok = "NOK"

    var id: String { rawValue }

    var denomination: Double {
        switch self {
        case .usd, .eur, .gbp, .chf: 1
        case .rub, .czk: 100
        case .pln, .cny: 10
        case .cad, .sek, .jpy, .nok: 1
        }
    }

    static let main: [Currency] = [.usd, .eur, .rub]
    static let secondary: [Currency] = [.gbp, .cad, .pln, .sek, .chf, .jpy, .cny, .czk, .nok]
    static let calculator: [Currency] = [.usd, .eur, .rub, .pln, .cny, .gbp, .chf, .czk]
}

enum ExchangeDirection: Hashable {
    case buy
    case sell

    var isBuy: Bool { self == .buy }
}
