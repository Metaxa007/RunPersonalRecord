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

    @IBOutlet weak var mapView: MKMapView!
    
    private var activity: ActivityEntity!
    private var startCoordinate: CLLocationCoordinate2D?
    private var finishCoordinate: CLLocationCoordinate2D?
    
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
        
        setStartFinishLocations()
        createAnnotations()
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
    
    private func createAnnotations() {
        let startAnnotation = MKPointAnnotation()
        
        if let startCoordinate = startCoordinate {
            startAnnotation.coordinate = startCoordinate
            startAnnotation.title = "Start"
            
            mapView.addAnnotation(startAnnotation)
        }

        let finishAnnotation = MKPointAnnotation()
        
        if let finishCoordinate = finishCoordinate {
            finishAnnotation.coordinate = finishCoordinate
            finishAnnotation.title = "Finish"
            
            mapView.addAnnotation(finishAnnotation)
        }
    }
    
    private func setStartFinishLocations() {
        if let locationsAll = activity.activityAttribute?.getLocations() {
            for i in 0..<locationsAll.count {
                if i == 0 {
                    if let firstLocation = locationsAll[i].first {
                        print("Tag1 firstLocation \(firstLocation)")
                        
                        startCoordinate = firstLocation.coordinate
                    }
                }
                
                if i == (locationsAll.count - 1) {
                    if let lastLocation = locationsAll[i].last {
                        finishCoordinate = lastLocation.coordinate
                    }
                }
            }
        }
    }
    
}

extension MapViewDetailedInfoViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .green
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let annotaionIdentifier = "AnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotaionIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotaionIdentifier)
        }
        
        if let title = annotation.title, title == "Start" {
            annotationView?.image = UIImage(named: "Green_dot")
            
            let transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            annotationView?.transform = transform
        } else if let title = annotation.title, title == "Finish" {
            annotationView?.image = UIImage(named: "Red_dot")
            
            let transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            annotationView?.transform = transform
        }

        return annotationView
    }
}
