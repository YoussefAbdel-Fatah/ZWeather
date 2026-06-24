//
//  WeatherDetailsSection.swift
//  ZWeather
//
//  Created by Youssef Abd El-Fatah on 23/06/2026.
//

import SwiftUI

struct WeatherDetailsSection: View {
    let forecast: Forecast
    let textColor: Color
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 30) { // Note: 'spacing: 30' here only applies to the vertical space between rows
            
            DetailCell(
                title: "VISIBILITY",
                value: "\(Int(forecast.visibility.rounded())) km",
                textColor: textColor
            )
            
            DetailCell(
                title: "HUMIDITY",
                value: "\(Int(forecast.humidity.rounded()))%",
                textColor: textColor
            )
            
            DetailCell(
                title: "FEELS LIKE",
                value: "\(Int(forecast.feels_like.rounded()))°",
                textColor: textColor
            )
            
            DetailCell(
                title: "PRESSURE",
                value: "\(Int(forecast.pressure.rounded()).formatted())",
                textColor: textColor
            )
            
        }
        // This applies the exact same system margin to both the left and right sides
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

// Reusable Cell
struct DetailCell: View {
    let title: String
    let value: String
    let textColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(textColor.opacity(0.7))
            
            Text(value)
                .font(.system(size: 28, weight: .regular))
                .foregroundColor(textColor)
        }
    }
}
