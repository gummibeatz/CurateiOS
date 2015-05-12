//
//  ViewController.swift
//  WardrobeBuilder
//
//  Created by Kenneth Kuo on 12/10/14.
//  Copyright (c) 2014 Kenneth Kuo. All rights reserved.
//

import UIKit
import CoreData

class WardrobeBuilderVC: UIViewController {
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    var user: User?
    var batches = Array<AnyObject>()
    var indexes: Indexes?
    var draggableBackground: DraggableViewBackground?
    
    //should change where the token is located in the larger project
    //also should change the place to getUser to the login screen.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //added in as a buffer updated after dispatch async
        self.draggableBackground = DraggableViewBackground(frame: self.view.frame)
        indexes = getBatchIndex()
        
        
        ///HERES A PROBLEM GOTTA SETUP USER IN FIRST STEP
        let currentUser: User = getUserFromCoreData()!
        /// END
        
        getSwipeBatch(currentUser) {
            swipeBatch in
            println("getSwipeBatch finished")
            self.batches = swipeBatch
            // only add in the draggable background view after we have the swipe batches
            // so that we can load up the images
            // I gotta ask somebody about setting up these concurrency dealios
            dispatch_async(dispatch_get_main_queue(), {
                self.draggableBackground!.removeFromSuperview()
                self.draggableBackground  = DraggableViewBackground(frame: self.view.frame, swipeBatch: swipeBatch, indexes: self.indexes!, currentUser: currentUser)
                self.view.addSubview(self.draggableBackground!)
            })
        }
    
        self.view.addSubview(self.draggableBackground!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

