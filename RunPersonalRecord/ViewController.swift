//
//  ViewController.swift
//  RouteSaver
//
//  Created by Artsem Lemiasheuski on 14.01.20.
//  Copyright © 2020 Artsem Lemiasheuski. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startStopLocatingButton: UIButton!

    var lastLocation: CLLocation?
    var locations: [LocationEntity] = []
    var isLocatingStarted = false {
        didSet {
            if isLocatingStarted == true {
                startStopLocatingButton.setTitle("Stop Tracking", for: .normal)
                startLocating()
            } else {
                startStopLocatingButton.setTitle("Start Tracking", for: .normal)
                stopLocating()
            }
        }
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapView()
        roundCorners()
        addPolylineToMap(locations: LocationsArray.array)
    }
    
    @IBAction func startStopLocating(_ sender: UIButton) {
        isLocatingStarted = !isLocatingStarted
    }
        
    func setUpMapView() {
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        startLocating()
    }
    
    func startLocating() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 0
        locationManager.allowsBackgroundLocationUpdates = true
        
        locationManager.startUpdatingLocation()
    }
    
    func stopLocating() {
        locationManager.stopUpdatingLocation()
    }
    
    func roundCorners() {
        startStopLocatingButton.layer.cornerRadius = 30
        startStopLocatingButton.clipsToBounds = true
    }
    
    func addPolylineToMap(locations: [CLLocation]) {
        let coordinates = locations.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        let region = MKCoordinateRegion(center: coordinates[0], span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        mapView.addOverlay(polyline)
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if lastLocation?.coordinate.latitude != location.coordinate.latitude &&
                lastLocation?.coordinate.longitude != location.coordinate.longitude  {
                lastLocation = location
                CoreDataManager.manager.saveLocation(location: location)
            }
        }
    }

    // MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("renderer")
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
                
        mapView.setRegion(region, animated: true)
    }
    
}

