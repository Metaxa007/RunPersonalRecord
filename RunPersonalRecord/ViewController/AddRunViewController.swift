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
    private let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
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
    
    func createPickerView() {
        createToolBar()

        view.addSubview(pickerView)
        view.addSubview(toolBar)
        
        pickerView.alpha = 1
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolBar.bottomAnchor.constraint(equalTo: pickerView.topAnchor).isActive = true
        toolBar.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func showDatePicker(){
        createToolBar()
        
        view.addSubview(datePicker)
        view.addSubview(toolBar)
        
        datePicker.datePickerMode = .date
        datePicker.alpha = 1
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolBar.bottomAnchor.constraint(equalTo: datePicker.topAnchor).isActive = true
    }

    func createToolBar() {
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
        
        if indexPath.row == 0 || indexPath.row == 1 {
            selectedRow = indexPath.row
            createPickerView()
        } else if indexPath.row == 2 {
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
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let selectedRow = selectedRow else { return 0 }

        if selectedRow == 0 {
            if component == 0 {
                return 300
            } else if component == 1 {
                return 1
            } else {
                return 10
            }
        } else if selectedRow == 1 {
            if component == 0 {
                return 100
            } else if component == 3 {
                return 1
            } else {
                return 60
            }
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectedRow == 0 {
            if component == 0 {
                return "\(row)"
            } else if component == 1 {
                return "."
            } else {
                return "\(row)"
            }
        } else if selectedRow == 1 {
            if component == 0 {
                return "\(row)"
            } else if component == 3 {
                return "hh/mm/ss"
            } else {
                return "\(row)"
            }
        }

        return ""
    }
}
