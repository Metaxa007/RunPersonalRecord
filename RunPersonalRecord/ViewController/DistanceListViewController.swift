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
    private let records = [(distance: Distance.Marathon, name: NSLocalizedString("eliud_kipchoge", comment: ""), duration: NSLocalizedString("marathon_time", comment: "")),
                           (distance: Distance.KM30, name: NSLocalizedString("moses_mosop", comment: ""), duration: NSLocalizedString("30km_time", comment: "")),
                           (distance: Distance.KM25, name: NSLocalizedString("moses_mosop", comment: ""), duration: NSLocalizedString("25km_time", comment: "")),
                           (distance: Distance.Halfmarathon, name: NSLocalizedString("geoffrey_kamworor", comment: ""), duration: NSLocalizedString("halfmarathon_time", comment: "")),
                           (distance: Distance.KM20, name: NSLocalizedString("haile_gebrselassie", comment: ""), duration: NSLocalizedString("20km_time", comment: "")),
                           (distance: Distance.KM15, name: NSLocalizedString("joshua_cheptegei", comment: ""), duration: NSLocalizedString("15km_time", comment: "")),
                           (distance: Distance.KM10, name: NSLocalizedString("joshua_cheptegei", comment: ""), duration: NSLocalizedString("10km_time", comment: "")),
                           (distance: Distance.KM5, name: NSLocalizedString("joshua_cheptegei", comment: ""), duration: NSLocalizedString("5km_time", comment: "")),
                           (distance: Distance.KM3, name: NSLocalizedString("daniel_komen", comment: ""), duration: NSLocalizedString("3km_time", comment: "")),
                           (distance: Distance.KM2, name: NSLocalizedString("hicham_el_guerrouj", comment: ""), duration: NSLocalizedString("2km_time", comment: "")),
                           (distance: Distance.Mile, name: NSLocalizedString("hicham_el_guerrouj", comment: ""), duration: NSLocalizedString("mile_time", comment: "")),
                           (distance: Distance.OneAndHalf, name: NSLocalizedString("hicham_el_guerrouj", comment: ""), duration: NSLocalizedString("5km_time", comment: "")),
                           (distance: Distance.KM1, name: NSLocalizedString("noah_ngenye", comment: ""), duration: NSLocalizedString("1km_time", comment: "")),
                           (distance: Distance.M800, name: NSLocalizedString("david_rudisha", comment: ""), duration: NSLocalizedString("800m_time", comment: "")),
                           (distance: Distance.M400, name: NSLocalizedString("wayde_van_niekerk", comment: ""), duration: NSLocalizedString("400m_time", comment: "")),
                           (distance: Distance.M200, name: NSLocalizedString("usain_bolt", comment: ""), duration: NSLocalizedString("200m_time", comment: "")),
                           (distance: Distance.M100, name:  NSLocalizedString("usain_bolt", comment: ""), duration: NSLocalizedString("100m_time", comment: ""))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("choose_distance", comment: "")
        
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
            cell.setupCell(distance: records[indexPath.row].distance, name: records[indexPath.row].name, duration: records[indexPath.row].duration)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        distance = records[indexPath.row].distance.rawValue

        performSegue(withIdentifier: unwindToMainSegue, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
