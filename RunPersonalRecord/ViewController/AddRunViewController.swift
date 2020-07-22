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
    
    private let pickerViewDistance = UIPickerView()
    private let pickerViewDuration = UIPickerView()
    private var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        
        pickerViewDistance.delegate = self
        pickerViewDistance.dataSource = self
        
        pickerViewDuration.delegate = self
        pickerViewDuration.dataSource = self
    }
    
    func createPickerView() {
        view.addSubview(pickerViewDistance)
//        view.addSubview(toolBar)
        
        pickerViewDistance.alpha = 1
        pickerViewDistance.translatesAutoresizingMaskIntoConstraints = false
        pickerViewDistance.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pickerViewDistance.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pickerViewDistance.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
//        toolBar.translatesAutoresizingMaskIntoConstraints = false
//        toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        toolBar.bottomAnchor.constraint(equalTo: pickerView.topAnchor).isActive = true
//        toolBar.heightAnchor.constraint(equalToConstant: 45).isActive = true
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
        createPickerView()
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
