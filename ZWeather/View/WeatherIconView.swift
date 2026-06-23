//
//  WeatherIconView.swift
//  ZWeather
//
//  Created by Youssef Abd El-Fatah on 23/06/2026.
//


import SwiftUI

struct WeatherIconView: View {
    let iconUrlString: String
    let size: CGFloat
    
    var body: some View {
        // 1. Fix the API's URL string by adding "https:" if it's missing
        let formattedString = iconUrlString.hasPrefix("//") ? "https:\(iconUrlString)" : iconUrlString
        
        // 2. Use SwiftUI's native AsyncImage to fetch and display the remote image
        AsyncImage(url: URL(string: formattedString)) { phase in
            switch phase {
            case .empty:
                // Show a tiny spinner while it downloads
                ProgressView()
                    .frame(width: size, height: size)
                
            case .success(let image):
                // The image downloaded successfully!
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                
            case .failure:
                // Network failed or URL was bad
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.yellow)
                    .frame(width: size, height: size)
                
            @unknown default:
                EmptyView()
            }
        }
    }
}