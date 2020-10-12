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
import AVFoundation

private let activityDoneSegue = "activityDoneSegue"

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var paceTextView: UILabel!
    @IBOutlet weak var durationTextView: UILabel!
    @IBOutlet weak var completedDistanceTextView: UILabel!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var startButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var startButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var pauseStopStackHeight: NSLayoutConstraint!
    @IBOutlet weak var pauseStopStackBottom: NSLayoutConstraint!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseResumeButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseStopStack: UIStackView!
    
    var pauseImage: UIImage {
        get {
            return UIImage(named: "Pause")! //Crash if image does not exist
        }
    }
    var resumeImage: UIImage {
        get {
            return UIImage(named: "Resume")! //Crash if image does not exist
        }
    }
    var timer: Timer?
    var paceDict: Dictionary<Int, Double> = [Int : Double]() // Key is 1st, 2nd ... kilometer. Value is pace for this kilometer.
    var passedKilometers = 0 { // Used as the key for dictonary "pace"
        willSet {
            // Do not add 0km. It happens when passedKilometers is set to 0 in stopLocating.
            if newValue > 0 {
                let pace = Double(stopWatch.getTimeInSeconds()) - durationWhenLastPaceCounted
                paceDict[newValue] = pace
                
                let time = Utilities.manager.getTime(duration: pace)
                let averagePaceTime = Utilities.manager.getTime(duration: Double(stopWatch.getTimeInSeconds()) / (Double(completedDistance)/1000))
                
                textToSpeech(utterance: "Pace for \(newValue == 1 ? "kilometer" : "kilometers") \(newValue) is \(time.0 > 0 ? "\(time.0) hours)" : "") \(time.1) minutes and \(time.2) seconds. Average pace is  \(averagePaceTime.1) minutes \(averagePaceTime.2) seconds." )
            }
        }
    }
    var restDistance = 0  // If user runs 1500m, than restDistance is 500m or 0.5km. For this distance is used other way to calculate pace.
                          // We need 2 different dictionaries, because collision may occur, if user wants to run for example 10010m.
                          // Pace 10km is 10 key in dictionary and 10m is 10 key as well.
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
    var locationsAll: [[CLLocation]] = [] //Array contains arrays of Locations. Every array of Locations are locations between start and pause. In this case the last position
                                          //before pause and the first position after continue won't be connected. Otherwise the distance between these 2 points will be added
                                          //to the total distance.
    var locationsInSection: [CLLocation] = [] //Array of locations that is added to locationsAll after user clicks pause. Than should be erased.
    var stopWatch = StopWatch()
    var isActivityStarted = false {
        willSet {
            if newValue {
                startLocating()
                showPauseStopStack()
                hideStartButton()
            } else {
                stopLocating(completed: completedDistance == distanceToRun)
                showStartButton()
                hidePauseStopStack()
            }
        }
    }
    var isPaused = false {
        willSet {
            if newValue {
                pauseResumeButton.setImage(resumeImage, for: .normal)
            } else {
                pauseResumeButton.setImage(pauseImage, for: .normal)
            }
        }
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do they need to be registred?
        // ActivityTransformer.register()
        // PaceTransformer.register()
        setUpMapView()
        roundCornersStartButton()
        addToolBarToKeyBoard()
        
        hidePauseStopStack()
        
        distanceTextField.delegate = self
        stopWatch.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer?.invalidate()
    }
    
    @IBAction func startStopLocating(_ sender: UIButton) {
        if distanceTextFieldIsEmtpy() { return }

        isActivityStarted = true
    }
    
    @IBAction func pauseActivity(_ sender: UIButton) {
        isPaused = !isPaused
        
        // Stop, start stopwatch only if user really pressed the button. Not when isPaused was set somewhere in the code i.e. stopLocating
        if isPaused {
            if !locationsInSection.isEmpty {
                locationsAll.append(locationsInSection)
                locationsInSection = []
            }
            
            stopWatch.pause()
            locationManager.stopUpdatingLocation()
        } else {
            stopWatch.start()
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func stopActivity(_ sender: UIButton) {
        isActivityStarted = false
    }
    
    private func hidePauseStopStack() {
        pauseStopStackHeight.constant = 0
        pauseStopStackBottom.constant = 0
        pauseStopStack.isHidden = true
    }
    
    private func hideStartButton() {
        startButtonBottom.constant = 0
        startButtonHeight.constant = 0
        startButton.isHidden = true
    }
    
    private func showPauseStopStack() {
        pauseStopStackBottom.constant = 38
        pauseStopStackHeight.constant = 85
        pauseStopStack.isHidden = false
    }
    
    private func showStartButton() {
        startButtonBottom.constant = 26
        startButtonHeight.constant = 53
        startButton.isHidden = false
    }
    
    private func setUpMapView() {
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    private func startLocating() {
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
    
    private func stopLocating(completed: Bool) {
        // Save activity only if user did some progress in it
        if completedDistance != 0 {
            // Calculate and save pace of the restDistace and print average pace (otherwise average is already pace calculated in "completedDistance")
            if completedDistance % 1000 != 0 {
                restDistancePaceDict[completedDistance % 1000] = Double(stopWatch.getTimeInSeconds()) - durationWhenLastPaceCounted

                // divide by 10 for tests.
                paceTextView.text = Utilities.manager.getTimeInPaceFormat(duration: Double(stopWatch.getTimeInSeconds()) / (Double(completedDistance)/1000)) //completed distance in case user did not finish. If finished completedDistance == distanceToRun
            }
            
            stopDate = Date()
            
            if let startDate = startDate, let stopDate = stopDate {
                duration = NSDateInterval.init(start: startDate, end: stopDate)
                
                if let duration = duration {
                    if !locationsInSection.isEmpty {
                        locationsAll.append(locationsInSection)
                    }
                    
                    let locations = Activity(locations: locationsAll)
                    let pace = Pace(pace: paceDict, restDistancePace: restDistancePaceDict)
                                        
                    CoreDataManager.manager.addEntity(locations: locations, pace: pace, date: startDate, duration: duration.duration, distanceToRun:
                                                        distanceToRun, completedDistance: completedDistance, completed: completed)
                }
            }
    
            performSegue(withIdentifier: activityDoneSegue, sender: self)
        } else {
            let alert = UIAlertController(title: "Completed distance is 0. Activity will not be saved.", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        stopWatch.stop()
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
        paceDict.removeAll()
        restDistancePaceDict.removeAll()

        completedDistance = 0
        durationWhenLastPaceCounted = 0
        passedKilometers = 0
        locationsAll = []
        locationsInSection = []
        isPaused = false

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
    
    private func textToSpeech(utterance: String) {
        do {
           try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: AVAudioSession.CategoryOptions.duckOthers)
           try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        let utterance = AVSpeechUtterance(string: utterance)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
 
    private func addToolBarToKeyBoard() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
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
    
    private func checkWhenDistanceIsCompleted() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            guard let weakSelf = self else { return }
            guard weakSelf.locationsInSection.count > 0 else { return }

            var completedDistance = 0.0

            if !weakSelf.locationsAll.isEmpty {
                for locationsInSection in weakSelf.locationsAll {
                    guard locationsInSection.count > 0 else { break }
                    
                    completedDistance += Utilities.manager.getDistance(locations: locationsInSection)
                }
            }
            
            completedDistance += Utilities.manager.getDistance(locations: weakSelf.locationsInSection)
            
            if completedDistance <= Double(weakSelf.distanceToRun) {
                weakSelf.completedDistance = Int(completedDistance)
            } else {
                weakSelf.completedDistance = weakSelf.distanceToRun
                weakSelf.isActivityStarted = false //stopLocating is called in willSet of isActivityStarted
                
                timer.invalidate()
            }
        })
    }
    
    private func distanceTextFieldIsEmtpy () -> Bool {
        guard let distance = distanceTextField.text else { return true }
        
        return distance.isEmpty
    }
    
    private func roundCornersStartButton() {
        startButton.layer.cornerRadius = 20
        startButton.clipsToBounds = true
    }
    
    private func addPolylineToMap() {
        var locations:[CLLocation] = []
        
        // If locationsAll is not empty -> append to locations to render. And for each case add locationsInSection to locations
        if !locationsAll.isEmpty {
            for locationsInSection in locationsAll {
                locations.append(contentsOf: locationsInSection)
            }
        }
        
        locations.append(contentsOf: locationsInSection)
        
        let coordinates = locations.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        
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

                locationsInSection.append(location)
                
                addPolylineToMap()
            }
        }
    }
    
    // MARK: MKMapViewDelegate -
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .green
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        mapView.setRegion(region, animated: true)
    }

    
    // MARK: StopWatchDelegate -
    func stopWatch(time: String) {
        durationTextView.text = time
    }
    
}

