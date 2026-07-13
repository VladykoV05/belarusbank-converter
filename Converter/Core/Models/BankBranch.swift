import Foundation

struct BankBranch: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let displayName: String
    let cityName: String
    let settlementTypeCode: String
    let street: String
    let houseNumber: String

    let usdBuy: String?
    let usdSell: String?
    let eurBuy: String?
    let eurSell: String?
    let rubBuy: String?
    let rubSell: String?
    let gbpBuy: String?
    let gbpSell: String?
    let cadBuy: String?
    let cadSell: String?
    let plnBuy: String?
    let plnSell: String?
    let sekBuy: String?
    let sekSell: String?
    let chfBuy: String?
    let chfSell: String?
    let jpyBuy: String?
    let jpySell: String?
    let cnyBuy: String?
    let cnySell: String?
    let czkBuy: String?
    let czkSell: String?
    let nokBuy: String?
    let nokSell: String?

    enum CodingKeys: String, CodingKey {
        case id = "filial_id"
        case displayName = "filials_text"
        case cityName = "name"
        case settlementTypeCode = "name_type"
        case street
        case houseNumber = "home_number"
        case usdBuy = "USD_in", usdSell = "USD_out"
        case eurBuy = "EUR_in", eurSell = "EUR_out"
        case rubBuy = "RUB_in", rubSell = "RUB_out"
        case gbpBuy = "GBP_in", gbpSell = "GBP_out"
        case cadBuy = "CAD_in", cadSell = "CAD_out"
        case plnBuy = "PLN_in", plnSell = "PLN_out"
        case sekBuy = "SEK_in", sekSell = "SEK_out"
        case chfBuy = "CHF_in", chfSell = "CHF_out"
        case jpyBuy = "JPY_in", jpySell = "JPY_out"
        case cnyBuy = "CNY_in", cnySell = "CNY_out"
        case czkBuy = "CZK_in", czkSell = "CZK_out"
        case nokBuy = "NOK_in", nokSell = "NOK_out"
    }

    var settlementType: String {
        SettlementTypeMapper.localizedName(for: settlementTypeCode)
    }

    var fullAddress: String {
        "\(settlementType) \(cityName), \(street), \(houseNumber)"
    }

    func rate(for currency: Currency, direction: ExchangeDirection) -> Double? {
        guard let rateString = rateString(for: currency, direction: direction),
              let rate = rateString.parsedDouble,
              rate > 0 else {
            return nil
        }
        return rate
    }

    func hasCurrency(_ currency: Currency) -> Bool {
        rate(for: currency, direction: .buy) != nil || rate(for: currency, direction: .sell) != nil
    }

    private func rateString(for currency: Currency, direction: ExchangeDirection) -> String? {
        let isBuy = direction.isBuy
        switch currency {
        case .usd: return isBuy ? usdBuy : usdSell
        case .eur: return isBuy ? eurBuy : eurSell
        case .rub: return isBuy ? rubBuy : rubSell
        case .gbp: return isBuy ? gbpBuy : gbpSell
        case .cad: return isBuy ? cadBuy : cadSell
        case .pln: return isBuy ? plnBuy : plnSell
        case .sek: return isBuy ? sekBuy : sekSell
        case .chf: return isBuy ? chfBuy : chfSell
        case .jpy: return isBuy ? jpyBuy : jpySell
        case .cny: return isBuy ? cnyBuy : cnySell
        case .czk: return isBuy ? czkBuy : czkSell
        case .nok: return isBuy ? nokBuy : nokSell
        }
    }
}

private enum SettlementTypeMapper {
    static func localizedName(for code: String) -> String {
        switch code {
        case "г.": "Город"
        case "д.": "Деревня"
        case "агрогородок": "Агрогородок"
        case "п.": "Посёлок"
        case "ПТО": "Пункт таможенного оформления"
        case "п.п.": "Пункт пропуска"
        case "к.п.": "Курортный посёлок"
        case "г.п.": "Городской посёлок"
        case "": "Остальные типы"
        default: code
        }
    }
}
