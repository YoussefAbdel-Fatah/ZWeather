//
//  HomeView.swift
//  ZWeather
//
//  Created by Youssef Abd El-Fatah on 23/06/2026.
//


import SwiftUI

struct HomeView: View {
    // ViewModel setup
    @StateObject private var viewModel = WeatherViewModel()
    
    // Helper to determine if it's currently night time
    private var isNight: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour < 6 || hour >= 18
//        return true
    }
    
    // Dynamic Text Color based on time of day
    private var dynamicTextColor: Color {
        isNight ? .white : .black
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. Dynamic Background Image Layer
                Image(isNight ? "background_night" : "background_morning")
                    .resizable()
                    .ignoresSafeArea()
                
                // 2. State Management Layer
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(dynamicTextColor) // Matches the spinner to the time of day
                        
                } else if let forecast = viewModel.forecast {
                    // 3. Main UI Content Layer (Vertical Scroll)
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 30) {
                            
                            // TOP SECTION (Current Weather)
                            // Passes the entire forecast object
                            CurrentWeatherSection(forecast: forecast, textColor: dynamicTextColor)
                            
                            // MIDDLE SECTION (3-Day Forecast)
                            // Passes just the array of days
                            Forecast3DaySection(days: forecast.days, textColor: dynamicTextColor)
                            
                            // BOTTOM SECTION (Weather Details grid)
                            // Passes the entire forecast object
                            WeatherDetailsSection(forecast: forecast, textColor: dynamicTextColor)
                            
                        }
                        .padding()
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    // Basic Error Handling UI
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                }
            }
            .onAppear {
                // Fetch data when the view appears using Alexandria coordinates
                viewModel.locationManager.requestLocation()
            }
            // Hides navigation bar on Home Screen
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
