//
//  ConfigurationManager.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 21.11.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import Foundation

struct ConfigurationManager {
    static let manager = ConfigurationManager()

    private(set) var configuration: AppType!

    private init () {
        if let productId = Bundle.main.bundleIdentifier {
            configuration = AppType(rawValue: productId) ?? .lite
        }
    }
}
