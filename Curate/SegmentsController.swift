//
//  SegmentsController.swift
//  Curate
//
//  Created by Kenneth Kuo on 12/20/14.
//  Copyright (c) 2014 Kenneth Kuo. All rights reserved.
//
//  Inspired by Marcus Crafter on 25/06/10.
//  Copyright 2010 Red Artisan. All rights reserved.

import UIKit

class SegmentsController: NSObject {
    var viewControllers: NSArray = NSArray()
    var navigationController = UINavigationController()
    
    func setNavigationController(aNavigationController: UINavigationController) {
        self.navigationController = aNavigationController
    }
    
    func setViewControllers(theViewControllers: NSArray) {
        self.viewControllers = theViewControllers
    }
    
    func indexDidChangeForSegmentedControl(aSegmentedControl: UISegmentedControl){
        println("inside indexDidChangeForSegmentedControl with selectedSegment Index as \(aSegmentedControl.selectedSegmentIndex)")
        
        var index: NSInteger = aSegmentedControl.selectedSegmentIndex
        
        var incomingViewController: UIViewController = self.viewControllers.objectAtIndex(index)
         as UIViewController
        
        var theViewControllers = NSArray(object: incomingViewController)
        self.navigationController.setViewControllers(theViewControllers, animated: false)
        
        incomingViewController.navigationItem.titleView = aSegmentedControl
    }
}
