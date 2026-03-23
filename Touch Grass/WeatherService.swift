//
//  WeatherService.swift
//  Touch Grass
//

import Foundation

struct NOAAPointResponse: Codable {
    let properties: PointProperties
}

struct PointProperties: Codable {
    let forecast: String
    let relativeLocation: RelativeLocation
}

struct RelativeLocation: Codable {
    let properties: RelativeLocationProperties
}

struct RelativeLocationProperties: Codable {
    let city: String
    let state: String
}

struct LocationInfo {
    let city: String
    let state: String
    let forecastURL: String
}

struct NOAAForecastResponse: Codable {
    let properties: ForecastProperties
}

struct ForecastProperties: Codable {
    let periods: [ForecastPeriod]
}

struct ForecastPeriod: Codable {
    let number: Int
    let name: String
    let temperature: Int
    let temperatureUnit: String
    let shortForecast: String
    let detailedForecast: String
    let icon: String
}

func getLocationInfo(latitude: Double, longitude: Double) async -> LocationInfo? {
    // Create a URL for the User's location.
    let pointURLString = "https://api.weather.gov/points/\(latitude),\(longitude)"
    
    guard let pointURL = URL(string: pointURLString) else {
        print("Error. Could not create URL from string: \(pointURLString)")
        return nil
    }
    
    // Config for the http request.
    var pointRequest = URLRequest(url: pointURL)
    pointRequest.setValue("application/geo+json", forHTTPHeaderField: "Accept")
    pointRequest.setValue("TouchGrass, test@test.com", forHTTPHeaderField: "User-Agent")

    let pointData: Data
    let pointResponse: URLResponse
    
    // Requesting a weather station.
    do {
        (pointData, pointResponse) = try await URLSession.shared.data(for: pointRequest)
        print("Successfully retrieved weather data from: \(pointURL)")
    } catch {
        print ("Error during fetch.")
        return nil
    }
    
    // If we get a good http response, then continue.
    if let httpResponse = pointResponse as? HTTPURLResponse {
        if httpResponse.statusCode != 200 {
            print("expected 200 but got \(httpResponse.statusCode)")
            return nil
        }
    }
    
    
    // Decode the HTTP response into Json and return the location info in an object.
    do {
        let pointResult = try JSONDecoder().decode(NOAAPointResponse.self, from: pointData)
        let pointResultProperties = pointResult.properties
        return LocationInfo(
            city: pointResultProperties.relativeLocation.properties.city,
            state: pointResultProperties.relativeLocation.properties.state,
            forecastURL: pointResultProperties.forecast)
    } catch {
        print("Decoding error for points response.")
        return nil
    }
}




func getAllForecastPeriods(forecastURLString: String) async -> [ForecastPeriod] {
    guard let forecastURL = URL(string: forecastURLString) else { return [] }

    var forecastRequest = URLRequest(url: forecastURL)
    forecastRequest.setValue("application/geo+json", forHTTPHeaderField: "Accept")
    forecastRequest.setValue("TouchGrass, test@test.com", forHTTPHeaderField: "User-Agent")

    guard let (forecastData, forecastResponse) = try? await URLSession.shared.data(for: forecastRequest),
          let httpResponse = forecastResponse as? HTTPURLResponse,
          httpResponse.statusCode == 200 else { return [] }

    let result = try? JSONDecoder().decode(NOAAForecastResponse.self, from: forecastData)
    return result?.properties.periods ?? []
}
