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
//        getUser(curateAuthToken) {
//            currentUser in
//            self.user = currentUser
//            
//            getSwipeBatch(currentUser) {
//                swipeBatch in
//                self.batches = swipeBatch
//                
//                // only add in the draggable background view after we have the swipe batches
//                // so that we can load up the images
//                // I gotta ask somebody about setting up these concurrency dealios
//                dispatch_async(dispatch_get_main_queue(), {
//                    self.draggableBackground!.removeFromSuperview()
//                    self.draggableBackground  = DraggableViewBackground(frame: self.view.frame, swipeBatch: swipeBatch, indexes: self.indexes!)
//                    self.view.addSubview(self.draggableBackground!)
//                })
//            }
//        }
        
        var fbAuthToken:String = getFbAuthToken()
        println("fbAuthToken in WardrobeBuilderVC = \(fbAuthToken)")
        
        getCurateAuthToken(fbAuthToken) {
            curateAuthToken in
            
            getUser(curateAuthToken) {
                currentUser in
                
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
            }
        }
    
        self.view.addSubview(self.draggableBackground!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBatchIndex() -> Indexes {
        // Retrieves BatchIndex if it is already saved, otherwise saves new batchIndex starting at index 0
        var indexes: Indexes?
        if(hasBatchIndex()) {
            // gets tokens from persistent storage
            // Create a new fetch request using the Tokens entity
            let fetchRequest = NSFetchRequest(entityName: "Indexes")
            
            // Execute the fetch request, and cast the results to an array of Tokens objects
            let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as [Indexes]
            indexes = fetchResults[0]
        } else {
            indexes = NSEntityDescription.insertNewObjectForEntityForName("Indexes", inManagedObjectContext: self.managedObjectContext!) as? Indexes
            indexes?.batchIndex = 0
            indexes?.cardsIndex = 0
        }
        var error: NSError?
        self.managedObjectContext?.save(&error)
        return indexes!
    }
    
    func hasBatchIndex() ->Bool {
        let fetchRequest = NSFetchRequest(entityName: "Indexes")
        let count = managedObjectContext?.countForFetchRequest(fetchRequest, error: nil)
        println("Indexes = \(count!)")
        return (count != 0) ? true:false
    }
    
    
}

