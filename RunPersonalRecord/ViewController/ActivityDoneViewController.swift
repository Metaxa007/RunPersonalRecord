//
//  ActivityDoneViewController.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 26.09.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit
import MapKit

class ActivityDoneViewController: UIViewController {
    
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var splitsTableView: UITableView!
    
    private var paceDic = [Int : Double]()
    private var restDistPaceDic = [Int : Double]()
    
    private var activity: ActivityEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activity = getActivity()
        
        paceDic = activity.pace?.getPace() ?? [:]
        restDistPaceDic = activity.pace?.getRestDistance() ?? [:]
    }
    
    private func getActivity() -> ActivityEntity? {
        let activites = CoreDataManager.manager.getAllEntities()

        //Crash if last activity does not exist for some reason
        return activites![activites!.count - 1]
    }
    
}

extension ActivityDoneViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == infoTableView {
            return 4
        } else if tableView == splitsTableView {
            return paceDic.count + restDistPaceDic.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    
}
