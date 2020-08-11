//
//  AddRunTableViewCell.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 05.08.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

class AddRunTableViewCell: UITableViewCell {
    
    // icon, leftLabel, rightLabel are set from AddRunViewController.swift
    public var icon = UIImageView()
    public var leftLabel = UILabel()
    public var rightLabel = UILabel()
    private let picker = UIPickerView()
    private let datePicker = UIDatePicker()
    private var separator = UIView()
    private var index = -1
    private var expanded = false
    private var unexpandedHeight: CGFloat = 44.0
    public var height: CGFloat {
        let expandedHeight = unexpandedHeight + picker.bounds.height
        
        return expanded ? expandedHeight : unexpandedHeight
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("awakeFromNib")
        
        picker.dataSource = self
        picker.delegate = self
    }
    
    public func setupCell(indexPath: Int) {
        index = indexPath
        
        if indexPath == 2 {
            setupCellWithDatePicker()
        } else {
            setupCellWithPickerView()
        }
    }
    
    private func setupCellWithPickerView() {
        print("setupcell")
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
        icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
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
    
    private func setupCellWithDatePicker() {
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
        }
        datePicker.maximumDate = Date()
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        contentView.addSubview(separator)
        contentView.addSubview(datePicker)
        
        leftLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
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
        
        datePicker.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
    }
    
    public func selectedInTableView(_ tableView: UITableView) {
        expanded = !expanded
        
        tableView.beginUpdates()
        tableView.endUpdates()
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
}
