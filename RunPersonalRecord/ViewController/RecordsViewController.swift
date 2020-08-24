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
    private var activities: [ActivityEntity]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Records \(Utilities.manager.distanceAsString(distance: distance))"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        activities = CoreDataManager.manager.getAllEntities(for: distance)
    }
    
    public func setDistance(distance: Int) {
        self.distance = distance
    }
}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return activities != nil ? activities!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? RecordsTableViewCell {
            if let activity = activities?[indexPath.row] {
                cell.setupCell(activity: activity)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}
