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
    private let records = [(distance: Distance.Marathon, name: NSLocalizedString("eliud_kipchoge", comment: ""), duration: "2h:01m:39s", date: "16.09.2018"),
                           (distance: Distance.KM30, name: NSLocalizedString("moses_mosop", comment: ""), duration: "1h:26m:47s", date: "03.06.2011"),
                           (distance: Distance.KM25, name: NSLocalizedString("moses_mosop", comment: ""), duration: "1h:12n:25s", date: "03.06.2011"),
                           (distance: Distance.Halfmarathon, name: NSLocalizedString("geoffrey_kamworor", comment: ""), duration: "58m:01s", date: "15.09.2019"),
                           (distance: Distance.KM20, name: NSLocalizedString("haile_gebrselassie", comment: ""), duration: "56m:25s", date: "27.06.2007"),
                           (distance: Distance.KM15, name: NSLocalizedString("joshua_cheptegei", comment: ""), duration: "41m:05s", date: "18.11.2018"),
                           (distance: Distance.KM10, name: NSLocalizedString("joshua_cheptegei", comment: ""), duration: "26m:11s", date: "07.10.2020"),
                           (distance: Distance.KM5, name: NSLocalizedString("joshua_cheptegei", comment: ""), duration: "12m.35s", date: "14.08.2020"),
                           (distance: Distance.KM3, name: NSLocalizedString("daniel_komen", comment: ""), duration: "7m:2s0", date: "01.09.1996"),
                           (distance: Distance.KM2, name: NSLocalizedString("hicham_el_guerrouj", comment: ""), duration: "4m:44s", date: "07.09.1999"),
                           (distance: Distance.Mile, name: NSLocalizedString("hicham_el_guerrouj", comment: ""), duration: "3m:43s", date: "07.07.1999"),
                           (distance: Distance.OneAndHalf, name: NSLocalizedString("hicham_el_guerrouj", comment: ""), duration: "3m:26s", date: "14.07.1998"),
                           (distance: Distance.KM1, name: NSLocalizedString("noah_ngenye", comment: ""), duration: "2m:11s", date: "05.09.1999"),
                           (distance: Distance.M800, name: NSLocalizedString("david_rudisha", comment: ""), duration: "1m:40s", date: "09.08.2012"),
                           (distance: Distance.M400, name: NSLocalizedString("wayde_van_niekerk", comment: ""), duration: "43.03s", date: "14.08.2016"),
                           (distance: Distance.M200, name: NSLocalizedString("usain_bolt", comment: ""), duration: "19.19s", date: "20.08.2009"),
                           (distance: Distance.M100, name:  NSLocalizedString("usain_bolt", comment: ""), duration: "9.58s", date: "16.08.2009")]
    
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
