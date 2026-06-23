//
//  Item.swift
//  ZWeather
//
//  Created by Youssef Abd El-Fatah on 22/06/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
