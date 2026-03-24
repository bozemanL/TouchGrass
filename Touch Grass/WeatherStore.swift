//
//  WeatherStore.swift
//  Touch Grass
//

import SwiftUI

@Observable
class WeatherStore {
    var periods: [ForecastPeriod] = []
    var location: LocationInfo? = nil
    var locationManager = LocationManager()
    
    // Today's forecast
    var todayForecast: ForecastPeriod? { periods.first }
    
    init() {
        // Re-schedule the notification whenever the user changes a setting
        NotificationCenter.default.addObserver(
            forName: .notificationSettingsChanged,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self, let today = self.todayForecast else { return }
            Task { await scheduleWeatherNotification(forecast: today) }
        }
    }
    
    func load() async {
        guard let coords = locationManager.location else { return }
        location = await getLocationInfo(latitude: coords.latitude, longitude: coords.longitude)
        
        if let forecastURL = location?.forecastURL {
            let result = await getAllForecastPeriods(forecastURLString: forecastURL)
            periods = result
            if let today = todayForecast {
                await scheduleWeatherNotification(forecast: today)
            }
        }
    }
}
