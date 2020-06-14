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
    @IBOutlet weak var paceTextView: UILabel!
    @IBOutlet weak var durationTextView: UILabel!
    @IBOutlet weak var startStopLocatingButton: UIButton!
    @IBOutlet weak var distanceTextView: UILabel!
    @IBOutlet weak var distanceDescriptionTextView: UILabel!
    @IBOutlet weak var distanceTextField: UITextField!
    
    var timer: Timer?
    var distanceToRun = 0.0
    var completedDistance: Double = 0.0
    var duration: NSDateInterval?
    var startDate: Date?
    var stopDate: Date?
    var lastLocation: CLLocation?
    var locations: [CLLocation] = []
    var isLocatingStarted = false {
        didSet {
            if isLocatingStarted == true {
                startStopLocatingButton.setTitle("Stop Running", for: .normal)
                startLocating()
            } else {
                startStopLocatingButton.setTitle("Start Running", for: .normal)
                //if the user stops manualy means he did not reach the finish line, did not complete the planed distance
                stopLocating(completed: false)
            }
        }
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapView()
        roundCorners()
        addPolylineToMap(locations: LocationsArray.array)
        addToolBarToKeyBoard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer?.invalidate()
    }
    
    @IBAction func startStopLocating(_ sender: UIButton) {
        isLocatingStarted = !isLocatingStarted
    }
    
    func setUpMapView() {
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    func startLocating() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.allowsBackgroundLocationUpdates = true
        
        distanceTextField.isEnabled = false
        distanceTextField.textColor = UIColor.gray
        
        startDate = Date()
        
        locationManager.startUpdatingLocation()
        
        checkWhenDistanceIsCompleted()
    }
    
    func stopLocating(completed: Bool) {
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
        distanceTextField.isEnabled = true
        
        stopDate = Date()
        
        if let startDate = startDate, let stopDate = stopDate {
            duration = NSDateInterval.init(start: startDate, end: stopDate)
            
            if let duration = duration {
                let activity = Activity(locations: Utilities.manager.clLocationToLocation(clLocations: locations))
                CoreDataManager.manager.addEntity(activity: activity, date: startDate, duration: duration.duration, distance: distanceToRun, completed: completed)
            }
        }
        
        locations = []
    }
 
    func addToolBarToKeyBoard() {
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonClicked))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.sizeToFit()
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        
        distanceTextField.inputAccessoryView = toolBar
    }

    @objc func doneButtonClicked() {
        if let distance = distanceTextField.text {
            guard distance != "" else {
                view.endEditing(true)
                
                return
            }
            
            distanceToRun = Double(distance)!
        }
        
        view.endEditing(true)
    }
    
    @objc func cancelButtonClicked() {
        distanceTextField.text = String(distanceToRun)
        
        view.endEditing(true)
    }
    
    func checkWhenDistanceIsCompleted() {

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            guard let weakSelf = self else { return }
            guard weakSelf.locations.count > 0 else { return }

            self?.completedDistance = Utilities.manager.getDistance(locations: weakSelf.locations)
            self?.distanceTextView.text = String(Int(self!.completedDistance) ?? 0)
            
            if Utilities.manager.getDistance(locations: weakSelf.locations) >= weakSelf.distanceToRun {
                weakSelf.isLocatingStarted = false
                weakSelf.stopLocating(completed: true)
                
                timer.invalidate()
            }
        })
    }
    
    func roundCorners() {
        startStopLocatingButton.layer.cornerRadius = 25
        startStopLocatingButton.clipsToBounds = true
    }
    
    func addPolylineToMap(locations: [CLLocation]) {
        let coordinates = locations.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        let region = MKCoordinateRegion(center: coordinates[0], span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        mapView.addOverlay(polyline)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? SettingsViewController {
            target.viewController = self
        }
    }
    
    // MARK: CLLocationManagerDelegate -
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if lastLocation?.coordinate.latitude != location.coordinate.latitude &&
                lastLocation?.coordinate.longitude != location.coordinate.longitude  {
                lastLocation = location
                
                self.locations.append(location)
            }
        }
    }
    
    // MARK: MKMapViewDelegate -
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
    
    func addTestActivities() {        
        var locations: [Location] = []
        locations.append(Location.init(latitude: 0.0, longitude: 0.0))
        locations.append(Location.init(latitude: 0.1, longitude: 0.1))
        locations.append(Location.init(latitude: 0.2, longitude: 0.2))
        locations.append(Location.init(latitude: 0.3, longitude: 0.3))
        locations.append(Location.init(latitude: 0.4, longitude: 0.4))
        
        let activity = Activity(locations: locations)
        
        //        CoreDataManager.manager.addEntity(activity: activity)
        
        
        var locations1: [Location] = []
        locations1.append(Location.init(latitude: 1.0, longitude: 1.0))
        locations1.append(Location.init(latitude: 1.1, longitude: 1.1))
        locations1.append(Location.init(latitude: 1.2, longitude: 1.2))
        locations1.append(Location.init(latitude: 1.3, longitude: 1.3))
        locations1.append(Location.init(latitude: 1.4, longitude: 1.4))
        
        let activity1 = Activity(locations: locations1)
        
        //        CoreDataManager.manager.addEntity(activity: activity1)
        
        var locations2: [Location] = []
        locations2.append(Location.init(latitude: 2.0, longitude: 2.0))
        locations2.append(Location.init(latitude: 2.1, longitude: 2.1))
        locations2.append(Location.init(latitude: 2.2, longitude: 2.2))
        locations2.append(Location.init(latitude: 2.3, longitude: 2.3))
        locations2.append(Location.init(latitude: 2.4, longitude: 2.4))
        
        let activity2 = Activity(locations: locations2)
        
        //        CoreDataManager.manager.addEntity(activity: activity2)
    }
    
}

