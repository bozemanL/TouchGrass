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
