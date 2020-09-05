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
    private let durationLabel = UILabel()
    private let completion = UIImageView()
    private let dateLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupConstraints()
    }
    
    private func setupConstraints() {
        let stackViewDistanceDuration = UIStackView()
        stackViewDistanceDuration.axis = NSLayoutConstraint.Axis.vertical
        stackViewDistanceDuration.distribution = UIStackView.Distribution.equalSpacing
        stackViewDistanceDuration.alignment = UIStackView.Alignment.center
        stackViewDistanceDuration.spacing = 15
        stackViewDistanceDuration.addArrangedSubview(distanceLabel)
        stackViewDistanceDuration.addArrangedSubview(durationLabel)
        
        let stackViewCompletionDate = UIStackView()
        stackViewCompletionDate.axis = NSLayoutConstraint.Axis.vertical
        stackViewCompletionDate.distribution = UIStackView.Distribution.equalSpacing
        stackViewCompletionDate.alignment = UIStackView.Alignment.center
        stackViewCompletionDate.spacing = 15
        stackViewCompletionDate.addArrangedSubview(completion)
        stackViewCompletionDate.addArrangedSubview(dateLabel)
        
        stackViewDistanceDuration.translatesAutoresizingMaskIntoConstraints = false
        stackViewCompletionDate.translatesAutoresizingMaskIntoConstraints = false
        reward.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        completion.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(reward)
        contentView.addSubview(stackViewDistanceDuration)
        contentView.addSubview(stackViewCompletionDate)
        
        reward.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        reward.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        reward.heightAnchor.constraint(equalToConstant: 35).isActive = true
        reward.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        distanceLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        durationLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        dateLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        completion.heightAnchor.constraint(equalToConstant: 30).isActive = true
        completion.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        stackViewDistanceDuration.leadingAnchor.constraint(equalTo: reward.layoutMarginsGuide.trailingAnchor, constant: 30).isActive = true
        stackViewDistanceDuration.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        stackViewCompletionDate.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        stackViewCompletionDate.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    public func setupCell(activity: ActivityEntity, place: Int) {
        switch place {
        case 0:
            reward.image = UIImage(named: "Cup_gold")
        case 1:
            reward.image = UIImage(named: "Cup_silver")
        case 2:
            reward.image = UIImage(named: "Cup_bronze")
        default:
            break;
        }
        distanceLabel.text = String(Utilities.manager.getDistanceInKmAsString(distance: Int(activity.distance)))
        durationLabel.text = String(Utilities.manager.getTimeInRegularFormat(duration: TimeInterval(activity.duration)))
        dateLabel.text = Utilities.manager.getDateAsddMMMyyyy(date: activity.date ?? Date())
        completion.image = UIImage(named: "Resume")
    }

}
