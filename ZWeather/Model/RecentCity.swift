import Foundation
import SwiftData

@Model
class RecentCity {
    // Making it unique prevents saving "Alexandria" 50 times in a row
    @Attribute(.unique) var name: String
    var searchDate: Date
    
    init(name: String, searchDate: Date = Date()) {
        self.name = name
        self.searchDate = searchDate
    }
}