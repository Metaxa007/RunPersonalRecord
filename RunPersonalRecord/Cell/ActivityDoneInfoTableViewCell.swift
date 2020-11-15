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
            infoLabel.text = NSLocalizedString("distance_completed", comment: "")
            infoDetailsLabel.text = Utilities.manager.getDistanceInKmAsString(distance: Int((activity.completedDistance)))
        case 1:
            iconImageView.image = UIImage(named: "Pause")
            infoLabel.text = NSLocalizedString("duration", comment: "")
            infoDetailsLabel.text = Utilities.manager.getTimeInRegularFormat(duration: activity.duration)
        case 2:
            iconImageView.image = UIImage(named: "Stop")
            infoLabel.text = NSLocalizedString("avg_pace", comment: "")
            infoDetailsLabel.text = Utilities.manager.getTimeInPaceFormat(duration: activity.duration / (Double(activity.completedDistance) / 1000))
        case 3:
            iconImageView.image = UIImage(named: "Stop")
            infoLabel.text = NSLocalizedString("avg_speed", comment: "")
            infoDetailsLabel.text = "\(String(format: "%.1f", Double(activity.completedDistance) / activity.duration * 3.6)) \(NSLocalizedString("km_h", comment: ""))"
        default:
            return
        }
    }
    
}
