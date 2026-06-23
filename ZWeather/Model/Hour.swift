//
//  Hour.swift
//  ZWeather
//
//  Created by Youssef Abd El-Fatah on 22/06/2026.
//


import Foundation

struct Hour: Identifiable, Hashable {
    let id = UUID()
    let temp_icon: String
    let temp: Double
}
