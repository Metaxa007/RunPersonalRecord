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

    private let pace: [Int: Double]
    private let restDistancePace: [Int: Double]

    public required init?(coder: NSCoder) {
        guard let pace = coder.decodeObject(of: [NSDictionary.self], forKey: "pace") as? [Int: Double],
              let restDistancePace = coder.decodeObject(of: [NSDictionary.self], forKey: "restDistancePace") as? [Int: Double] else {
                return nil
        }

        self.pace = pace
        self.restDistancePace = restDistancePace
    }

    init(pace: [Int: Double], restDistancePace: [Int: Double]) {
        self.pace = pace
        self.restDistancePace = restDistancePace

        super.init()
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(pace, forKey: "pace")
        coder.encode(restDistancePace, forKey: "restDistancePace")
    }

    func getPace() -> [Int: Double] {
        return pace
    }
    
    func getRestDistance() -> [Int: Double] {
        return restDistancePace
    }
}
