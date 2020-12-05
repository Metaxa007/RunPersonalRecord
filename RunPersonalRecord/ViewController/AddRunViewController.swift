//
//  AddRunViewController.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 05.08.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

protocol AddRunViewControllerDelegate {
    func addRunViewControllerDismiss()
}

private let reuseIdentifier = "addRunCell"

class AddRunViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    private var selectedRowIndex = -1
    private var duration = 0.0
    private var distance = 0
    private var date = Date()
    public var delegate: AddRunViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("add_run", comment: "")
        saveButton.setTitle(NSLocalizedString("save", comment: ""), for: .normal) 
        
        roundCornersSaveButton()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    private func roundCornersSaveButton() {
        saveButton.layer.cornerRadius = 20
        saveButton.clipsToBounds = true
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        if duration == 0 {
            let alert = UIAlertController(title: nil, message: NSLocalizedString("enter_duration", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // No locations and pace information for this activity, distanceToRun == completedDistance
        CoreDataManager.manager.addEntity(locations: Activity.init(locations: [[]]), pace: Pace.init(pace: [:], restDistancePace: [:]),
                                          date: date, duration: duration, distanceToRun: distance, completedDistance: distance, completed: true)
        
        dismiss(animated: true, completion: nil)
        delegate?.addRunViewControllerDismiss()
    }
}

extension AddRunViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? AddRunTableViewCell {
            cell.delegate = self
            cell.setupCell(indexPath: indexPath.row)
            
            if indexPath.row == 0 {
                cell.leftLabel.text = NSLocalizedString("distance", comment: "")
                cell.updateDistanceLabel()
                
                if traitCollection.userInterfaceStyle == .light {
                    cell.icon.image = UIImage(named: "Distance")!
                } else {
                    cell.icon.image = UIImage(named: "Distance_dark")!
                }
            } else if indexPath.row == 1 {
                cell.leftLabel.text = NSLocalizedString("duration", comment: "")
                cell.updateTimeLabel()
                
                if traitCollection.userInterfaceStyle == .light {
                    cell.icon.image = UIImage(named: "Duration")!
                } else {
                    cell.icon.image = UIImage(named: "Duration_dark")!
                }
            } else if indexPath.row == 2 {
                cell.leftLabel.text = NSLocalizedString("date", comment: "")
                cell.updateDateLabel()
                
                if traitCollection.userInterfaceStyle == .light {
                    cell.icon.image = UIImage(named: "Date")!
                } else {
                    cell.icon.image = UIImage(named: "Date_dark")!
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedRowIndex {
            if indexPath.row == 2 {
                // new DatePicker introduced in iOS 14. If indexPath == 2 and iOS < 14 return 260
                if #available(iOS 14.0, *) {
                    return 380
                }
            }
            
            return 260 //Expanded
        }
        
        return 55 //Not expanded
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

extension AddRunViewController:AddRunTableViewCellDelegate {
    func addRunTableViewCell(duration: Double) {
        self.duration = duration
    }
    
    func addRunTableViewCell(distance: Int) {
        self.distance = distance
    }
    
    func addRunTableViewCell(date: Date) {
        self.date = date
    }
}
