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
    
    private var distancesSet: Set<Int32> = [] // will set add it to distanceArray
    private var distancesArray: Array<Int32> = []
    private var wasLoaded = false
    private let pickerView = UIPickerView()
    private let toolBar = UIToolbar()

    override func viewDidLoad() {
        pickerView.dataSource = self
        pickerView.delegate = self        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDistances()
        
        if wasLoaded {
            collectionView.reloadData()
        } else {
            wasLoaded = true
        }
    }
    
    func showPickerView() {
        view.addSubview(pickerView)
        view.addSubview(toolBar)
        
        pickerView.alpha = 1
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolBar.bottomAnchor.constraint(equalTo: pickerView.topAnchor).isActive = true
        toolBar.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func showToolBar() {
        let label = UILabel()
        label.text = "Choose distance (km)"
    
        let labelButton = UIBarButtonItem(customView: label)
        let doneButton = UIBarButtonItem(title:"Add", style: .plain, target: self, action: #selector(addDistance))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissPickerAndToolBar))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.alpha = 1
        toolBar.sizeToFit()
        toolBar.setItems([cancelButton, flexibleSpace, labelButton, flexibleSpace, doneButton], animated: false)
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
    
    @objc func addDistance() {
        let firstValue = pickerView.selectedRow(inComponent: 0)
        let secondValue = pickerView.selectedRow(inComponent: 2)
        let thirdValue = pickerView.selectedRow(inComponent: 3)
        let distanceString = "\(firstValue).\(secondValue)\(thirdValue)"
        let distanceDouble = Double(distanceString)
        
        if let distance = distanceDouble {
            distancesArray.append(Int32(distance * 1000))
            dismissPickerAndToolBar()
            collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    @objc func dismissPickerAndToolBar() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCurlDown, animations: { [weak self] in
            guard let self = self else { return }

            self.pickerView.alpha = 0
            self.toolBar.alpha = 0
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            
            self.pickerView.removeFromSuperview()
            self.toolBar.removeFromSuperview()
        })
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

extension RecordsCollectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 300
        } else if component == 1 {
            return 1
        } else {
            return 10
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
//            if pickerView.selectedRow(inComponent: 0) == row {
//                return "\(row)."
//            } else {
//                return "\(row)"
//            }
            return "\(row)"
        } else if component == 1 {
            return "."
        } else {
            return "\(row)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 1 {
            return 13
        } else {
            return 60
        }
    }
}
