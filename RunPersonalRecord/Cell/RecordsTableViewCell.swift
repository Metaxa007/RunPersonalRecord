//
//  RecordsTableViewCell.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 24.08.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

class RecordsTableViewCell: UITableViewCell {

    private let reward = UIImageView()
    private let distanceLabel = UILabel()
    private let duration = UILabel()
    private let completion = UIImageView()
    private let dateLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        reward.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        duration.translatesAutoresizingMaskIntoConstraints = false
        completion.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(reward)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(duration)
        contentView.addSubview(completion)
        contentView.addSubview(dateLabel)
        
        reward.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        reward.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        reward.heightAnchor.constraint(equalToConstant: 30).isActive = true
        reward.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        distanceLabel.leadingAnchor.constraint(equalTo: reward.layoutMarginsGuide.leadingAnchor, constant: 40).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        duration.leadingAnchor.constraint(equalTo: distanceLabel.layoutMarginsGuide.leadingAnchor, constant: 50).isActive = true
        duration.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        duration.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        dateLabel.leadingAnchor.constraint(equalTo: duration.layoutMarginsGuide.leadingAnchor, constant: 40).isActive = true
        dateLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        completion.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        completion.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        completion.heightAnchor.constraint(equalToConstant: 30).isActive = true
        completion.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    public func setupCell(activity: ActivityEntity) {
        print("setupCell")
        reward.image = UIImage(named: "Pause")
        distanceLabel.text = String(activity.distance)
        duration.text = String(activity.duration)
        dateLabel.text = "19/10/1994"
        completion.image = UIImage(named: "Resume")
    }

}
