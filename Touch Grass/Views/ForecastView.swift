//
//  ForecastView.swift
//  Touch Grass
//
//


import SwiftUI
import CoreLocation

struct ForecastView: View {
    @Environment(WeatherStore.self) private var store
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            
            // If the location of the forecast exists, show the location.
            
            VStack(spacing: 15) {
                if let location = store.location {
                    Text("\(location.city), \(location.state)")
                        .foregroundColor(.secondary)
                }
                
                
                // If the forecast exists, display forecast information.
                if let forecast = store.todayForecast {
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
                        .foregroundColor(.primary)
                    
                    Text("High: \(forecast.temperature)°\(forecast.temperatureUnit)")
                        .foregroundColor(.primary)
                    
                    Text(forecast.shortForecast)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .frame(minWidth: 200)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(20)
            .padding(.horizontal, 50)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ForecastView()
}
