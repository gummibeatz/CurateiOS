//
//  OutfitBuilderContainerVC.swift
//  OutfitBuilderContainer
//
//  Created by Curate on 1/3/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import UIKit

class OutfitBuilderContainerVC: UIViewController, PropertiesViewVCDelegate, OutfitBuilderVCDelegate {
    
    let frameForOutfitBuilderVC: CGRect = UIScreen.mainScreen().bounds
    var outfitBuilderVC = OutfitBuilderVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outfitBuilderVC.outfitBuilderVCDelegate = self
        self.loadViewController(outfitBuilderVC)
    }
    
    
    //loads the bottom most layer view controller --> outfitbuilderVC with all the pickerviews
    func loadViewController(content: UIViewController) {
        self.addChildViewController(content)
        content.view.frame = self.frameForOutfitBuilderVC
        
        self.view.addSubview(content.view)
        content.didMoveToParentViewController(self)
    }
    
    //must change this to handle not only images  but data at some point
    func pickerViewWasTapped(image: UIImage) {
        println("pickerViewWasTapped Delegated")
        var propertiesViewVC = PropertiesViewVC()
        propertiesViewVC.propertiesViewVCDelegate = self
        propertiesViewVC.image = image
        self.addChildViewController(propertiesViewVC)
        self.view.addSubview(propertiesViewVC.view)
        propertiesViewVC.didMoveToParentViewController(self)
    }
    
    func blurEffectWasTapped(VC: UIViewController) {
        println("blurEffectDelegated")
        VC.view.removeFromSuperview()
        VC.willMoveToParentViewController(nil)
        VC.removeFromParentViewController()
        outfitBuilderVC.removeBlurEffectView()
    }
    
    
    
}
