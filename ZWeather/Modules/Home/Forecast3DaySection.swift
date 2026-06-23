//
//  Forecast3DaySection.swift
//  ZWeather
//
//  Created by Youssef Abd El-Fatah on 23/06/2026.
//

import SwiftUI

struct Forecast3DaySection: View {
    let days: [Day]
    let textColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("3-DAY FORECAST")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(textColor.opacity(0.7))
            
            Divider()
                .background(textColor.opacity(0.5))
            
            ForEach(0..<days.count, id: \.self) { index in
                let day = days[index]
                let dayLabel = index == 0 ? "Today" : "Day \(index + 1)"
                
                // This wraps the row and tells SwiftUI "When tapped, pass this 'day' object"
                NavigationLink(value: day) {
                    HStack {
                        Text(dayLabel)
                            .font(.title3)
                            .frame(width: 70, alignment: .leading)
                        
                        Spacer()
                        
                        WeatherIconView(iconUrlString: day.temp_icon, size: 40)
                        
                        Spacer()
                        
                        Text("\(String(format: "%.1f", day.temp_l))° - \(String(format: "%.1f", day.temp_h))°")
                            .font(.title3)
                            .fontWeight(.medium)
                            .frame(width: 120, alignment: .trailing)
                    }
                    .foregroundColor(textColor)
                }
                .padding(.vertical, 4)
                
                Divider()
                    .background(textColor.opacity(0.5))
            }
        }
        .padding(.horizontal)
        // THE MISSING LINK: This catches the 'NavigationLink' value and opens the new screen
        .navigationDestination(for: Day.self) { selectedDay in
            HourlyForecastView(selectedDay: selectedDay)
        }
    }
}
