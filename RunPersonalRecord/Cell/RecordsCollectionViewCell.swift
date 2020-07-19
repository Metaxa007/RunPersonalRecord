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
        let formatter = NumberFormatter()
        
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        if distance >= 1000 {
            self.distanceTextView.text = "\(formatter.string(from: NSNumber(value: Double(distance) / 1000)) ?? "") km"
        } else {
            self.distanceTextView.text = "\(distance) m"
        }
        
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
    }
    
}
