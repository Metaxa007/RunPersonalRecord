//
//  PaceTableViewCell.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 06.09.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

class PaceTableViewCell: UITableViewCell {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func setCell(distance: Int, pace: TimeInterval) {
//        distanceLabel.text = Utilities.manager.getDistanceInKmAsString(distance: distance)
//        paceLabel.text = Utilities.manager.getTimeInPaceFormat(duration: pace)
        print("setcell")
        distanceLabel.text = "1"
        paceLabel.text = "5:41"
    }

}
