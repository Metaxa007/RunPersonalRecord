//
//  MapViewDetailedInfoViewController.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 20.09.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit
import MapKit

class MapViewDetailedInfoViewController: UIViewController {

    private var activity: ActivityEntity!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        if let locationsAll = activity.activityAttribute?.getLocations() {
            for locationsInSection in locationsAll {
                if !locationsInSection.isEmpty {
                    addPolylineToMap(locations: locationsInSection)
                }
            }
        }
    }
    
    public func setActivity(activity: ActivityEntity) {
        self.activity = activity
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
}

extension MapViewDetailedInfoViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .green
        renderer.lineWidth = 3.0
        
        return renderer
    }
}
