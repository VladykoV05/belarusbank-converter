import Foundation

enum APIConfig {
    static let exchangeRatesURL = URL(string: "https://belarusbank.by/api/kursExchange")!
    static let requestTimeout: TimeInterval = 30
    static let cacheExpiration: TimeInterval = 3600 * 24
}
