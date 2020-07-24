//
//  AddRunViewController.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 21.07.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

private let reuseIdentifier = "addRunCell"

class AddRunViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    private let pickerView = UIPickerView()
    private let datePicker = UIDatePicker()
    private let toolBar = UIToolbar()
    private var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func showPickerView() {
        view.addSubview(pickerView)
        view.addSubview(toolBar)

        setupPicker(picker: pickerView)
        setToolBarConstraints(picker: pickerView)
    }
    
    func showDatePicker(){
        view.addSubview(datePicker)
        view.addSubview(toolBar)
        
        datePicker.datePickerMode = .date
        
        setupPicker(picker: datePicker)
        setToolBarConstraints(picker: datePicker)
    }
    
    func setupPicker(picker: UIView) {
        picker.alpha = 1
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func setToolBarConstraints(picker: UIView) {
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolBar.bottomAnchor.constraint(equalTo: picker.topAnchor).isActive = true
        toolBar.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }

    func showToolBar() {
        let label = UILabel()
        label.text = "Choose distance (km)"
    
        let labelButton = UIBarButtonItem(customView: label)
        let doneButton = UIBarButtonItem(title:"Add", style: .plain, target: self, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.alpha = 1
        toolBar.sizeToFit()
        toolBar.setItems([cancelButton, flexibleSpace, labelButton, flexibleSpace, doneButton], animated: false)
    }
}

extension AddRunViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? AddRunTableViewCell {
            cell.setupCell(index: indexPath.row)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedRow = indexPath.row

        if indexPath.row == 0 || indexPath.row == 1 {
            showToolBar()
            showPickerView()
        } else if indexPath.row == 2 {
            showToolBar()
            showDatePicker()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        }
    }
}

extension AddRunViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let selectedRow = selectedRow else { return 0 }
        
        if selectedRow == 0 || selectedRow == 1  {

            return 4
        }
        
        return 0
    }
    
    /**
     row 1 - Distance
     row 2 - Duration
     row 3 - Date
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let selectedRow = selectedRow else { return 0 }

        switch selectedRow {
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
    
    /**
     row 1 - Distance
     row 2 - Duration
     row 3 - Date
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let selectedRow = selectedRow else { return "" }

        switch selectedRow {
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
                return "\(row)"
            } else if component == 3 {
                return "hh/mm/ss"
            } else {
                return "\(row)"
            }
        default:
            return ""
        }
    }
}
