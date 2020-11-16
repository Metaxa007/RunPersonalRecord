//
//  RecordsCollectionViewController.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 10.07.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

private let reuseIdentifier = "recordsCell"
private let showAddRunVCsegue = "showAddRunVCsegue"
private let showRecordsTVCsegue = "showRecordsTVCsegue"

class RecordsCollectionViewController: UICollectionViewController {
    
    private var distancesSet: Set<Int32> = []
    private var distancesArray: Array<Int32> = []
    private var wasLoaded = false
    private var selectedDistance = 0
    
    override func viewWillAppear(_ animated: Bool) {
        reloadCollectionView()
        
        navigationItem.title = NSLocalizedString("records", comment: "")
    }
    
    private func getDistances() {
        distancesSet = []
        distancesArray = []
        
        let allActivities = CoreDataManager.manager.getAllEntities()
        
        guard let activities = allActivities else { return }
        
        for activity in activities {
            distancesSet.insert(activity.distanceToRun)
        }
        
        distancesArray = Array(distancesSet)
        distancesArray.sort {
            $0 > $1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAddRunVCsegue {
            let navigationController = segue.destination as! UINavigationController

            // AddRunViewController is the first VC in the NavigationController
            if let destinationVC = navigationController.viewControllers[0] as? AddRunViewController {
                destinationVC.delegate = self
            }
        } else if segue.identifier == showRecordsTVCsegue {
            if let destinationVC = segue.destination as? RecordsViewController {
                destinationVC.setDistance(distance: selectedDistance)
            }
        }
    }
    
    func reloadCollectionView() {
        getDistances()
        
        if wasLoaded {
            collectionView.reloadData()
        } else {
            wasLoaded = true
        }
    }
    
    /**
        Delete corresponding distances in CoreData and reloads CollectionView
     */
    private func deleteItem(index: Int) {
        CoreDataManager.manager.deleteAll(distance: Int(distancesArray[index]))
        getDistances()
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil){ action in
            let delete = UIAction(title: NSLocalizedString("delete", comment: ""), image: UIImage(systemName: "trash.fill"), identifier: nil,discoverabilityTitle: nil, attributes: .destructive, handler: {action in
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDistance = Int(distancesArray[indexPath.item])
        performSegue(withIdentifier: showRecordsTVCsegue, sender: self)
    }
    
}

extension RecordsCollectionViewController: AddRunViewControllerDelegate {
    func addRunViewControllerDismiss() {
        reloadCollectionView()
    }
}
