//
//  Utilities.swift
//  RouteSaver
//
//  Created by Artsem Lemiasheuski on 29.04.20.
//  Copyright © 2020 metaxa.routeSaver. All rights reserved.
//

import Foundation
import CoreLocation

struct Utilities {
    static let manager = Utilities()
    
    private init() {}
    
    //TODO: return kilometers. i.e. 1.5 km.
    func getDistance(locations: [CLLocation]) -> Double {
        var distance = 0.0
        
        //Do not include the last element, otherwise Array out of range. The last iteration should be between the penultimate and the last element.
        for i in 0..<locations.count - 1 {
            let coordinateA = locations[i]
            let coordinateB = locations[i+1]

            distance += getDistanceBetweenToPoints(start: coordinateA, end: coordinateB)
        }
        
        return distance
    }
    
    private func getDistanceBetweenToPoints(start: CLLocation, end: CLLocation) -> CLLocationDistance {
        return start.distance(from: end)
    }
    
    func clLocationToLocation(clLocations: [CLLocation]) -> [Location] {
        var locations: [Location] = []
        
        for clLocation in clLocations {
            let location = Location(latitude: clLocation.coordinate.latitude, longitude: clLocation.coordinate.longitude)
            locations.append(location)
        }
    
        return locations
    }
    
    func secondsToTime(durationInSeconds: TimeInterval) -> String {
        let hours = Int(durationInSeconds) / 3600
        let minutes = Int(durationInSeconds) / 60 % 60
        let seconds = Int(durationInSeconds) % 60
                
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
}
