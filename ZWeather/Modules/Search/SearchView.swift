//
//  SearchView.swift
//  ZWeather
//
//  Created by Youssef Abd El-Fatah on 23/06/2026.
//


import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \RecentCity.searchDate, order: .reverse) private var recentCities: [RecentCity]
    
    @State private var searchText = ""
    var onCitySelected: (String) -> Void
    
    let availableCities = [
        "Alexandria", "Barcelona", "Cairo", "London",
        "New York", "Paris", "Tokyo", "Dubai", "Sydney", "Rome"
    ]
    
    // 2. Computed property to automatically filter the list based on typing
    var searchResults: [String] {
        if searchText.isEmpty {
            return availableCities
        } else {
            return availableCities.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Section 1: Recent Searches (SwiftData city names)
                if !recentCities.isEmpty && searchText.isEmpty {
                    Section("Recent Searches") {
                        ForEach(recentCities) { city in
                            Button(action: {
                                processSelection(cityName: city.name)
                            }) {
                                HStack {
                                    Image(systemName: "clock.arrow.circlepath")
                                        .foregroundColor(.gray)
                                    Text(city.name)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                }
                
                // Section 2: The Filtered Static List
                Section(searchText.isEmpty ? "All Cities" : "Search Results") {
                    ForEach(searchResults, id: \.self) { city in
                        Button(action: {
                            processSelection(cityName: city)
                        }) {
                            Text(city)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .navigationTitle("Search City")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search for a city...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    // 3. Handles saving to history and passing data back
    private func processSelection(cityName: String) {
        // Save to SwiftData using your service
        let service = SwiftDataLocalService(context: context)
        service.addCity(name: cityName)
        
        // Trigger the closure to tell HomeView to fetch the weather
        onCitySelected(cityName)
        
        // Close the search screen
        dismiss()
    }
}
