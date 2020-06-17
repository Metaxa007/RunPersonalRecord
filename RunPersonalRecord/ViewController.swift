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

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var paceTextView: UILabel!
    @IBOutlet weak var durationTextView: UILabel!
    @IBOutlet weak var startStopLocatingButton: UIButton!
    @IBOutlet weak var completedDistanceTextView: UILabel!
    @IBOutlet weak var distanceTextField: UITextField!
    
    var timer: Timer?
    var distanceToRun = 0.0 {
        willSet {
            distanceTextField.text = String(Int(newValue))
        }
    }
    var completedDistance: Double = 0.0 {
        didSet {
            if oldValue > distanceToRun {
                completedDistance = distanceToRun
            }
        }
    }
    var duration: NSDateInterval?
    var startDate: Date?
    var stopDate: Date?
    var lastLocation: CLLocation?
    var locations: [CLLocation] = []
    var isLocatingStarted = false {
        didSet {
            if isLocatingStarted == true {
                startStopLocatingButton.setTitle("Stop", for: .normal)
                startLocating()
            } else {
                startStopLocatingButton.setTitle("Start", for: .normal)
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
        
        distanceTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer?.invalidate()
    }
    
    @IBAction func startStopLocating(_ sender: UIButton) {
        if distanceTextFieldIsEmtpy() { return }

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
        completedDistanceTextView.text = "0"
        distanceTextField.textColor =  UIColor { textColor in
            switch textColor.userInterfaceStyle {
            case .dark:
                return UIColor.white
            default:
                return UIColor.black
            }
        }
        
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
            
            distanceToRun = Double(distance) ?? 0
            
            view.endEditing(true)
        }
    }
    
    @objc func cancelButtonClicked() {
        if distanceToRun == 0 {
            distanceTextField.text = ""
        } else {
            distanceTextField.text = String(Int(distanceToRun))
        }
        
        view.endEditing(true)
    }
    
    func checkWhenDistanceIsCompleted() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            guard let weakSelf = self else { return }
            guard weakSelf.locations.count > 0 else { return }

            weakSelf.completedDistance = Utilities.manager.getDistance(locations: weakSelf.locations)
            weakSelf.completedDistanceTextView.text = String(Int(weakSelf.completedDistance))
            
            if Utilities.manager.getDistance(locations: weakSelf.locations) >= weakSelf.distanceToRun {
                weakSelf.isLocatingStarted = false
                weakSelf.stopLocating(completed: true)
                
                timer.invalidate()
            }
        })
    }
    
    func distanceTextFieldIsEmtpy () -> Bool {
        guard let distance = distanceTextField.text else { return true }
        
        return distance.isEmpty
    }
    
    func roundCorners() {
        startStopLocatingButton.layer.cornerRadius = 20
        startStopLocatingButton.clipsToBounds = true
    }
    
    func addPolylineToMap(locations: [CLLocation]) {
        let coordinates = locations.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        let region = MKCoordinateRegion(center: coordinates[0], span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        mapView.addOverlay(polyline)
    }
    
    //MARK:UITextFieldDelegate
    //range {1,0} 1 - starting location, 0 - length to replace. Replacement string normally just 1 character that user typed.
    //User type 5. Range {0,0}. Current text "". First 0 is the starting location, because the current string is empty.
    //Second 0 is length of the current string to replace. We do not need to replace something, so we just add replacementString
    //to currentString. When we delete element in 12345 the range is {4,1} 4 - starting location in this case the number 5. 1 is length.
    //So we replace only number 5 with "" and the updateText is 1234.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""

        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updateText = currentText.replacingCharacters(in: stringRange, with: string)

        //First number can not start with 0.
        if updateText == "0" {
            return false
        }
        
        return updateText.count < 6
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

