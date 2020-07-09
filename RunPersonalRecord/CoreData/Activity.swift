//
//  Activity.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 17.05.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

//https://www.kairadiagne.com/2020/01/13/nssecurecoding-and-transformable-properties-in-core-data.html One or more models in this application are using transformable properties with transformer names that are either unset, or set to NSKeyedUnarchiveFromDataTransformerName.

import UIKit
import CoreLocation

public class Activity: NSObject, NSSecureCoding {
    public static var supportsSecureCoding = true

    private let locations: [[CLLocation]]

    public required init?(coder: NSCoder) {
        guard let locations = coder.decodeObject(of: [NSArray.self, CLLocation.self], forKey: "locations") as? [[CLLocation]] else {
                return nil
        }
        
        self.locations = locations
    }

    init(locations: [[CLLocation]]) {
        self.locations = locations

        super.init()
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(locations, forKey: "locations")
    }

    func getLocations() -> [[CLLocation]] {
        return locations
    }

}
