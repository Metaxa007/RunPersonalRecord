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
        
        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        dateDistanceLabel.text = "\(Utilities.manager.getDistanceInKmAsString(distance: Int(activity.distance))) on \(Utilities.manager.getDateAsddMMMyyyy(date: activity.date ?? Date()))"
        placeLabel.text = "\(place ?? 0) place"
        durationLabel.text = "\(Utilities.manager.getTimeInRegularFormat(duration: activity.duration))"
        speedLabel.text = getSpeedAsString()
        paceLabel.text = getPaceAsString()
        
        if let locations = activity.activityAttribute?.getLocations() {
            print("addpolylinetomap")
            print("count = \(locations[0].count)")
            addPolylineToMap(locations: locations[0])
        }
        
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
        tableView.rowHeight = 55 // for some reason even if heightForRowAt is set rowHeight return -1
        contentViewHeight.constant =
            664 + tableView.rowHeight * (CGFloat(getNumberOfRows()) == 0 ? 2 : CGFloat(getNumberOfRows())) // 664 is ContentHeight without tableView
        tableViewHeight.constant = 55 * (CGFloat(getNumberOfRows()) == 0 ? 2 : CGFloat(getNumberOfRows())) // Multiply by 2 to show emplyLabel
    }
    
    // Called before viewDidLoad()
    public func setActivity(activity: ActivityEntity, place: Int) {
        self.activity = activity
        self.place = place + 1 // row beginns from 0
        self.paceDic = activity.pace?.getPace() ?? [:]
        self.restDistpaceDic = activity.pace?.getRestDistance() ?? [:]
    }
    
    private func getSpeedAsString() -> String {
        return "\(String(format: "%.1f", Double(activity.distance) / activity.duration * 3.6)) km/h"
    }
    
    private func getPaceAsString() -> String {
        return "\(Utilities.manager.getTimeInPaceFormat(duration: activity.duration / Double(activity.distance / 1000)))"
    }
    
    private func getNumberOfRows() -> Int {
        return paceDic.count + restDistpaceDic.count
    }
    
    func addPolylineToMap(locations: [CLLocation]) {
        let coordinates = locations.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        let region = MKCoordinateRegion(center: coordinates[0], span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        mapView.addOverlay(polyline)
    }
}

extension RecordDetailedInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if getNumberOfRows() == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            emptyLabel.text = "No pace data is available"
            emptyLabel.textAlignment = .center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = .none

            return 0
        }
        
        return getNumberOfRows()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RecordDetailedInfoViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .green
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate,
                                      span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        mapView.setRegion(region, animated: true)
    }
}
