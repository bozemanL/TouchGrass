//
//  NotificationService.swift
//  Touch Grass
//

import UserNotifications

// This may look a bit intense, but basically what we are doing is mapping weather forecast
// to a type of weather so that we can create a notification message.
enum WeatherType: CaseIterable {
    case sunny, cloudy, rainy, snowy
    
    var defaultsKey: String {
        switch self {
        case .sunny: return "notifyOnSunny"
        case .cloudy: return "notifyOnCloudy"
        case .rainy:  return "notifyOnRainy"
        case .snowy:  return "notifyOnSnowy"
        }
    }
    
    var keywords: [String] {
        switch self {
        case .sunny:  return ["sunny", "clear", "clear skies"]
        case .cloudy: return ["cloud", "clouds", "overcast", "fog"]
        case .rainy: return ["rain", "shower", "drizzle", "storm"]
        case .snowy: return ["snow", "ice", "flurries", "flurr", "bizzard", "sleet"]
        }
    }
    
    var emoji: String {
        switch self {
        case .sunny: return "☀️"
        case .cloudy: return "☁️"
        case .rainy: return "🌧️"
        case .snowy: return "❄️"
        }
    }
    
    func matches(_ forecast: String) -> Bool {
        keywords.contains { keyword in forecast.contains(keyword)}
    }
    
    static func isEnabled(_ key: String, default fallback: Bool) -> Bool {
        UserDefaults.standard.object(forKey: key) as? Bool ?? fallback
    }
}

func scheduleWeatherNotification(forecast: ForecastPeriod) async {
    // Get the notification center (we can get and push notification requests to this)
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: ["weather-notification"])
    
    /*
    It may seem strange to have a notification toggle inside of the app if the user has
    notifications enabled on the iOS level, but this is actually useful.
     
    Here are some reasons:
     1. The user may just want to temporarily 'pause' notifications and not want to dig through iOS settings
     2. This gives us wiggle room for the user to more granualarly configure their notifications. For example, perhaps
     they don't want weather alerts, but they do want activity alerts. In the future we may add more types of alerts and by
     adding an in-app toggle, we are leaving ourselves space to do something like that.
     */
    
    // Check if the user has disabled notifications inside of the app.
    guard WeatherType.isEnabled("notificationsEnabled", default: true) else { return }
    
    // Check if the user has disabled notifications on the iOS level.
    let settings = await center.notificationSettings()
    guard settings.authorizationStatus == .authorized else { return }
    
    // This is the description of today's forecast.
    let shortForecast = forecast.shortForecast.lowercased()
    
    // Does the weather forecast for today match the user's prefered weather?
    // If the user hasn't set a weather preference, default is sunny.
    guard let match = WeatherType.allCases.first( where: {
        WeatherType.isEnabled($0.defaultsKey, default: $0 == .sunny) && $0.matches(shortForecast)
    }) else { return }
    

    // Create the notification content
    let content = UNMutableNotificationContent()
    content.title = "Touch Grass"
    content.body = "\(match.emoji) It's \(forecast.temperature)°\(forecast.temperatureUnit) and \(forecast.shortForecast.lowercased()). It is a good time to head outside!"
    content.sound = .default
    
    // Read frequency preference (in minutes), default 60
    // Get frequency preference in minutes from the settings
    // The default is 1 minute.
    let intervalMinutes = UserDefaults.standard.object(forKey: "notificationIntervalMinutes") as? Int ?? 1
    let intervalSeconds = TimeInterval(intervalMinutes * 60)
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: intervalSeconds, repeats: true)
    let request = UNNotificationRequest(identifier: "weather-notification", content: content, trigger: trigger)
    
    // Add the request to the notification center.
    do {
        try await center.add(request)
    } catch {
        print("Failed to schedule notification: \(error)")
    }
}
