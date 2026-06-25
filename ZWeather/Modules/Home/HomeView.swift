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

    private var isNight: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour < 6 || hour >= 18
//        return true
    }
    
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
                Image(isNight ? "background_night" : "background_morning")
                    .resizable()
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(dynamicTextColor)
                    
                } else if let forecast = viewModel.forecast {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 30) {
                            
                            HStack {
                                // Current Location Button
                                Button(action: {
                                    // This triggers the GPS. The ViewModel is already listening for the result.
                                    viewModel.locationManager.requestLocation()
                                }) {
                                    Image(systemName: "location.fill")
                                        .font(.title2)
                                        .foregroundColor(dynamicTextColor)
                                        .padding()
                                }
                                
                                Spacer()
                                // Button for Search
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
                            // New currnt location button
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
                        Text("No Internet Connection")
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                        Spacer()
                    }
                }
                
                if viewModel.isOffline {
                    VStack {
                        Text("Offline Mode - No Internet Connection")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.red.opacity(0.8))
                            .padding(.top, topSafeAreaPadding)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .animation(.easeInOut, value: viewModel.isOffline)
                            .zIndex(1)
                        Spacer()
                    }
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
