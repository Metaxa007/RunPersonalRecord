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
    @IBOutlet weak var saveButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var saveButtonBottom: NSLayoutConstraint!
    
    private let pickerView = UIPickerView()
    private let datePicker = UIDatePicker()
    private let toolBar = UIToolbar()
    private var shownPicker: UIView?
    private var selectedRow: Int?
    private var pickerToolbarShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        roundCornersSaveButton()
    }
    
    func showPickerView() {
        view.addSubview(pickerView)
        view.addSubview(toolBar)

        setupPicker(picker: pickerView)
    }
    
    func showDatePicker(){
        view.addSubview(datePicker)
        view.addSubview(toolBar)
        
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        setupPicker(picker: datePicker)
    }
    
    func setupPicker(picker: UIView) {
        picker.alpha = 1
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        pickerView.reloadAllComponents()
    }

    func showToolBar(labelText: String, picker: UIView) {
        let label = UILabel()
        label.text = labelText
    
        let labelButton = UIBarButtonItem(customView: label)
        let doneButton = UIBarButtonItem(title:"Add", style: .plain, target: self, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissPickerAndToolBar))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.alpha = 1
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolBar.bottomAnchor.constraint(equalTo: picker.topAnchor).isActive = true
        toolBar.heightAnchor.constraint(equalToConstant: 45).isActive = true
        toolBar.sizeToFit()
        toolBar.setItems([cancelButton, flexibleSpace, labelButton, flexibleSpace, doneButton], animated: false)
    }
    
    func showSaveButton() {
        saveButtonHeight.constant = 53
        saveButtonBottom.constant = 10
        saveButton.isHidden = false
    }
    
    func hideSaveButton() {
        saveButtonHeight.constant = 0
        saveButtonBottom.constant = 0
        saveButton.isHidden = true
    }
    
    func roundCornersSaveButton() {
        saveButton.layer.cornerRadius = 25
        saveButton.clipsToBounds = true
    }

    @objc func dismissPickerAndToolBar() {
        guard let shownPicker = self.shownPicker else { return }

        shownPicker.alpha = 0
        toolBar.alpha = 0

        shownPicker.removeFromSuperview()
        toolBar.removeFromSuperview()
        showSaveButton()
        
        pickerToolbarShown = false
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
        
        if pickerToolbarShown {
            dismissPickerAndToolBar()
        }
        
        selectedRow = indexPath.row

        switch indexPath.row {
        case 0:
            showPickerView()
            showToolBar(labelText: "Choose distance (km)", picker: pickerView)
            shownPicker = pickerView
        case 1:
            showPickerView()
            showToolBar(labelText: "Duration", picker: pickerView)
            shownPicker = pickerView
        case 2:
            showDatePicker()
            showToolBar(labelText: "Pick date", picker: datePicker)
            shownPicker = datePicker
        default:
            return
        }
        
        hideSaveButton()
        pickerToolbarShown = true
    }
}

extension AddRunViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let selectedRow = selectedRow else { return 0 }
        
        if selectedRow == 0 {
            return 4
        } else if selectedRow == 1  {
            return 3
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
        switch selectedRow {
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
