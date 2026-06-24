//
//  HourlyForecastView.swift
//  ZWeather
//
//  Created by Youssef Abd El-Fatah on 23/06/2026.
//

import SwiftUI

struct HourlyForecastView: View {
    let selectedDay: Day
    
    // 1. Bring in the same time-of-day logic
    private var isNight: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour < 6 || hour >= 18
        // return true
    }
    
    // Dynamic text color to match the background
    private var dynamicTextColor: Color {
        isNight ? .white : .black
    }
    
    var body: some View {
        ZStack {
            // 2. The Background Layer
            Image(isNight ? "background_night" : "background_morning")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 1.0) // Matches the Home Screen style
            
            // 3. The Content Layer
            VStack(spacing: 0) {
                List(Array(selectedDay.hours.enumerated()), id: \.element.id) { index, hour in
                    HStack {
                        Text(formatTime(index: index))
                            .font(.title3)
                        
                        Spacer()
                        
                        WeatherIconView(iconUrlString: hour.temp_icon, size: 35)
                        
                        Spacer()
                        
                        Text("\(Int(hour.temp.rounded()))°")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .padding(.vertical, 10)
                    .foregroundColor(dynamicTextColor) // Apply dynamic color
                    .listRowBackground(Color.clear) // Makes the individual row transparent
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden) // Removes the default solid background of the List
                .background(Color.clear)
            }
        }
        .navigationTitle("Hourly Forecast")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Helper Functions
    
    private func formatTime(index: Int) -> String {
        if index == 0 {
            return "12 AM"
        } else if index < 12 {
            return "\(index) AM"
        } else if index == 12 {
            return "12 PM"
        } else {
            return "\(index - 12) PM"
        }
    }
}
