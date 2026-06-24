//
//  WeatherViewModel.swift
//  ZWeather
//
//  Created by Youssef Abd El-Fatah on 22/06/2026.
//


import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    
    @Published var forecast: Forecast?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Initialize your services
    private let networkService = NetworkService()
    let locationManager = LocationManager()
    
    // Holds the Combine subscription
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupLocationListener()
    }
    
    // This listens for the exact moment the GPS coordinates are found
    private func setupLocationListener() {
        locationManager.$location
            .compactMap { $0 } // Ignores nil values
            .sink { [weak self] coordinate in
                // As soon as we get coordinates, fetch the weather!
                self?.getWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
            }
            .store(in: &cancellables)
    }
    
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
