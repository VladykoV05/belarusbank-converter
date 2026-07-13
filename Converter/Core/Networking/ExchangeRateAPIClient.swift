import Foundation

protocol ExchangeRateAPIClientProtocol: Sendable {
    func fetchBranches() async throws -> [BankBranch]
}

final class ExchangeRateAPIClient: ExchangeRateAPIClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    func fetchBranches() async throws -> [BankBranch] {
        var request = URLRequest(
            url: APIConfig.exchangeRatesURL,
            timeoutInterval: APIConfig.requestTimeout
        )
        request.httpMethod = "GET"

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw AppError.networkUnavailable
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw AppError.invalidResponse
        }

        do {
            return try decoder.decode([BankBranch].self, from: data)
        } catch {
            throw AppError.invalidResponse
        }
    }
}
