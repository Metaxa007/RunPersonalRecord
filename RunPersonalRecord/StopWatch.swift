//
//  Timer.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 18.06.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import Foundation

class StopWatch {
        
    var stopWatchdelegate: StopWatchDelegate?

    var timer = Timer()
    var (hours, minutes, seconds, fractions) = (0,0,0,0)

    func start() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(keepTimer), userInfo: nil, repeats: true)
    }
    
    @objc func keepTimer() {
        fractions += 1
        
        if fractions > 99 {
            seconds += 1
            fractions = 0
        }
        
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        
        if minutes == 60 {
            hours += 1
            minutes = 0
        }
        
        stopWatchdelegate?.getTime(time: "\(hours):\(minutes):\(seconds)")
    }
}

protocol StopWatchDelegate {
    func getTime(time: String)
}
