//
//  WeatherService.swift
//  Touch Grass
//
//  Created by Lily Bozeman on 3/1/26.
//

// Importing UIKit because that's how we can save the iconImage from the forecast. 
import UIKit

struct NOAAPointResponse: Codable {
    let properties: PointProperties
}

struct PointProperties: Codable {
    let forecast: String
    let relativeLocation: RelativeLocation
}

struct RelativeLocation: Codeable {
    let properties: RelativeLocationProperties
}

struct RelativeLocationProperties: Codeable {
    let city: String
    let state: String
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

import Foundation

func getDayForecast() async -> ForecastPeriod?{
    // These are the coordinates of San Diego State University.
    let latitude = 32.774799;
    let longitude = -117.071869;
    
    // Once we get the request from api.weather.gov for our specific coordinates,
    // 1. We verify that the response was good (a 200 return type)
    // we have to parse the JSON return into data.
    
    let pointURLString = "https://api.weather.gov/points/\(latitude),\(longitude)"
    
    guard let pointURL = URL(string: pointURLString) else {
        print("Error. Could not create URL from string: \(pointURLString)")
        return nil
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
        return nil
    }
    
    if let httpResponse = pointResponse as? HTTPURLResponse {
        if httpResponse.statusCode != 200 {
            print("expected 200 but got \(httpResponse.statusCode)")
            return nil
        }
    }
    
    let pointResult: NOAAPointResponse
    do {
        pointResult = try JSONDecoder().decode(NOAAPointResponse.self, from: pointData)
    } catch {
        print("Decoding error")
        return nil
    }

    
    // Now we are going to fetch the actual forecast.
    let forecastURLString = pointResult.properties.forecast
    
    // Setting the location of the coordinates.
    let city = pointResult.properties.relativeLocation.properties.city
    let state = pointResult.properties.relativeLocation.properties.state
    
    guard let forecastURL = URL(string: forecastURLString) else {
        print("Error. Could not create URL from string: \(forecastURLString)")
        return nil
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
        return nil
    }
    
    if let forecastHTTPResponse = forecastResponse as? HTTPURLResponse {
        if forecastHTTPResponse.statusCode != 200 {
            return nil
        }
    }
    
    let forecastResult: NOAAForecastResponse
    do {
        forecastResult = try JSONDecoder().decode(NOAAForecastResponse.self, from: forecastData)
    } catch {
        print("Decoding error for forecast.")
        return nil
    }
    
    // First period is today's forecast.
    return forecastResult.properties.periods[0]
    
}

func getWeatherIcon(from iconURLString: String) async -> UIImage? {
    guard let iconURL = URL(string: iconURLString) else {
        print("Error: invalid icon URL string: \(iconURLString)")
        return nil
    }
    
    var iconRequest = URLRequest(url: iconURL)
    // NOAA requires that we declare who we are when we request something.
    iconRequest.setValue("TouchGrass, test@test.com", forHTTPHeaderField: "User-Agent")
    
    let iconData: Data
    let iconResponse: URLResponse
    
    do {
        (iconData, iconResponse) = try await URLSession.shared.data(for: iconRequest)
    } catch {
        print("Error fetching icon: \(error)")
        return nil
    }
    
    if let httpResponse = iconResponse as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("Expected 200 but got \(httpResponse.statusCode)")
            return nil
    }
    
    return UIImage(data: iconData)
}
