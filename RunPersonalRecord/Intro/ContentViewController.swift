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
    @IBOutlet weak var skipButton: UIButton!
    
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
        skipButton.setTitle(NSLocalizedString("skip", comment: ""), for: .normal)
        
        switch index {
        case 0,1:
            nextButton.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
        default:
            nextButton.setTitle(NSLocalizedString("start", comment: ""), for: .normal)
        }
        
        setFontSizes()
    }
    
    private func setFontSizes() {
        let height = self.view.frame.height
        //Designed for iPhone 11 Max Pro. 896 is height of it in points
        if height != 896 {
            let scale = height / 896

            headerLabel.font = UIFont(name: headerLabel.font.fontName, size: headerLabel.font.pointSize * scale)
            subHeaderLabel.font = UIFont(name: subHeaderLabel.font.fontName, size: subHeaderLabel.font.pointSize * scale)
            skipButton.titleLabel?.font = UIFont(name: skipButton.titleLabel?.font.fontName ?? "AppleSDGothicNeo-Regular",
                                                 size: (skipButton.titleLabel?.font.pointSize ?? 26) * scale)
            nextButton.titleLabel?.font = UIFont(name: nextButton.titleLabel?.font.fontName ?? "AppleSDGothicNeo-Regular",
                                                 size: (nextButton.titleLabel?.font.pointSize ?? 26) * scale)
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
            dismissViewController()
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
