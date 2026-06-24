//
//  SwiftDataLocalService.swift
//  ZWeather
//
//  Created by Youssef Abd El-Fatah on 23/06/2026.
//


import Foundation
import SwiftData

class SwiftDataLocalService {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func addCity(name: String) {
        // Clean up the string (removes trailing spaces)
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { return }
        
        // 1. Create the new city object
        let newCity = RecentCity(name: cleanName)
        
        // 2. Insert it into the database
        // Note: Because we used @Attribute(.unique) on the name in the model, 
        // SwiftData will automatically update the existing entry rather than duplicating it!
        context.insert(newCity)
        
        // 3. Save the changes
        do {
            try context.save()
        } catch {
            print("Failed to save city: \(error.localizedDescription)")
        }
    }
}