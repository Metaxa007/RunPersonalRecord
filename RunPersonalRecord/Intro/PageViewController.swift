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
    var subHeadersArray = ["Enter a distance you desire to set a record for or choose one from the list of the best results human ever run",
                           "While running you will be accompanied by a voice assistant and it will let you know once you finished the distance",
                           "Find, share and investigate your best running results in the records table"]
    var imagesArray = ["Intro_1", "Intro_2", "Intro_3"]
    
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
        guard let contentViewController = storyboard?.instantiateViewController(identifier:contentViewController ) as? ContentViewController else { return nil }
        
        contentViewController.setHeader(header: headersArray[index])
        contentViewController.setSubHeader(subHeader: subHeadersArray[index])
        contentViewController.setImageFile(imageFile: imagesArray[index])
        contentViewController.setIndex(index: index)
        
        return contentViewController
    }
    
    func nextViewController(atIndex index: Int) {
        if let contentViewController = displayViewController(atIndex: index + 1) {
            setViewControllers([contentViewController], direction: .forward, animated: true, completion: nil)
        }
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
