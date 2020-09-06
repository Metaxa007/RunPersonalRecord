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

private let paceCell = "paceCell"

class RecordDetailedInfoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dateDistanceLabel: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
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
        placeImageView.image = UIImage(named: "Cup")!
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        tableViewHeight.constant = tableView.rowHeight * CGFloat(getNumberOfRows())
//        tableViewHeight.constant = 400
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
    
    private func getNumberOfRows() -> Int{
        return (activity.pace?.getPace().count ?? 0) + (activity.pace?.getRestDistance().count ?? 0)
    }
}

extension RecordDetailedInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count = \((activity.pace?.getPace().count ?? 0) + (activity.pace?.getRestDistance().count ?? 0))" )
//        return getNumberOfRows()
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "paceCell") as? PaceTableViewCell {
            cell.setCell(distance: 1000, pace: 250.0)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
