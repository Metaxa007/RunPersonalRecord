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

    public func setCell(distance: Double, pace: TimeInterval) {
        paceLabel.text = Utilities.manager.getTimeInPaceFormat(duration: pace)
        distanceLabel.text = floor(distance) == distance ? String(format: "%.0f", distance) : String(format:"%.2f", distance)
    }

}
