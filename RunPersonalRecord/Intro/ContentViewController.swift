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
    
    private var header = ""
    private var subHeader = ""
    private var imageFile = ""
    private var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerLabel.text = header
        subHeaderLabel.text = subHeader
//        imageView.image = UIImage(named: imageFile)
        pageControl.numberOfPages = 3
        pageControl.currentPage = index
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

}
