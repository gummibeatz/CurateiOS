//
//  MainNavigationController.swift
//  Curate
//
//  Created by Linus Liang on 9/27/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//

import Foundation
import UIKit

class MainNavigationController: UINavigationController {
    
    let mainViewControllers = [WardrobeBuilderVC(), OutfitBuilderContainerVC(), OutfitsVC()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let oldFrame = self.navigationBar.frame
        self.navigationBar.frame = CGRect(x: 0, y: self.view.frame.height - oldFrame.height, width: oldFrame.width, height: oldFrame.height)
        self.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationBar.barTintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupSegmentedControl() {
        let titles = ["WardrobeBuilderVC","OutfitBuilderVC", "OutfitsVC"]
        let segmentedControl = UISegmentedControl(items: titles)
        segmentedControl.frame = CGRect(x: 0, y: -10, width: self.view.frame.width, height: 50)
        segmentedControl.addTarget(self, action: "indexDidChangeForSegmentedControl:", forControlEvents: .ValueChanged)
        segmentedControl.setImage(RBResizeImage(UIImage(named: "Swipe")!, targetSize: CGSize(width: 30, height: 30)).imageWithRenderingMode(.AlwaysOriginal) , forSegmentAtIndex: 0)
        segmentedControl.setImage(RBResizeImage(UIImage(named: "Wardrobe")!, targetSize: CGSize(width: 30, height: 30)).imageWithRenderingMode(.AlwaysOriginal), forSegmentAtIndex: 1)
        segmentedControl.setImage(RBResizeImage(UIImage(named: "Outfit")!, targetSize: CGSize(width: 30, height: 30)).imageWithRenderingMode(.AlwaysOriginal), forSegmentAtIndex: 2)
        
        segmentedControl.tintColor = UIColor.grayColor()
        
        let startIndex = 0
        segmentedControl.selectedSegmentIndex = startIndex
        self.indexDidChangeForSegmentedControl(segmentedControl)
        self.navigationBar.addSubview(segmentedControl)
    }
    
    func indexDidChangeForSegmentedControl(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        print("indexDidChangeForSegmentedControl selectedSegmentIndex is \(index)")
        self.setViewControllers([self.mainViewControllers[index]], animated: false)
    }
    
}

extension MainNavigationController: UINavigationBarDelegate {
    
}
