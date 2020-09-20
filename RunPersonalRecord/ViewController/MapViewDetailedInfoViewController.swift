//
//  MapViewDetailedInfoViewController.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 20.09.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

class MapViewDetailedInfoViewController: UIViewController {

    private var activity: ActivityEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public func setActivity(activity: ActivityEntity) {
        self.activity = activity
    }

}
