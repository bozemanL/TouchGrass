//
//  LocationManager.swift
//  Touch Grass
//

import CoreLocation

struct UserCoordinates: Equatable {
    let latitude: Double
    let longitude: Double
}

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    var location: UserCoordinates? = nil

    // Configuration of the Location Manager
    // 1. reduce accuracy because we only need the city you are in.
    // 2. ask the user if we can use their location when the app is open
    // 3. start updating the location.
    override init() {
        super.init()
        manager.delegate = self
        
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    
    // These functions are DELEGATE methods. Meaning that CoreLocation calls
    // these methods whenever there's new location data.
    
    // This method gets an array of locations and then sets the location to the least location reading.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // If there are coordinates, then we set them to the UserCoordinates object. 
        if let coordinate = locations.last?.coordinate {
            location = UserCoordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
                
        // We only need to get the location once, so we stop updating the location.
        manager.stopUpdatingLocation()
    }

    
    // There was an error getting the location. Putting an error message in the console.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Could not get location: \(error.localizedDescription)")
    }
}
