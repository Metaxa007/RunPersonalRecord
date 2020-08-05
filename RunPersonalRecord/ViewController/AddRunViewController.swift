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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

extension AddRunViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Tag1 number of rows table")
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addRunCell") as! AddRunTableViewCell
        
        cell.setupCell(indexPath: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("Tag1 heightForRowAt")

        if let cell = tableView.cellForRow(at: indexPath) as? AddRunTableViewCell {
            print("Tag1 \(cell.height)")
            return cell.height
        }

        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tag1 did select row")
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? AddRunTableViewCell {
            cell.selectedInTableView(tableView)
        }
    }
}
