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
private let detailedMapInfoSegue = "detailedMapInfoSegue"

class RecordDetailedInfoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dateDistanceLabel: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    private var activity: ActivityEntity!
    private var place: Int!
    private var paceDic = [Int : Double]()
    private var restDistPaceDic = [Int : Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        dateDistanceLabel.text = "\(Utilities.manager.getDistanceInKmAsString(distance: Int(activity.distanceToRun))) on \(Utilities.manager.getDateAsddMMMyyyy(date: activity.date ?? Date()))"
        placeLabel.text = "\(place ?? 0) \(NSLocalizedString("place", comment: ""))"
        durationLabel.text = "\(Utilities.manager.getTimeInRegularFormat(duration: activity.duration))"
        avgSpeedLabel.text = getSpeedAsString()
        avgPaceLabel.text = getPaceAsString()
                
        if let locationsAll = activity.activityAttribute?.getLocations() {
            for locationsInSection in locationsAll {
                if !locationsInSection.isEmpty {
                    addPolylineToMap(locations: locationsInSection)
                }
            }
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
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        mapView.isUserInteractionEnabled = true
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = 55 // for some reason even if heightForRowAt is set rowHeight return -1
        contentViewHeight.constant =
            664 + tableView.rowHeight * (CGFloat(getNumberOfRows()) == 0  ? 2 : CGFloat(getNumberOfRows())) + 10 // 664 is ContentHeight without tableView. 10 is some safe area. Otherwise scrollView stucks while scrolling if only 1 object in the tableView
        tableViewHeight.constant = 55 * (CGFloat(getNumberOfRows()) == 0 ? 2 : CGFloat(getNumberOfRows())) // Multiply by 2 to show emplyLabel
    }
    
    @objc func mapViewTapped() {
        performSegue(withIdentifier: detailedMapInfoSegue, sender: self)
    }
    
    // Called before viewDidLoad()
    public func setActivity(activity: ActivityEntity, place: Int) {
        self.activity = activity
        self.place = place + 1 // row beginns from 0
        self.paceDic = activity.pace?.getPace() ?? [:]
        self.restDistPaceDic = activity.pace?.getRestDistance() ?? [:]
    }
    
    private func getSpeedAsString() -> String {
        return "\(String(format: "%.1f", Double(activity.completedDistance) / activity.duration * 3.6)) \(NSLocalizedString("km_h", comment: ""))"
    }
    
    private func getPaceAsString() -> String {
        return "\(Utilities.manager.getTimeInPaceFormat(duration: activity.duration / (Double(activity.completedDistance) / 1000)))"
    }
    
    private func getNumberOfRows() -> Int {
        return paceDic.count + restDistPaceDic.count
    }
    
    private func addPolylineToMap(locations: [CLLocation]) {
        let coordinates = locations.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        var regionRect = polyline.boundingMapRect
        let wPadding = regionRect.size.width
        let hPadding = regionRect.size.height
        
        //Add padding to region
        regionRect.size.width += wPadding
        regionRect.size.height += hPadding

        //Center the region on the line. X,Y coordinates on the map.
        regionRect.origin.x -= wPadding / 2
        regionRect.origin.y -= hPadding / 2
        
        mapView.setRegion(MKCoordinateRegion(regionRect), animated: true)
        mapView.addOverlay(polyline)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailedMapInfoSegue {
            let navigationController = segue.destination as! UINavigationController

            if let destinationSegue = navigationController.viewControllers[0] as? MapViewDetailedInfoViewController {
                destinationSegue.setActivity(activity: activity)
            }
        }
    }
}

extension RecordDetailedInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if getNumberOfRows() == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            emptyLabel.text = NSLocalizedString("no_pace_data", comment: "")
            emptyLabel.textAlignment = .center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = .none

            return 0
        }
        
        return getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "paceCell") as? PaceTableViewCell {
            if indexPath.row + 1 == getNumberOfRows() && !restDistPaceDic.isEmpty {
                let distance = Double(restDistPaceDic.first?.key ?? 0) / 1000
                let pace = restDistPaceDic.first?.value ?? 0

                cell.setCell(distance: distance, pace: pace)
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
}
