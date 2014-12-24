//
//  ViewController.swift
//  WardrobeBuilder
//
//  Created by Kenneth Kuo on 12/10/14.
//  Copyright (c) 2014 Kenneth Kuo. All rights reserved.
//

import UIKit

class WardrobeBuilderVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let draggableBackground:DraggableViewBackground = DraggableViewBackground(frame: self.view.frame)
        self.view.addSubview(draggableBackground)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

