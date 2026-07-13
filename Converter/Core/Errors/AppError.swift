import Foundation

enum AppError: LocalizedError, Equatable {
    case networkUnavailable
    case invalidResponse
    case noCachedData

    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            "Ошибка соединения. Проверьте интернет-подключение."
        case .invalidResponse:
            "Произошла ошибка при загрузке данных."
        case .noCachedData:
            "Нет подключения к интернету и отсутствуют кэшированные данные."
        }
    }
}
