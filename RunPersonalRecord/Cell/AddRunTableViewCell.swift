//
//  AddRunTableViewCell.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 05.08.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

class AddRunTableViewCell: UITableViewCell {

    public var picker = UIPickerView()
    private var leftLabel = UILabel()
    private var rightLabel = UILabel()
    private var separator = UIView()
    private var index = 1
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
        print("setupcell")
        index = indexPath
        picker.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        contentView.addSubview(separator)
        contentView.addSubview(picker)
        
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
        
        picker.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        picker.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        
        leftLabel.text = "leftLabel"
        rightLabel.text = "rightLabel"
    }
    
    public func selectedInTableView(_ tableView: UITableView) {
        expanded = !expanded
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension AddRunTableViewCell: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        print("numberOfComponents")
        
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("numberOfRowsInComponent")

        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "abc"
    }
}
