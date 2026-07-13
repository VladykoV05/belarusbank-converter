import Foundation
import SwiftData

@Model
final class FavoriteBranch {
    var branchId: String
    var addedDate: Date

    init(branchId: String, addedDate: Date = .now) {
        self.branchId = branchId
        self.addedDate = addedDate
    }
}
