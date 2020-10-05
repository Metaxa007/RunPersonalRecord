//
//  ActivityDoneViewController.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 26.09.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit
import MapKit

private let infoCell = "infoCell"

class ActivityDoneViewController: UIViewController {
    
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var splitsTableView: UITableView!
    
    private var paceDic = [Int : Double]()
    private var restDistPaceDic = [Int : Double]()
    
    private var activity: ActivityEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity = getActivity()
        paceDic = activity.pace?.getPace() ?? [:]
        restDistPaceDic = activity.pace?.getRestDistance() ?? [:]

        infoTableView.delegate = self
        infoTableView.dataSource = self
        splitsTableView.delegate = self
        splitsTableView.dataSource = self
        mapView.delegate = self
        
        infoTableView.tableFooterView = UIView()
        splitsTableView.tableFooterView = UIView()
        
        setDoneLabel()
        
        if let locationsAll = activity.activityAttribute?.getLocations() {
            for locationsInSection in locationsAll {
                if !locationsInSection.isEmpty {
                    addPolylineToMap(locations: locationsInSection)
                }
            }
        }
    }
    
    private func setDoneLabel() {
        if activity.completed {
            doneLabel.text = "Distance completed"
            doneLabel.textColor = UIColor.green
        } else {
            doneLabel.text = "Distance not completed"
            doneLabel.textColor = UIColor.red
        }
    }
    
    private func getActivity() -> ActivityEntity? {
        let activites = CoreDataManager.manager.getAllEntities()

        //Crash if last activity does not exist for some reason
        return activites![activites!.count - 1]
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
    
    private func getSplitsNumberOfRows() -> Int {
        return paceDic.count + restDistPaceDic.count
    }
    
}

extension ActivityDoneViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == infoTableView {
            return 4
        } else if tableView == splitsTableView {
            return getSplitsNumberOfRows()
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == infoTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: infoCell) as? ActivityDoneInfoTableViewCell {
                cell.setupCell(activity: activity, index: indexPath.row)
                
                return cell
            }
        } else if tableView == splitsTableView {
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == infoTableView {
            return 80
        } else if tableView == splitsTableView {
            return 55
        }

        return 0
    }
}

extension ActivityDoneViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .green
        renderer.lineWidth = 3.0
        
        return renderer
    }
}
