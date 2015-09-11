//
//  ViewController.swift
//  WardrobeBuilder
//
//  Created by Curate on 12/10/14.
//  Copyright (c) 2014 Curate. All rights reserved.
//

import UIKit
import CoreData

class WardrobeBuilderVC: UIViewController {
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var user: User?
    var batches = Array<AnyObject>()
    var indexes: Indexes?
    var draggableBackground: DraggableViewBackground?
    
    //should change where the token is located in the larger project
    //also should change the place to getUser to the login screen.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstLaunchWardrobeBuilder = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunchWardrobeBuilder")
        if firstLaunchWardrobeBuilder  {
            println("not first launch in wardrobe builder")
        }
        else {
            println("First launch, setting NSUserDefault.")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
            
        }
        
        //added in as a buffer updated after dispatch async
        let tempDraggableBackground = DraggableViewBackground(frame: self.view.frame)
        indexes = getBatchIndex()
        
        
        ///HERES A PROBLEM GOTTA SETUP USER IN FIRST STEP
//        let currentUser: User = getUserFromCoreData()!
        let currentUser: User = User.createInManagedObjectContext(managedObjectContext!, preferences: NSDictionary())
        currentUser.preferredPantsFit = "Slim"
        currentUser.preferredShirtFit = "Extra Slim"
        /// END
                self.view.addSubview(tempDraggableBackground)
        getSwipeBatch(currentUser) {
            swipeBatch in
            println("getSwipeBatch finished")
            self.batches = swipeBatch
            // only add in the draggable background view after we have the swipe batches
            // so that we can load up the images
            // I gotta ask somebody about setting up these concurrency dealios
            self.draggableBackground  = DraggableViewBackground(frame: self.view.frame, swipeBatch: swipeBatch, indexes: self.indexes!, currentUser: currentUser)
            dispatch_async(dispatch_get_main_queue(), {
                tempDraggableBackground.removeFromSuperview()
                self.view.addSubview(self.draggableBackground!)
            })
            


        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

