//
//  ContentView.swift
//  Touch Grass
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @State private var isMenuOpen = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Main content
                ForecastView()
                
                // Slide-out menu
                SideMenu(isOpen: $isMenuOpen)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

// Side Menu View
struct SideMenu: View {
    @Binding var isOpen: Bool
    
    var body: some View {
        ZStack {
            // Dark overlay when menu is open
            if isOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isOpen = false
                        }
                    }
            }
            
            // Menu panel
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    // Menu Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Touch Grass")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Weather App")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 60)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                    
                    Divider()
                        .padding(.bottom, 10)
                    
                    // Menu Items
                    NavigationLink(destination: ForecastView()) {
                        MenuItemView(icon: "house.fill", title: "Home")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isOpen = false
                        }
                    })
                    
                    NavigationLink(destination: SevenDayForecastView()) {
                        MenuItemView(icon: "calendar", title: "7-Day Forecast")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isOpen = false
                        }
                    })
                    
                    Spacer()
                }
                .frame(width: 280)
                .background(Color(uiColor: .systemBackground))
                .offset(x: isOpen ? 0 : -280)
                
                Spacer()
            }
        }
    }
}

// Menu Item View
struct MenuItemView: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.primary)
                .frame(width: 30)
            
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .contentShape(Rectangle())
    }
}

// 7-Day Forecast View
struct SevenDayForecastView: View {
    // Generate array of next 7 days starting from today
    private var forecastDays: [(label: String, date: Date)] {
        let calendar = Calendar.current
        let today = Date()
        
        return (0..<7).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: dayOffset, to: today)!
            let label: String
            
            if dayOffset == 0 {
                label = "Today"
            } else {
                // Format the date to get the day of the week (Monday, Tuesday, etc.)
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE"
                label = formatter.string(from: date)
            }
            
            return (label: label, date: date)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("7-Day Forecast")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            // Scrollable list of forecast days
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(0..<forecastDays.count, id: \.self) { index in
                        DayForecastRow(dayLabel: forecastDays[index].label)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Individual day forecast row
struct DayForecastRow: View {
    let dayLabel: String
    
    var body: some View {
        HStack {
            // Day of week label
            Text(dayLabel)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .frame(width: 120, alignment: .leading)
            
            Spacer()
            
            // PLACEHOLDER FOR FORECAST ICON
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "cloud.sun.fill")
                        .foregroundColor(.secondary)
                        .font(.title2)
                )
            
            // PLACEHOLDER FOR TEMP
            VStack(alignment: .trailing, spacing: 4) {
                Text("--°")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("--°")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(width: 60, alignment: .trailing)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

// This is a view that contains all of our forecast display.
struct ForecastView: View {
    // State variables to hold our current forecast.
    @State private var locationManager = LocationManager()
    @State private var forecast: ForecastPeriod? = nil
    @State private var location: LocationInfo? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Touch Grass")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, -70)
            
            // If the location of the forecast exists, show the location.
            
            VStack(spacing: 15) {
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
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .background(Color(white: 0.15))
            .cornerRadius(20)
            
            .task (id: locationManager.location) {
                // Get the user's current location on startup.
                guard let cords = locationManager.location else {
                    return
                }
                
                // Get weather station forecast of the user's location.
                location = await getLocationInfo(latitude: cords.latitude, longitude: cords.longitude)
                
                // If the forecastURL has been loaded, then request the daily forecast.
                if let forecastURL = location?.forecastURL {
                    forecast = await getDayForecast(forecastURLString: forecastURL)
                    
                    // If there's a forecast 
                    if let forecast = forecast {
                        await scheduleWeatherNotification(forecast: forecast)
                    }
                }
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}

