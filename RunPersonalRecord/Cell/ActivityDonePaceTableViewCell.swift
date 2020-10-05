//
//  ActivityDonePaceTableViewCell.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 05.10.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

class ActivityDonePaceTableViewCell: UITableViewCell {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func setCell(distance: Double, pace: TimeInterval) {
        paceLabel.text = Utilities.manager.getTimeInPaceFormat(duration: pace)
        
        //if distance is 1km, 2km etc. leave it like that. Otherwise if it is rest distance like 0.1, 0.125 etc. show only 2 digits after 0.
        distanceLabel.text = floor(distance) == distance ? String(format: "%.0f", distance) : String(format:"%.2f", distance)
    }

}
