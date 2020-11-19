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
    
    var headersArray = [NSLocalizedString("intro_header_1", comment: ""), NSLocalizedString("intro_header_2", comment: ""), NSLocalizedString("intro_header_3", comment: "")]
    var subHeadersArray = [NSLocalizedString("intro_description_1", comment: ""),
                           NSLocalizedString("intro_description_2", comment: ""),
                           NSLocalizedString("intro_description_3", comment: "")]
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
