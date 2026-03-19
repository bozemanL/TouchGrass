//
//  NotificationService.swift
//  Touch Grass
//

import UserNotifications


func scheduleWeatherNotification(forecast: ForecastPeriod) async {
    // Get the current user's notification settings.
    let center = UNUserNotificationCenter.current()
    
    let settings = await center.notificationSettings()
    guard settings.authorizationStatus == .authorized else {
        return
    }
    
    let isSunny = forecast.shortForecast.lowercased().contains("sunny") || forecast.shortForecast.lowercased().contains("clear")
    let isWarm = forecast.temperature >= 0
    
    guard isSunny && isWarm else {
        return
    }
    
    let content = UNMutableNotificationContent()
    content.title = "Touch Grass"
    content.body = "It's \(forecast.temperature)°\(forecast.temperatureUnit) and sunny!"
    content.sound = .default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
    
    let request = UNNotificationRequest(identifier: "weather-notification", content: content, trigger: trigger)
    
    center.removePendingNotificationRequests(withIdentifiers: ["weather-notification"])
    
    do {
        try await center.add(request)
    } catch {
        print("Failed to schedule notification.")
    }
}
