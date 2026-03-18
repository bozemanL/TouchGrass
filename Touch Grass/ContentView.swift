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

struct ForecastView: View {
    @State private var forecast: ForecastPeriod? = nil
    
    var body: some View {
        VStack {
            if let forecast = forecast {
                Text(forecast.name)
                    .font(.largeTitle)
                Text("High: \(forecast.temperature)°\(forecast.temperatureUnit)")
                Text(forecast.shortForecast)
                
                
                
                
                AsyncImage (url: URL(string: forecast.icon)) {
                    image in image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }.frame(width: 100, height: 100)
                
            }
        } .task {
            forecast = await getDayForecast()
        }
    }
}

#Preview {
    ContentView()
}
