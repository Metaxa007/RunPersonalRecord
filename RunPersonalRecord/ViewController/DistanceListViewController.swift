//
//  DistanceListViewController.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 12.11.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

private let unwindToMainSegue = "unwindToMainSegue"
private let distanceCell = "distanceCell"

class DistanceListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var distance:Int?
    private let records = [(42195, "Eliud Kipchoge", "2:01:39"),
                           (30000, "Moses Mosop", "1:26:47"),
                           (25000, "Moses Mosop", "1:12:25"),
                           (21097, "Geoffrey Kamworor", "58:01"),
                           (20000, "Haile Gebrselassie", "56:25"),
                           (15000, "Joshua Cheptegei", "41:05"),
                           (10000, "Joshua Cheptegei", "26:11"),
                           (5000, "Joshua Cheptegei", "12.35"),
                           (3000, "Daniel Komen", "7:20"),
                           (2000, "Hicham El Guerrouj", "4:44"),
                           (1609, "Hicham El Guerrouj", "3:43"),
                           (1000, "Hicham El Guerrouj", "2:11"),
                           (800, "David Rudisha", "1:40"),
                           (400, "Wayde van Niekerk", "43,03s"),
                           (200, "Usain Bolt", "19,19s"),
                           (100, "Usain Bolt", "9.58s")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == unwindToMainSegue {
            if let destinationSegue = segue.destination as? ViewController {
                destinationSegue.setDistanceToRun(distance: distance ?? 0)
            }
        }
    }
}

extension DistanceListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: distanceCell) as? DistanceTableViewCell {
            cell.textLabel?.text = "\(records[indexPath.row].0)"
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        distance = records[indexPath.row].0

        performSegue(withIdentifier: unwindToMainSegue, sender: self)
    }
}
