//
//  RecordDetailedInfoViewController.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 29.08.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit
import MapKit

// Good ScrollView tutorial https://fluffy.es/scrollview-storyboard-xcode-11/

class RecordDetailedInfoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dateDistanceLabel: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    private var activity: ActivityEntity!
    private var place: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        dateDistanceLabel.text = "\(Utilities.manager.getDistanceInKmAsString(distance: Int(activity.distance))) on \(Utilities.manager.getDateAsddMMMyyyy(date: activity.date ?? Date()))"
        placeLabel.text = "\(place ?? 0) place"
        durationLabel.text = "\(Utilities.manager.getTimeInRegularFormat(duration: activity.duration))"
        speedLabel.text = getSpeedAsString()
        paceLabel.text = getPaceAsString()
    }
    
    // Called before viewDidLoad()
    public func setActivity(activity: ActivityEntity, place: Int) {
        self.activity = activity
        self.place = place + 1 // row beginns from 0
    }
    
    private func getSpeedAsString() -> String {
        return "\(String(format: "%.1f", Double(activity.distance) / activity.duration * 3.6)) km/h"
    }
    
    private func getPaceAsString() -> String {
        return "\(Utilities.manager.getTimeInPaceFormat(duration: activity.duration / Double(activity.distance / 1000)))"
    }
}

extension RecordDetailedInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
