//
//  NetworkService.swift
//  ZWeather
//
//  Created by Youssef Abd El-Fatah on 22/06/2026.
//

import Foundation
import Alamofire

class NetworkService {
    
    private let apiKey = "57bc8e75618146908a0173547240513"
    private let baseUrl = "https://api.weatherapi.com/v1/forecast.json"
    
    /// Method 1: Fetches forecast data using a explicit City Name string
    func fetchForecast(for city: String, completion: @escaping (Result<Forecast, Error>) -> Void) {
        performRequest(with: city, completion: completion)
    }
    
    /// Method 2: Fetches forecast data using GPS Coordinates
    func fetchForecast(latitude: Double, longitude: Double, completion: @escaping (Result<Forecast, Error>) -> Void) {
        let locationQuery = "\(latitude),\(longitude)"
        performRequest(with: locationQuery, completion: completion)
    }
    
    /// Core networking engine (Private to prevent exposure outside the service layer)
    private func performRequest(with query: String, completion: @escaping (Result<Forecast, Error>) -> Void) {
        let parameters: [String: String] = [
            "key": apiKey,
            "q": query,
            "days": "3"
        ]
        
        AF.request(baseUrl, parameters: parameters)
            .validate()
            // We look for the messy API Struct layout here locally
            .responseDecodable(of: WeatherAPIResponse.self) { response in
                switch response.result {
                case .success(let apiResponse):
                    // Transform the data right here in the network layer
                    let domainForecast = apiResponse.toDomain()
                    completion(.success(domainForecast))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

extension WeatherAPIResponse {
    
    func toDomain() -> Forecast {
        // Map the array of API days into your clean [Day] domain models
        let domainDays = self.forecast.forecastday.map { apiDay in
            
            // Map the hours inside each day into your clean [Hour] domain models
            let domainHours = apiDay.hour.map { apiHour in
                return Hour(
                    temp_icon: apiHour.condition.icon,
                    temp: apiHour.temp_c
                )
            }
            
            return Day(
                temp_icon: apiDay.day.condition.icon,
                temp_h: apiDay.day.maxtemp_c,
                temp_l: apiDay.day.mintemp_c,
                hours: domainHours
            )
        }
        
        // Assemble and return the complete Forecast model
        return Forecast(
            city: self.location.name,
            temp: self.current.temp_c,
            temp_description: self.current.condition.text,
            temp_h: domainDays.first?.temp_h ?? 0, // Fallback safety
            temp_l: domainDays.first?.temp_l ?? 0,
            temp_icon: self.current.condition.icon,
            days: domainDays,
            visibility: self.current.vis_km,
            humidity: self.current.humidity,
            feels_like: self.current.feelslike_c,
            pressure: self.current.pressure_mb
        )
    }
}

// 1. The top-level wrapper matching the root JSON object
struct WeatherAPIResponse: Decodable {
    let location: APILocation
    let current: APICurrent
    let forecast: APIForecastWrapper
}

struct APILocation: Decodable {
    let name: String
}

struct APICurrent: Decodable {
    let temp_c: Double
    let condition: APICondition
    let humidity: Double
    let feelslike_c: Double
    let vis_km: Double
    let pressure_mb: Double
}

struct APICondition: Decodable {
    let text: String
    let icon: String
}

struct APIForecastWrapper: Decodable {
    let forecastday: [APIForecastDay]
}

struct APIForecastDay: Decodable {
    let day: APIDayDetail
    let hour: [APIHourDetail]
}

struct APIDayDetail: Decodable {
    let maxtemp_c: Double
    let mintemp_c: Double
    let condition: APICondition
}

struct APIHourDetail: Decodable {
    let temp_c: Double
    let condition: APICondition
}
