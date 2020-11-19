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
    private var annotationsDict: [Int:CLLocationCoordinate2D] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("details", comment: "")
        
        mapView.delegate = self

        if let locationsAll = activity.activityAttribute?.getLocations() {
            for locationsInSection in locationsAll {
                if !locationsInSection.isEmpty {
                    addPolylineToMap(locations: locationsInSection)
                }
            }
        }
        
        setStartFinishLocations()
        setAnnotationsDict()
        createAnnotations()
    }
    
    public func setActivity(activity: ActivityEntity) {
        self.activity = activity
    }
    
    private func setAnnotationsDict() {
        let locations = activity.activityAttribute?.getLocations()
        
        if let locations = locations {
            var totalDistance = 0.0
            var kilometers = 0.0
            
            for locationsInSection in locations {
                for i in 0..<locationsInSection.count - 1 {
                    let coordinateA = locationsInSection[i]
                    let coordinateB = locationsInSection[i+1]
                    
                    totalDistance += coordinateA.distance(from: coordinateB)

                    if totalDistance / 1000 >= kilometers + 1 {
                        kilometers += 1
                        annotationsDict[Int(kilometers)] = coordinateB.coordinate
                    }
                }
            }
        }
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
        if let startCoordinate = startCoordinate {
            let startAnnotation = CustomPointAnnotation()
            startAnnotation.coordinate = startCoordinate
            startAnnotation.tag = "Start"
            
            mapView.addAnnotation(startAnnotation)
        }

        if let finishCoordinate = finishCoordinate {
            let finishAnnotation = CustomPointAnnotation()
            finishAnnotation.coordinate = finishCoordinate
            finishAnnotation.tag = "Finish"
            
            mapView.addAnnotation(finishAnnotation)
        }
        
        for annotationDict in annotationsDict {
            let annotation = CustomPointAnnotation()
            annotation.tag = String(annotationDict.key)
            annotation.coordinate = annotationDict.value
            
            mapView.addAnnotation(annotation)
        }
    }
    
    private func setStartFinishLocations() {
        if let locationsAll = activity.activityAttribute?.getLocations() {
            for i in 0..<locationsAll.count {
                if i == 0 {
                    if let firstLocation = locationsAll[i].first {                        
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
    
    private func getAnnotationLabel(distance: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        label.text = "\(distance) km"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.white
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 0
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true

        label.center.x = 10
        label.center.y = 0.5 * label.frame.height;
        
        return label
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
        guard !(annotation is MKUserLocation) else { return nil }
        
        guard let anno = annotation as? CustomPointAnnotation else { return nil }
        
        let annotaionIdentifier = "AnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotaionIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: anno, reuseIdentifier: annotaionIdentifier)
        }
        
        if let tag = anno.tag, tag == "Start" {
            annotationView?.image = UIImage(named: "Green_dot")
            
            let transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            annotationView?.transform = transform
        } else if let tag = anno.tag, tag == "Finish" {
            annotationView?.image = UIImage(named: "Red_dot")
            
            let transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            annotationView?.transform = transform
        } else  {
            let distance = anno.tag ?? ""
            
            annotationView?.addSubview(getAnnotationLabel(distance: distance))
        }

        return annotationView
    }
}

class CustomPointAnnotation: MKPointAnnotation {
    // Tag is used to save distance for all pins except of Start and Stop pins
    var tag: String?
}
