//
//  OutfitsContainerVC.swift
//  Outfits
//
//  Created by Kenneth Kuo on 1/5/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import UIKit

class OutfitsContainerVC: UIViewController {
    
    let frameForOutfitsVC: CGRect = CGRect(x:0, y: 20, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    var outfitsVC = OutfitsVC()
    var outfitCell: OutfitCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadViewController(outfitsVC)
    }
    
    //loads the bottom most layer view controller --> outfitbuilderVC with all the pickerviews
    func loadViewController(content: UIViewController) {
        self.addChildViewController(content)
        content.view.frame = self.frameForOutfitsVC
        
        self.view.addSubview(content.view)
        content.didMoveToParentViewController(self)
    }
    
    func setOutfitsVCDelegate(appDelegate: AppDelegate) {
        println("settingoutfitvcdelegate")
        outfitsVC.outfitsDelegate = appDelegate
    }
}
