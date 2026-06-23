//
//  Forecast.swift
//  ZWeather
//
//  Created by Youssef Abd El-Fatah on 22/06/2026.
//


struct Forecast {

    // the top section of the home screen
    let city: String
    let temp: Double
    let temp_description: String
    let temp_h: Double
    let temp_l: Double
    let temp_icon: String

    // the middle section of the home screen, should have 3 days
    let days: [Day]

    // the bottom section:
    let visibility: Double
    let humidity: Double
    let feels_like: Double
    let pressure: Double
}
