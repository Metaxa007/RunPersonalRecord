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

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var paceTextView: UILabel!
    @IBOutlet weak var durationTextView: UILabel!
    @IBOutlet weak var startStopLocatingButton: UIButton!
    @IBOutlet weak var completedDistanceTextView: UILabel!
    @IBOutlet weak var distanceTextField: UITextField!
    
    var timer: Timer?
    var paceDict: Dictionary<Int, Double> = [Int : Double]() // Key is 1st, 2nd ... kilometer. Value is pace for this kilometer.
    var passedKilometers = 0 { // Used as the key for dictonary "pace"
        willSet {
            paceDict[newValue] = Double(stopWatch.getTimeInSeconds()) - durationWhenLastPaceCounted
        }
    }
    var restDistance = 0  // If user runs 1500m, than restDistance is 500m or 0.5km. For this distance is used other way to calculate pace.
    var restDistancePaceDict: Dictionary<Int, Double> = [Int : Double]() //Distance in meters, so int. Duration can be used as TimeInterval(typedef Double), so double.
    var durationWhenLastPaceCounted = 0.0 // Total duration when the last pace was saved. Needs to count pace,
                                          // i.e. duration - durationWhenLastPaceCounted = pace for the last kilometer
    var distanceToRun = 0 {
        willSet {
            distanceTextField.text = String(Int(newValue))
            // divide by 10 for tests.
            restDistance = newValue % 1000
        }
    }
    var completedDistance = 0 {
        willSet {
            completedDistanceTextView.text = String(newValue)

            // divide by 10 for tests.
            if newValue / 1000 >= passedKilometers + 1 {
                passedKilometers += 1
                paceTextView.text = Utilities.manager.getTimeInPaceFormat(duration: Double(stopWatch.getTimeInSeconds()) / Double(passedKilometers))
                durationWhenLastPaceCounted = Double(stopWatch.getTimeInSeconds())
            }
        }
    }
    var duration: NSDateInterval?
    var startDate: Date?
    var stopDate: Date?
    var lastLocation: CLLocation?
    var locations: [CLLocation] = []
    var stopWatch = StopWatch()
    var isLocatingStarted = false {
        willSet {
            if newValue == true {
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
        stopWatch.delegate = self
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
        
        stopWatch.start()
        locationManager.startUpdatingLocation()
        
        checkWhenDistanceIsCompleted()
    }
    
    func stopLocating(completed: Bool) {
        // Calculate and save pace of the restDistace and print average pace (otherwise average is already pace calculated in "completedDistance")
        if restDistance != 0 {
            restDistancePaceDict[restDistance] = Double(stopWatch.getTimeInSeconds()) - durationWhenLastPaceCounted
            
            // divide by 10 for tests.
            paceTextView.text = Utilities.manager.getTimeInPaceFormat(duration: Double(stopWatch.getTimeInSeconds()) / (Double(distanceToRun)/1000))
        }
        
        stopDate = Date()
        
        if let startDate = startDate, let stopDate = stopDate {
            duration = NSDateInterval.init(start: startDate, end: stopDate)
            
            if let duration = duration {
                let activity = Activity(locations: Utilities.manager.clLocationToLocation(clLocations: locations))
                let pace = Pace(pace: paceDict, restDistancePace: restDistancePaceDict)
                
                CoreDataManager.manager.addEntity(activity: activity, pace: pace, date: startDate, duration: duration.duration, distance: distanceToRun, completed: completed)
            }
        }
        
        stopWatch.stop()
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
        paceDict.removeAll()
        restDistancePaceDict.removeAll()

        completedDistance = 0
        durationWhenLastPaceCounted = 0
        passedKilometers = 0
        locations = []

        distanceTextField.isEnabled = true
        distanceTextField.textColor =  UIColor { textColor in
            switch textColor.userInterfaceStyle {
            case .dark:
                return UIColor.white
            default:
                return UIColor.black
            }
        }
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
            
            distanceToRun = Int(distance) ?? 0
            
            view.endEditing(true)
        }
    }
    
    @objc func cancelButtonClicked() {
        if distanceToRun == 0 {
            distanceTextField.text = ""
        } else {
            distanceTextField.text = String(distanceToRun)
        }
        
        view.endEditing(true)
    }
    
    func checkWhenDistanceIsCompleted() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            guard let weakSelf = self else { return }
            guard weakSelf.locations.count > 0 else { return }

            if Utilities.manager.getDistance(locations: weakSelf.locations) <= Double(weakSelf.distanceToRun) {
                weakSelf.completedDistance = Int(Utilities.manager.getDistance(locations: weakSelf.locations))
            } else {
                weakSelf.completedDistance = weakSelf.distanceToRun
                weakSelf.isLocatingStarted = false //stopLocating is called in didSet of isLocatingStarted
                
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
    
}

extension ViewController : CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate, StopWatchDelegate {
    
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
    
    // MARK: StopWatchDelegate -
    func stopWatch(time: String) {
        durationTextView.text = time
    }
    
}

