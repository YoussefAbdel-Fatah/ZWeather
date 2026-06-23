//
//  WeatherViewModel.swift
//  ZWeather
//
//  Created by Youssef Abd El-Fatah on 22/06/2026.
//


import Foundation

class WeatherViewModel: ObservableObject {
    
    // UI-facing states
    @Published var forecast: Forecast?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Internal instance of your network client
    private let networkService = NetworkService()
    
    /// Requests weather via text input (City name)
    func getWeather(for city: String) {
        setupLoadingState()
        
        networkService.fetchForecast(for: city) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let pureForecast):
                self.forecast = pureForecast
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    /// Requests weather via GPS location coordinates
    func getWeather(latitude: Double, longitude: Double) {
        setupLoadingState()
        
        networkService.fetchForecast(latitude: latitude, longitude: longitude) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let pureForecast):
                self.forecast = pureForecast
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func setupLoadingState() {
        self.isLoading = true
        self.errorMessage = nil
    }
}