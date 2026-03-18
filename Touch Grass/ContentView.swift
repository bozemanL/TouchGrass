//
//  ContentView.swift
//  Touch Grass
//
//  Created by Lily Bozeman on 2/17/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ForecastView()
    }
}

// This is a view that contains all of our forecast display.
struct ForecastView: View {
    // State variables to hold our current forecast.
    @State private var forecast: ForecastPeriod? = nil
    @State private var location: LocationInfo? = nil
    
    var body: some View {
        VStack {
            
            // If the location of the forecast exists, show the location.
            if let location = location {
                Text("\(location.city), \(location.state)")
            }
            
            
            // If the forecast exists, display forecast information.
            if let forecast = forecast {
                // This is an icon retrieved from NOAA api.
                AsyncImage (url: URL(string: forecast.icon)) {
                    image in image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                    .frame(width: 100, height: 100)
                    .cornerRadius(20)
                
                // Forecast information
                Text(forecast.name)
                    .font(.largeTitle)
                Text("High: \(forecast.temperature)°\(forecast.temperatureUnit)")
                Text(forecast.shortForecast)
            }
        } .task {
            // Get the location.
            location = await getLocationInfo()
            
            // If the forecastURL has been loaded, then request the forecast.
            if let forecastURL = location?.forecastURL {
                forecast = await getDayForecast(forecastURLString: forecastURL)
            }
            
        }
    }
}

#Preview {
    ContentView()
}
