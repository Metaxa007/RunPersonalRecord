//
//  PageViewController.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 03.11.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    let contentViewController = "contentViewController"
    
    var headersArray = ["Choose a distance", "Run as fast as you can!", "Records Tabel"]
    var subHeadersArray = ["Enter a distance or choose one you desire to set a record",
                           "While running you will be accompanied by a voice assistant and it will let you know once you finished the distance",
                           "Find and investigate your best results in the records table"]
    var imagesArray = ["img1", "img2", "img3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if let firstViewController = displayViewController(atIndex: 0) {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func displayViewController(atIndex index: Int) -> ContentViewController? {
        guard index >= 0 else { return nil }
        guard index < headersArray.count else { return nil }
        guard let contentVC = storyboard?.instantiateViewController(identifier:contentViewController ) as? ContentViewController else { return nil }
        
        contentVC.setHeader(header: headersArray[index])
        contentVC.setSubHeader(subHeader: subHeadersArray[index])
        contentVC.setImageFile(imageFile: imagesArray[index])
        contentVC.setIndex(index: index)
        
        return contentVC
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).getIndex()
        index -= 1
        
        return displayViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).getIndex()
        index += 1
        
        return displayViewController(atIndex: index)
    }
}
