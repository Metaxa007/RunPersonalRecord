//
//  ContentViewController.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 03.11.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subHeaderLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    private var header = ""
    private var subHeader = ""
    private var imageFile = ""
    private var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerLabel.text = header
        subHeaderLabel.text = subHeader
        imageView.image = UIImage(named: imageFile)
        pageControl.numberOfPages = 3
        pageControl.currentPage = index
        
        switch index {
        case 0,1:
            nextButton.setTitle("Next", for: .normal)
        default:
            nextButton.setTitle("Start", for: .normal)
        }
    }

    func setHeader(header: String) {
        self.header = header
    }
    
    func setSubHeader(subHeader: String) {
        self.subHeader = subHeader
    }
    
    func setImageFile(imageFile: String) {
        self.imageFile = imageFile
    }
    
    func setIndex(index: Int) {
        self.index = index
    }
    
    func getIndex() -> Int {
        return index
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        switch index {
        case 0,1:
            let pageViewController = parent as! PageViewController
            pageViewController.nextViewController(atIndex: index)
        default:
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        dismissViewController()
    }
    
    private func dismissViewController() {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(true, forKey: "wasIntroWatched")
        userDefaults.synchronize()
        
        dismiss(animated: true, completion: nil)
    }

}
