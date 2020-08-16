//
//  AddRunViewController.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 05.08.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

class AddRunViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedRowIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

extension AddRunViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addRunCell") as! AddRunTableViewCell
        
        cell.setupCell(indexPath: indexPath.row)
        
        if indexPath.row == 0 {
            cell.leftLabel.text = "Distance"
            cell.updateDistanceLabel()
            cell.icon.image = UIImage(named: "Stop")!
        } else if indexPath.row == 1 {
            cell.leftLabel.text = "Duration"
            cell.updateTimeLabel()
            cell.icon.image = UIImage(named: "Pause")!
        } else if indexPath.row == 2 {
            cell.leftLabel.text = "Date"
            cell.updateDateLabel()
            cell.icon.image = UIImage(named: "Resume")!
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedRowIndex {
            if indexPath.row == 2 {
                // new DatePicker introduced in iOS 14. If indexPath == 2 and iOS < 14 return 260
                if #available(iOS 14.0, *) {
                    return 370
                }
            }
            
            return 260 //Expanded
        }
        
        return 44 //Not expanded
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if selectedRowIndex == indexPath.row {
            selectedRowIndex = -1
        } else {
            selectedRowIndex = indexPath.row
        }
        tableView.reloadData()
    }
}
