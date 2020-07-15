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
    private var wasLoaded = false
    
    override func viewWillAppear(_ animated: Bool) {
        getDistances()
        
        if wasLoaded {
            collectionView.reloadData()
        } else {
            wasLoaded = true
        }
    }
    
    private func getDistances() {
        distancesSet = []
        distancesArray = []
        
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
    
    /**
        Delete corresponding distances in CoreData and reloads CollectionView
     */
    private func deleteItem(index: Int) {
        print(distancesArray[index])
        CoreDataManager.manager.deleteAll(distance: Int(distancesArray[index]))
        getDistances()
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil){ action in
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), identifier: nil,discoverabilityTitle: nil, attributes: .destructive, handler: {action in
                self.deleteItem(index: indexPath.item)
            })
            
            return UIMenu(title: "", image: nil, identifier: nil, children: [delete])
        }
        
        return configuration
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
