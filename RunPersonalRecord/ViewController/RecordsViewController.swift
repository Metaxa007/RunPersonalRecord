//
//  RecordsViewController.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 22.08.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

private let reusableIdentifier = "recordsCell"

class RecordsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var distance = 0
    private var activities = [ActivityEntity]()
    private var uncompletedActivities = [ActivityEntity]()
    private var sortedActivites = [ActivityEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Records \(Utilities.manager.distanceAsString(distance: distance))"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        activities = CoreDataManager.manager.getAllEntities(for: distance) ?? []
    }
    
    private func sortActivitesByTime() {
        for i in 0..<activities.count {
            if !activities[i].completed {
                uncompletedActivities.append(activities[i])
            }
        }
        
        
    }
    
    public func setDistance(distance: Int) {
        self.distance = distance
    }
}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? RecordsTableViewCell {
            cell.setupCell(activity: activities[indexPath.row])
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
