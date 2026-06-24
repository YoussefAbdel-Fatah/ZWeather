//
//  WeatherViewModel.swift
//  ZWeather
//
//  Created by Youssef Abd El-Fatah on 22/06/2026.
//


import Foundation
import Combine
import Network // 1. Import the Network framework

class WeatherViewModel: ObservableObject {
    
    @Published var forecast: Forecast?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // 2. New property to track offline state
    @Published var isOffline: Bool = false
    
    private let networkService = NetworkService()
    let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    // 3. Network Monitor tools
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")
    
    init() {
        setupLocationListener()
        setupNetworkMonitor()
    }
    
    private func setupLocationListener() {
        locationManager.$location
            .compactMap { $0 }
            .sink { [weak self] coordinate in
                self?.getWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
            }
            .store(in: &cancellables)
    }
    
    // 4. Start listening for internet changes
    private func setupNetworkMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                // If status is not .satisfied, we are offline!
                self?.isOffline = path.status != .satisfied
            }
        }
        monitor.start(queue: monitorQueue)
    }
    
    // Updated fetch methods to respect offline status
    func getWeather(latitude: Double, longitude: Double) {
        guard !isOffline else {
            self.errorMessage = "No internet connection. Please check your network."
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        networkService.fetchForecast(latitude: latitude, longitude: longitude) { [weak self] result in
            self?.handleResult(result)
        }
    }
    
    func getWeather(for city: String) {
        guard !isOffline else {
            self.errorMessage = "No internet connection. Please check your network."
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        networkService.fetchForecast(for: city) { [weak self] result in
            self?.handleResult(result)
        }
    }
    
    private func handleResult(_ result: Result<Forecast, Error>) {
        DispatchQueue.main.async {
            self.isLoading = false
            switch result {
            case .success(let pureForecast):
                self.forecast = pureForecast
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
