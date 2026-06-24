//
//  HomeView.swift
//  ZWeather
//
//  Created by Youssef Abd El-Fatah on 23/06/2026.
//


import SwiftUI

struct HomeView: View {
    
    @State private var showingSearch = false
    
    // ViewModel setup
    @StateObject private var viewModel = WeatherViewModel()
    
    // Helper to determine if it's currently night time
    private var isNight: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour < 6 || hour >= 18
                return true
    }
    
    // Dynamic Text Color based on time of day
    private var dynamicTextColor: Color {
        isNight ? .white : .black
    }
    
    private var topSafeAreaPadding: CGFloat {
        let window = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return window?.windows.first?.safeAreaInsets.top ?? 40
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
                            // Button for Search
                            HStack {
                                // 1. New Current Location Button
                                Button(action: {
                                    // This triggers the GPS. The ViewModel is already listening for the result!
                                    viewModel.locationManager.requestLocation()
                                }) {
                                    Image(systemName: "location.fill")
                                        .font(.title2)
                                        .foregroundColor(dynamicTextColor)
                                        .padding()
                                }
                                
                                Spacer()
                                Button(action: {
                                    showingSearch = true
                                }) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.title2)
                                        .foregroundColor(dynamicTextColor)
                                        .padding()
                                }
                            }
                            
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
                    VStack {
                        HStack {
                            Button(action: {
                                // This triggers the GPS. The ViewModel is already listening for the result!
                                viewModel.locationManager.requestLocation()
                            }) {
                                Image(systemName: "location.fill")
                                    .font(.title2)
                                    .foregroundColor(dynamicTextColor)
                                    .padding()
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                }
                
                if viewModel.isOffline {
                    Text("Offline Mode - No Internet Connection")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(0.8))
                        // Pushes the banner down just below the safe area notch/Dynamic Island
                        .padding(.top, topSafeAreaPadding)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.easeInOut, value: viewModel.isOffline)
                        .zIndex(1) // Ensures it draws completely above the ScrollView
                }
            }
            .onAppear {
                if viewModel.forecast == nil {
                    viewModel.locationManager.requestLocation()
                }
            }
            .sheet(isPresented: $showingSearch) {
                SearchView { selectedCityName in
                    // This code runs when the user picks a city in the SearchView!
                    viewModel.getWeather(for: selectedCityName)
                }
            }
            // Hides navigation bar on Home Screen
            .toolbar(.hidden, for: .navigationBar)
            
            
        }
    }
}
