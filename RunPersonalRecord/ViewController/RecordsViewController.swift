//
//  RecordsViewController.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 22.08.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

class RecordsViewController: UIViewController {
    
    private var distance = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Records \(Utilities.manager.distanceAsString(distance: distance))"
    }
    
    public func setDistance(distance: Int) {
        self.distance = distance
    }
}
