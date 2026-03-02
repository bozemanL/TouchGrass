//
//  WeatherService.swift
//  Touch Grass
//
//  Created by Lily Bozeman on 3/1/26.
//

struct NOAAPointResponse: Codable {
    let properties: PointProperties
}

struct PointProperties: Codable {
    let forecast: String
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
}

import Foundation

func getDayForecast() async {
    // These are the coordinates of San Diego State University.
    let latitude = 32.774799;
    let longitude = -117.071869;
    
    // Once we get the request from api.weather.gov for our specific coordinates,
    // 1. We verify that the response was good (a 200 return type)
    // we have to parse the JSON return into data.
    
    let pointURLString = "https://api.weather.gov/points/\(latitude),\(longitude)"
    
    guard let pointURL = URL(string: pointURLString) else {
        print("Error. Could not create URL from string: \(pointURLString)")
        return
    }
    
    var pointRequest = URLRequest(url: pointURL)
    pointRequest.setValue("application/geo+json", forHTTPHeaderField: "Accept")
    pointRequest.setValue("TouchGrass, test@test.com", forHTTPHeaderField: "User-Agent")

    let pointData: Data
    let pointResponse: URLResponse
    
    do {
        (pointData, pointResponse) = try await URLSession.shared.data(for: pointRequest)
        print("Successfully retrieved weather data from: \(pointURL)")
    } catch {
        print ("Error during fetch.")
        return
    }
    
    if let httpResponse = pointResponse as? HTTPURLResponse {
        if httpResponse.statusCode != 200 {
            print("expected 200 but got \(httpResponse.statusCode)")
            return
        }
    }
    
    let pointResult: NOAAPointResponse
    do {
        pointResult = try JSONDecoder().decode(NOAAPointResponse.self, from: pointData)
    } catch {
        print("Decoding error")
        return
    }

    
    // Now we are going to fetch the actual forecast.
    let forecastURLString = pointResult.properties.forecast
    
    guard let forecastURL = URL(string: forecastURLString) else {
        print("Error. Could not create URL from string: \(forecastURLString)")
        return
    }
    
    var forecastRequest = URLRequest(url: forecastURL)
    
    forecastRequest.setValue("application/geo+json", forHTTPHeaderField: "Accept")
    forecastRequest.setValue("TouchGrass, test@test.com", forHTTPHeaderField: "User-Agent")
    
    let forecastData: Data
    let forecastResponse: URLResponse
    
    do {
        (forecastData, forecastResponse) = try await URLSession.shared.data(for: forecastRequest)
    } catch {
        print("Error during second fetch")
        return
    }
    
    if let forecastHTTPResponse = forecastResponse as? HTTPURLResponse {
        if forecastHTTPResponse.statusCode != 200 {
            return
        }
    }
    
    let forecastResult: NOAAForecastResponse
    do {
        forecastResult = try JSONDecoder().decode(NOAAForecastResponse.self, from: forecastData)
    } catch {
        print("Decoding error for forecast.")
        return
    }
    
    print("TODAY'S SDSU FORECAST:")
    
    let todayForecast = forecastResult.properties.periods[0]
    print(todayForecast.name)
    print(todayForecast.temperature)
    print(todayForecast.shortForecast)
    print(todayForecast.detailedForecast)

}
