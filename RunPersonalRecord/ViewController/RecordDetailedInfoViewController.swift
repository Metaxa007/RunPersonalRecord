//
//  RecordDetailedInfoViewController.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 29.08.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit
import MapKit

class RecordDetailedInfoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    private var activity: ActivityEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    public func setActivity(activity: ActivityEntity) {
        self.activity = activity
    }
}
