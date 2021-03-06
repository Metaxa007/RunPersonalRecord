//
//  RecordsViewController.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 22.08.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

private let reusableIdentifier = "recordsCell"
private let detailedRecordSegue = "detailedRecordSegue"

class RecordsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var distance = 0
    private var activities = [ActivityEntity]()
    private var completedActivites = [ActivityEntity]()
    private var uncompletedActivities = [ActivityEntity]()
    private var sortedActivites = [ActivityEntity]()
    private var selectedActivityRow = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(NSLocalizedString("records", comment: "")) \(Utilities.manager.getDistanceInKmAsString(distance: distance))"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        activities = CoreDataManager.manager.getAllEntities(for: distance) ?? []
        
        sortActivitesByTime()
    }
    
    //Completed activites should be in the beginning of the array in order to show best time for a race
    //Uncompleted are sorted aswell, but locates in the end
    private func sortActivitesByTime() {
        for i in 0..<activities.count {
            if activities[i].completed {
                completedActivites.append(activities[i])
            } else {
                uncompletedActivities.append(activities[i])
            }
        }
        
        completedActivites.sort {
            $0.duration < $1.duration
        }
        
        uncompletedActivities.sort {
            $0.duration < $1.duration
        }
        
        sortedActivites = completedActivites + uncompletedActivities
    }
    
    public func setDistance(distance: Int) {
        self.distance = distance
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailedRecordSegue {
            if let destinationVC = segue.destination as? RecordDetailedInfoViewController {
                destinationVC.setActivity(activity: sortedActivites[selectedActivityRow], place: selectedActivityRow)
            }
        }
    }
}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sortedActivites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? RecordsTableViewCell {
            cell.setupCell(activity: sortedActivites[indexPath.row], place: indexPath.row)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedActivityRow = indexPath.row
        performSegue(withIdentifier: detailedRecordSegue, sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: NSLocalizedString("delete", comment: "")) { [weak self] (action, view, completion) in
            guard let weakSelf = self else { return }
            
            CoreDataManager.manager.deleteActivity(activity: weakSelf.sortedActivites[indexPath.row])
            weakSelf.sortedActivites.remove(at: indexPath.row)
            tableView.reloadData()
            completion(true)
        }
        
        deleteAction.backgroundColor = UIColor(red: 212/256, green: 46/256, blue: 42/256, alpha: 1.0)
        
        let shareAction = UIContextualAction(style: .normal, title: NSLocalizedString("share", comment: "")) { [weak self] (action, view, completion) in
            guard let weakSelf = self else { return }
            
            let activity = weakSelf.sortedActivites[indexPath.row]
            let distance = Utilities.manager.getDistanceInKmAsString(distance: Int(activity.completedDistance))
            let time = Utilities.manager.getTimeInRegularFormat(duration: activity.duration)
            let text = String(format: NSLocalizedString("text_to_share", comment: ""), distance, time)

            let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = weakSelf.view
            
            weakSelf.present(activityVC, animated: true, completion: nil)
        }
        
        shareAction.backgroundColor = UIColor(red: 141/256, green: 206/256, blue: 212/256, alpha: 1.0)
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}
