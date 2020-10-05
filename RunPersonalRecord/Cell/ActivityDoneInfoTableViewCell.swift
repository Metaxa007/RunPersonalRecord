//
//  ActivityDoneInfoTableViewCell.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 04.10.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

class ActivityDoneInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoDetailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setupCell(activity: ActivityEntity, index: Int) {
        switch index {
        case 0:
            iconImageView.image = UIImage(named: "Resume")
            infoLabel.text = "Completed Distance"
            print("Tag1 \(activity.completedDistance)")
            infoDetailsLabel.text = "\(activity.completedDistance)m"
        case 1:
            iconImageView.image = UIImage(named: "Pause")
            infoLabel.text = "Duration"
            infoDetailsLabel.text = "\(Utilities.manager.getTimeInRegularFormat(duration: activity.duration))"
        case 2:
            iconImageView.image = UIImage(named: "Stop")
            infoLabel.text = "Avg. Pace"
            infoDetailsLabel.text = "\(Utilities.manager.getTimeInPaceFormat(duration: activity.duration / (Double(activity.completedDistance) / 1000)))"
        case 3:
            iconImageView.image = UIImage(named: "Stop")
            infoLabel.text = "Avg. Speed"
            infoDetailsLabel.text = "\(String(format: "%.1f", Double(activity.completedDistance) / activity.duration * 3.6)) km/h"
        default:
            return
        }
    }
    
}
