//
//  MainTabController.swift
//  Curate
//
//  Created by Linus Liang on 9/27/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    let iconSize = CGSize(width: 30, height: 30)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        self.tabBar.tintColor = UIColor.blackColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupViewControllers() {
        let wardrobeBuilderVC = WardrobeBuilderVC()
        wardrobeBuilderVC.tabBarItem = UITabBarItem(title: "Wardrobe Builder", image: RBResizeImage(UIImage(named: "Swipe")!, targetSize: iconSize), tag: 0)
        
        let outfitBuilderVC = OutfitBuilderContainerVC()
        outfitBuilderVC.tabBarItem = UITabBarItem(title: "Outfit Builder", image: RBResizeImage(UIImage(named: "Outfit")!, targetSize: iconSize), tag: 1)

        let outfitsVC = OutfitsVC()
        outfitsVC.tabBarItem = UITabBarItem(title: "Outfits", image: RBResizeImage(UIImage(named: "Wardrobe")!, targetSize: iconSize), tag: 2)
        
        self.viewControllers = [wardrobeBuilderVC, outfitBuilderVC, outfitsVC]
    }
}