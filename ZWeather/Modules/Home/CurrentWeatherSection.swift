//
//  CurrentWeatherSection.swift
//  ZWeather
//
//  Created by Youssef Abd El-Fatah on 23/06/2026.
//


import SwiftUI

import SwiftUI

struct CurrentWeatherSection: View {
    let forecast: Forecast
    let textColor: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(forecast.city)
                .font(.system(size: 36, weight: .semibold))
            
            // Rounded to whole number
            Text("\(Int(forecast.temp.rounded()))°")
                .font(.system(size: 96, weight: .thin))
            
            Text(forecast.temp_description)
                .font(.title2)
                .fontWeight(.medium)
            
            // Rounded to whole numbers
            Text("H:\(Int(forecast.temp_h.rounded()))°  L:\(Int(forecast.temp_l.rounded()))°")
                .font(.title3)
                .fontWeight(.medium)
            
            WeatherIconView(iconUrlString: forecast.temp_icon, size: 80)
                .padding(.top, 10)
        }
        .foregroundColor(textColor)
    }
}
