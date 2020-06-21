//
//  Location.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 17.05.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import Foundation

public class Location : NSObject, NSSecureCoding {
    public static var supportsSecureCoding = true
    
    private let latitude: Double
    private let longitude: Double
    
    public required init?(coder aDecoder: NSCoder) {
        self.latitude = aDecoder.decodeDouble(forKey:"latitude")
        self.longitude = aDecoder.decodeDouble(forKey:"longitude")
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        
        super.init()
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(latitude, forKey: "latitude")
        coder.encode(longitude, forKey: "longitude")
    }
    
    func getLatitude() -> Double {
        return latitude
    }
    
    func getLongitude() -> Double {
        return longitude
    }
    
}
