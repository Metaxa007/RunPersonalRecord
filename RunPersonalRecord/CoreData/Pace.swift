//
//  Pace.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 20.06.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import Foundation

public class Pace : NSObject, NSSecureCoding {
    public static var supportsSecureCoding = true

    private let pace: [Double: Double]
    private let restDistancePace: [Double: Double]

    public required init?(coder: NSCoder) {
        guard let pace = coder.decodeObject(forKey: "pace") as? [Double: Double],
              let restDistancePace = coder.decodeObject(forKey: "restDistancePace") as? [Double: Double] else {
                return nil
        }

        self.pace = pace
        self.restDistancePace = restDistancePace
    }

    init(pace: [Double: Double], restDistancePace: [Double: Double]) {
        self.pace = pace
        self.restDistancePace = restDistancePace

        super.init()
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(pace, forKey: "pace")
        coder.encode(restDistancePace, forKey: "restDistancePace")
    }

    func getPace() -> [Double: Double] {
        return pace
    }
    
    func getRestDistance() -> [Double: Double] {
        return restDistancePace
    }
}
