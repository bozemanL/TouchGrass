# Touch Grass
Have you ever rushed outside, excited for the sun, and got caught in the rain? When life gets busy, keeping up with the weather shouldn't be a chore. **Touch Grass** takes care of that. It sends you smart notifications when conditions are perfect for heading outside so that you can stop guessing and start going outside.

Touch grass is an improved weather app that delivers 7 day forecasts, a calendar view of upcoming weather, and proactive notifications when the weather is good.

##### Target users: Type A planners or people who need to optimize for going outside.
##### Mission: Make going outside easier. 

## Architecture
### `WeatherStore`
The central data store for the app, using SwiftUI's `@Observable` macro. It owns the `LocationManager`, fetches weather from the NOAA once a location is available, and exposes forecast data (including today's forecast) to all views via the environment.

### `LocationManager`
Handles all CoreLocation interactions. Configured for city-level accuracy (`kCLLocationAccuracyThreeKilometers`) to minimize privacy impact. Requests "when in use" authorization, fires a single location update, then stops — keeping battery usage low.

### `WeatherService`
Contains all NOAA API logic. Uses a two-step fetch:
1. **Points endpoint** (`api.weather.gov/points/{lat},{lon}`) — resolves coordinates to a weather station and returns a forecast URL and city/state info.
2. **Forecast endpoint** — fetches all forecast periods (day/night pairs) from the URL returned in step 1.

### `NotificationService`
Schedules a repeating local notification when today's forecast is sunny and above freezing. Handles the NOAA `shortForecast` string to detect sunny/clear conditions. Removes any previously scheduled notification before adding a new one to avoid duplicates.

### `Touch_GrassApp`
App entry point. Requests notification authorization on first launch and installs a `UNUserNotificationCenterDelegate` to override iOS's default behavior of suppressing notifications while the app is in the foreground — useful for testing and demos.

---

| View | Description |
|------|-------------|
| `ContentView` | Root view. Houses the `NavigationStack`, slide-out side menu, and injects `WeatherStore` into the environment. |
| `ForecastView` | Home screen. Displays today's weather icon, high temperature, and short forecast for the user's location. |
| `SevenDayForecastView` | Scrollable list of the next 7 daytime forecast periods with icons and temperatures. |
| `CalendarView` | Monthly calendar with weather icons and temperatures overlaid on days within the 7-day forecast window. Supports forward/backward month navigation. |
| `SettingsView` | Toggle dark mode, enable/disable weather alerts, and view app version info. |

---

## Technical Notes
**Why NOAA instead of WeatherKit?**  
Apple's WeatherKit requires a paid Apple Developer account. NOAA's API is free, public, and provides sufficient forecast data for this use case.

**Notification behavior in the foreground**  
By default, iOS suppresses notifications when the app is active. The `NotificationDelegate` class in `Touch_GrassApp` overrides `willPresent` to always show banners and play sounds, making it easier to test and demonstrate notification functionality.

**Forecast period indexing**  
NOAA returns alternating day/night forecast periods. The app uses even-indexed periods (0, 2, 4, ...) to extract daytime forecasts for the 7-day view and calendar.

---

## Requirements
- iOS 17+ (uses `@Observable` macro)
- Location permissions ("When In Use")
- Notification permissions (requested on first launch)
- Internet connection (NOAA API)
