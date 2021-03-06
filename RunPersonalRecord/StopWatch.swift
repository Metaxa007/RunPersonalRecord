//
//  Timer.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 18.06.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import Foundation

class StopWatch {
    
    // Private variables
    fileprivate var startTime = TimeInterval()
    fileprivate var pauseTime = TimeInterval()
    fileprivate var wasPause = false
    fileprivate var timer = Timer()
    
    var delegate: StopWatchDelegate?
    
    var strHours = "00"
    var strMinutes = "00"
    var strSeconds = "00"
    
    var timeText = ""
    
    var numHours = 0
    var numMinutes = 0
    var numSeconds = 0
    
    /**
     Updates the time and saves the values as strings
     */
    @objc fileprivate func updateTime() {
        // Save the current time
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        // Find the difference between current time and start time to get the time elapsed
        let elapsedTime: TimeInterval = currentTime - startTime
        
        (numHours, numMinutes, numSeconds) = Utilities.manager.getTime(duration: elapsedTime)
        
        // Save the values into strings with the 00 format
        strHours = String(format: "%02d", numHours)
        strMinutes = String(format: "%02d", numMinutes)
        strSeconds = String(format: "%02d", numSeconds)
        
        timeText = "\(strHours):\(strMinutes):\(strSeconds)"
        
        delegate?.stopWatch(time: timeText)
    }
    
    fileprivate func resetTimer() {
        startTime = Date.timeIntervalSinceReferenceDate
        strHours = "00"
        strMinutes = "00"
        strSeconds = "00"
        
        timeText = "\(strHours):\(strMinutes):\(strSeconds)"
        
        delegate?.stopWatch(time: timeText)
    }
    
    // MARK: Public functions
    /**
     Starts the stopwatch, or resumes it if it was paused
     */
    func start() {
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            
            if wasPause {
                startTime = Date.timeIntervalSinceReferenceDate - startTime
            } else {
                startTime = Date.timeIntervalSinceReferenceDate
            }
        }
    }
    
    /**
     Pause the stopwatch so that it can be resumed later
     */
    func pause() {
        wasPause = true
        
        timer.invalidate()
        pauseTime = Date.timeIntervalSinceReferenceDate
        startTime = pauseTime - startTime
    }
    
    /**
     Stops the stopwatch and erases the current time
     */
    func stop() {
        wasPause = false
        
        timer.invalidate()
        resetTimer()
    }
    
    // MARK: Value functions
    
    func getTimeInHours() -> Int {
        return numHours
    }
    
    func getTimeInMinutes() -> Int {
        return numHours * 60 + numMinutes
    }
    
    func getTimeInSeconds() -> Int {
        return numHours * 3600 + numMinutes * 60 + numSeconds
    }
    
}

protocol StopWatchDelegate {
    func stopWatch(time: String)
}
