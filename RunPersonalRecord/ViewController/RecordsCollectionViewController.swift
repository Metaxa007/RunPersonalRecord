//
//  RecordsCollectionViewController.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 10.07.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

private let reuseIdentifier = "recordsCell"

class RecordsCollectionViewController: UICollectionViewController {

    private var distancesSet: Set<Int32> = []
    private var distancesArray: Array<Int32> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDistances()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }    }
    
    private func getDistances() {
        let allActivities = CoreDataManager.manager.getAllEntities()
        
        guard let activities = allActivities else { return }
                
        for activity in activities {
            distancesSet.insert(activity.distance)
        }

        distancesArray = Array(distancesSet)
        distancesArray.sort {
            $0 > $1
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return distancesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RecordsCollectionViewCell {
            cell.setupCell(distance: distancesArray[indexPath.item])

            return cell
        }

        return UICollectionViewCell()
    }

}
