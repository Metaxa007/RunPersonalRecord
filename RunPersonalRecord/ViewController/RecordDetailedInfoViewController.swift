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
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    private var activity: ActivityEntity!
    private var place: Int!
    private var paceDic = [Int : Double]()
    private var restDistpaceDic = [Int : Double]()
    
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
        
        switch place {
        case 1:
            placeImageView.image = UIImage(named: "GoldMedal")!
        case 2:
            placeImageView.image = UIImage(named: "SilverMedal")!
        case 3:
            placeImageView.image = UIImage(named: "BronzeMedal")!
        default:
            placeImageView.image = UIImage(named: "DefaultMedal")!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        contentViewHeight.constant = 664 + 55 * CGFloat(getNumberOfRows()) // 664 is ContentHeight without tableView
        tableViewHeight.constant = 55 * CGFloat(getNumberOfRows())
//        contentViewHeight.constant = 664 + 6*55
//        tableViewHeight.constant = 6*55
        
        print(tableView.rowHeight)
        print(CGFloat(getNumberOfRows()))
    }
    
    // Called before viewDidLoad()
    public func setActivity(activity: ActivityEntity, place: Int) {
        self.activity = activity
        self.place = place + 1 // row beginns from 0
        self.paceDic = activity.pace?.getPace() ?? [:]
        self.restDistpaceDic = activity.pace?.getRestDistance() ?? [:]
        
//        self.paceDic[1] = 250
//        self.paceDic[2] = 290
//        self.paceDic[3] = 254
//        self.paceDic[4] = 221
//        self.paceDic[5] = 258
//
//        self.restDistpaceDic[250] = 123
        
        print(paceDic.count)
        print(restDistpaceDic.count)
    }
    
    private func getSpeedAsString() -> String {
        print(tableView.rowHeight)
        return "\(String(format: "%.1f", Double(activity.distance) / activity.duration * 3.6)) km/h"
    }
    
    private func getPaceAsString() -> String {
        return "\(Utilities.manager.getTimeInPaceFormat(duration: activity.duration / Double(activity.distance / 1000)))"
    }
    
    private func getNumberOfRows() -> Int{
//        return (activity.pace?.getPace().count ?? 0) + (activity.pace?.getRestDistance().count ?? 0)
        return paceDic.count + restDistpaceDic.count
    }
}

extension RecordDetailedInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("count = \((activity.pace?.getPace().count ?? 0) + (activity.pace?.getRestDistance().count ?? 0))" )
        return getNumberOfRows()
//        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "paceCell") as? PaceTableViewCell {
            if indexPath.row + 1 == getNumberOfRows() && !restDistpaceDic.isEmpty {
                let distance = (restDistpaceDic.first?.value ?? 0.0) / 1000
                cell.setCell(distance: distance, pace: restDistpaceDic.first?.value ?? 0)
            } else {
                cell.setCell(distance: Double(indexPath.row + 1), pace: paceDic[indexPath.row + 1] ?? 0)
            }

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
