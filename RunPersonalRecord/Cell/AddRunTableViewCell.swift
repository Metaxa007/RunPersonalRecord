//
//  AddRunTableViewCell.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 05.08.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

protocol AddRunTableViewCellDelegate {
    func addRunTableViewCell(duration: Double)
    func addRunTableViewCell(distance: Int)
    func addRunTableViewCell(date: Date)
}

class AddRunTableViewCell: UITableViewCell {
    
    // icon, leftLabel, rightLabel are set from AddRunViewController.swift
    public var icon = UIImageView()
    public var leftLabel = UILabel()
    public var rightLabel = UILabel()
    private let picker = UIPickerView()
    private let datePicker = UIDatePicker()
    private var separator = UIView()
    //Index represents a tableView row, that is selected
    private var index = -1
    private var expanded = false
    private var unexpandedHeight: CGFloat = 44.0
    public var height: CGFloat {
        let expandedHeight = unexpandedHeight + picker.bounds.height
        
        return expanded ? expandedHeight : unexpandedHeight
    }
    private var km = 0
    private var tenths = 0
    private var hundredths = 0
    private var hours = 0
    private var minutes = 0
    private var seconds = 0
    private var selectedDate = Date()
    public var delegate: AddRunTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code        
        picker.dataSource = self
        picker.delegate = self
    }
    
    public func setupCell(indexPath: Int) {
        index = indexPath
        
        if indexPath == 2 {
            setupDatePicker()
            setupCellWith(picker: datePicker)
        } else {
            setupCellWith(picker: picker)
        }
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(AddRunTableViewCell.datePickerValueChanged), for: .valueChanged)
        
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc private func datePickerValueChanged(sender: UIDatePicker) {
        selectedDate = sender.date

        delegate?.addRunTableViewCell(date: selectedDate)
        updateDateLabel()
    }
    
    private func setupCellWith(picker: UIView) {
        picker.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        contentView.addSubview(separator)
        contentView.addSubview(picker)
        contentView.addSubview(icon)
        
        icon.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        // if center icon in cell, then while expanding the icon moves
        icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 30.0).isActive = true

        leftLabel.leadingAnchor.constraint(equalTo: icon.layoutMarginsGuide.trailingAnchor, constant: 20).isActive = true
        leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        leftLabel.heightAnchor.constraint(equalToConstant: unexpandedHeight).isActive = true
        
        rightLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        rightLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        rightLabel.heightAnchor.constraint(equalToConstant: unexpandedHeight).isActive = true
        
        separator.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        separator.topAnchor.constraint(equalTo: leftLabel.bottomAnchor).isActive = true
        separator.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        picker.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        picker.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
    }
    
    public func selectedInTableView(_ tableView: UITableView) {
        expanded = !expanded
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    public func updateDistanceLabel() {
        rightLabel.text = String(format: "%d.%d%d km", arguments: [km, tenths, hundredths])
    }
    
    public func updateTimeLabel() {
        rightLabel.text = String(format: "%02d:%02d:%02d", arguments: [hours, minutes, seconds])
    }
    
    public func updateDateLabel() {
        rightLabel.text = Utilities.manager.getDateAsddMMMyyyy(date: selectedDate)
    }
    
    private func calculateDistance() -> Int {
        return km * 1000 + tenths * 100 + hundredths * 10
    }
    
    private func calculateDuration() -> Double {
        return Double(hours * 3600 + minutes * 60 + seconds)
    }
}

extension AddRunTableViewCell: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if index == 0 {
            return 4
        } else if index == 1 {
            return 3
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch index {
        case 0:
            if component == 0 {
                return 300
            } else if component == 1 {
                return 1
            } else {
                return 10
            }
        case 1:
            if component == 0 {
                return 100
            } else if component == 3 {
                return 1
            } else {
                return 60
            }
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch index {
        case 0:
            if component == 0 {
                return "\(row)"
            } else if component == 1 {
                return "."
            } else {
                return "\(row)"
            }
        case 1:
            if component == 0 {
                return "\(row)h"
            } else if component == 1 {
                return "\(row)m"
            } else {
                return "\(row)s"
            }
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch index {
        case 0:
            if component == 1 {
                return 13
            } else {
                return 70
            }
        case 1:
            return 100
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch index {
        case 0:
            // Component 1 is a dot
            if component == 0 {
                km = row
            } else if component == 2 {
                tenths = row
            } else if component == 3 {
                hundredths = row
            }
            
            let distance = calculateDistance()
            
            delegate?.addRunTableViewCell(distance: distance)
            updateDistanceLabel()
        case 1:
            if component == 0 {
                hours = row
            } else if component == 1 {
                minutes = row
            } else if component == 2 {
                seconds = row
            }
            
            let duration = calculateDuration()
            
            delegate?.addRunTableViewCell(duration: duration)
            updateTimeLabel()
        default:
            return
        }
    }
}
