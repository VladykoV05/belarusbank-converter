import Foundation

extension String {
    var parsedDouble: Double? {
        Double(replacingOccurrences(of: ",", with: "."))
    }
}
