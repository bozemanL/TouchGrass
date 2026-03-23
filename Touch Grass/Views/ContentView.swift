//
//  ContentView.swift
//  Touch Grass
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @State private var isMenuOpen = false
    @AppStorage("isDarkMode") private var isDarkMode = true
    @State private var weatherStore = WeatherStore()
    
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
        .environment(weatherStore)
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .task(id: weatherStore.locationManager.location) {
            await weatherStore.load()
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
                    
                    NavigationLink(destination: CalendarView()) {
                        MenuItemView(icon: "calendar.circle.fill", title: "Calendar")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isOpen = false
                        }
                    })
                    
                    NavigationLink(destination: SettingsView()) {
                        MenuItemView(icon: "gear", title: "Settings")
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

#Preview {
    ContentView()
}
