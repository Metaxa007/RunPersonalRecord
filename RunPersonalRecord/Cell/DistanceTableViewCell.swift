//
//  DistanceTableViewCell.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 12.11.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

class DistanceTableViewCell: UITableViewCell {
    
    private let distanceLabel = UILabel()
    private let nameLabel = UILabel()
    private let durationLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()

        setupConstraints()
    }
    
    private func setupConstraints() {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.alignment = UIStackView.Alignment.trailing
        stackView.spacing = 5
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(durationLabel)
        
        nameLabel.font = UIFont.systemFont(ofSize: 19, weight: .light)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.font = UIFont.systemFont(ofSize: 19, weight: .light)
        distanceLabel.adjustsFontSizeToFitWidth = true
        distanceLabel.minimumScaleFactor = 0.5
        nameLabel.font = UIFont.systemFont(ofSize: 19, weight: .light)
        durationLabel.adjustsFontSizeToFitWidth = true
        durationLabel.minimumScaleFactor = 0.5
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(distanceLabel)
        contentView.addSubview(stackView)
        
        distanceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        distanceLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 5).isActive = true
        
        stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
    }
    
    func setupCell(distance: Distance, name: String, duration: String) {
        switch distance{
        case .Marathon:
            distanceLabel.text = Utilities.manager.getDistanceInKmAsString(distance: distance.rawValue) + NSLocalizedString("marathon", comment: "")
        case .Halfmarathon:
            distanceLabel.text = Utilities.manager.getDistanceInKmAsString(distance: distance.rawValue) + NSLocalizedString("halfmarathon", comment: "")
        case .Mile:
            distanceLabel.text = Utilities.manager.getDistanceInKmAsString(distance: distance.rawValue) + NSLocalizedString("mile", comment: "")
        default:
            distanceLabel.text = Utilities.manager.getDistanceInKmAsString(distance: distance.rawValue)
        }
        nameLabel.text = name
        durationLabel.text = duration
    }

}
