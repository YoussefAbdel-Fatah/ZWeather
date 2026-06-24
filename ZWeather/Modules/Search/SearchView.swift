import SwiftUI
import SwiftData

struct SearchView: View {
    // Grabs the database engine from the environment
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    // Automatically fetches cities and sorts them by newest date
    @Query(sort: \RecentCity.searchDate, order: .reverse) private var recentCities: [RecentCity]
    
    @State private var searchText = ""
    
    // This closure tells the HomeView what city the user picked
    var onCitySelected: (String) -> Void
    
    var body: some View {
        NavigationStack {
            List {
                if !recentCities.isEmpty {
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
            }
            .navigationTitle("Search City")
            .navigationBarTitleDisplayMode(.inline)
            // Native iOS Search Bar
            .searchable(text: $searchText, prompt: "Search for a city...")
            // Triggers when the user hits "Return/Search" on the keyboard
            .onSubmit(of: .search) { 
                processSelection(cityName: searchText)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    // Handles the logic for both typing a new city OR tapping a recent one
    private func processSelection(cityName: String) {
        guard !cityName.isEmpty else { return }
        
        // 1. Save it to SwiftData using your new service
        let service = SwiftDataLocalService(context: context)
        service.addCity(name: cityName)
        
        // 2. Pass the name back to HomeView
        onCitySelected(cityName)
        
        // 3. Close the search sheet
        dismiss()
    }
}