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
    
    func getTimeInPaceFormat(duration: TimeInterval) -> String {
        let (_, minutes, seconds) = getTime(duration: duration)
        
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    func getTimeInRegularFormat(duration:TimeInterval) -> String {
        let (hours, minutes, seconds) = getTime(duration: duration)
        
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }

    
    func getTime(duration: TimeInterval) -> (Int, Int, Int) {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60
        
        return (hours, minutes, seconds)
    }
    
    func getDateAsddMMMyyyy(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MMM, yyyy"
        
        return dateFormatter.string(from: date)
    }

    func getDistanceInKmAsString(distance: Int) -> String {
        let formatter = NumberFormatter()
        
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        if distance >= 1000 {
            return "\(formatter.string(from: NSNumber(value: Double(distance) / 1000)) ?? "") \(NSLocalizedString("kilometer", comment: ""))"
        } else {
            return "\(distance) m"
        }
    }
}
