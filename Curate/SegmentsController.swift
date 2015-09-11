//
//  SegmentsController.swift
//  Curate
//
//  Created by Curate on 12/20/14.
//  Copyright (c) 2014 Curate. All rights reserved.
//
//  Inspired by Marcus Crafter on 25/06/10.
//  Copyright 2010 Red Artisan. All rights reserved.

import UIKit

class SegmentsController: NSObject {
    var viewControllers: NSArray = NSArray()
    var navigationController = UINavigationController()
    
    func setTheNavigationController(aNavigationController: UINavigationController) {
        self.navigationController = aNavigationController
    }
    
    func setTheViewControllers(theViewControllers: NSArray) {
        self.viewControllers = theViewControllers
    }
    
    func indexDidChangeForSegmentedControl(aSegmentedControl: UISegmentedControl){
        println("inside indexDidChangeForSegmentedControl with selectedSegment Index as \(aSegmentedControl.selectedSegmentIndex)")
        
        var index: NSInteger = aSegmentedControl.selectedSegmentIndex
        
        var incomingViewController: UIViewController = self.viewControllers.objectAtIndex(index)
         as! UIViewController
        
        var theViewControllers: [UIViewController] = NSArray(object: incomingViewController) as! [UIViewController]
        self.navigationController.setViewControllers(theViewControllers as [UIViewController], animated: false)
        
        incomingViewController.navigationItem.titleView = aSegmentedControl
    }
}
