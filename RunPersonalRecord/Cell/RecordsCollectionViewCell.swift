//
//  RecordsCollectionViewCell.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 11.07.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

class RecordsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var distanceTextView: UILabel!
    
    let formatter = NumberFormatter()
    
    func setupCell(distance: Int32) {
        self.distanceTextView.text = Utilities.manager.distanceAsString(distance: Int(distance))
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
    }
    
}
