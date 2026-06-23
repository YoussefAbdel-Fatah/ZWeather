//
//  Day.swift
//  ZWeather
//
//  Created by Youssef Abd El-Fatah on 22/06/2026.
//

import Foundation


struct Day: Identifiable, Hashable {
    
    let id = UUID()
    
    // The middle section in home screen
    let temp_icon: String
    let temp_h: Double
    let temp_l: Double

    // The hours screen
    let hours: [Hour]
}
