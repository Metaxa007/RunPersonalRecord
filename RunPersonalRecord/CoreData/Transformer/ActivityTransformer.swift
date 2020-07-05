//
//  ActivityTransformer.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 05.07.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import Foundation

// 1. Subclass from `NSSecureUnarchiveFromDataTransformer`
@objc(ActivityTransformer)
final class ActivityTransformer: NSSecureUnarchiveFromDataTransformer {

    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: ActivityTransformer.self))

    // 2. Make sure `UIColor` is in the allowed class list.
    override static var allowedTopLevelClasses: [AnyClass] {
        return [Activity.self]
    }

    /// Registers the transformer.
    public static func register() {
        let transformer = ActivityTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
