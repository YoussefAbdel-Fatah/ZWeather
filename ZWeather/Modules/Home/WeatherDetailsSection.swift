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
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .leading)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 30) {
            
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
                // Adding formatting to show numbers like 1,021 cleanly
                value: "\(Int(forecast.pressure.rounded()).formatted())",
                textColor: textColor
            )
            
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
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
