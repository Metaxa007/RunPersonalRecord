//
//  SettingsViewController.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 11.06.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var distanceTextField: UITextField!
    //NSDefaults for distance
    private var distance = 0.0
    var viewController: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addToolBarToKeyBoard()
    }
    
    func addToolBarToKeyBoard() {
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonClicked))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.sizeToFit()
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        
        distanceTextField.inputAccessoryView = toolBar
    }

    @objc func doneButtonClicked() {
        if let distanceText = distanceTextField.text {
            distance = Double(distanceText)!
        }

        viewController?.distance = distance
        
        view.endEditing(true)
    }
    
    @objc func cancelButtonClicked() {
        distanceTextField.text = String(distance)
        
        view.endEditing(true)
    }
    
}
