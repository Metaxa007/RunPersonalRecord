//
//  AddRunTableViewCell.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 22.07.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

class TempAddRunTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(index: Int) {
        switch index {
        case 0:
            titleLabel.text = "Distance"
            dataLabel.text = "1000"
            iconImageView.image = UIImage(named: "Pause")
        case 1:
            titleLabel.text = "Duration"
            dataLabel.text = "00:00"
            iconImageView.image = UIImage(named: "Stop")
        case 2:
            titleLabel.text = "Date"
            dataLabel.text = "12/12/2018"
            iconImageView.image = UIImage(named: "Resume")
        default:
            break;
        }
    }

}
