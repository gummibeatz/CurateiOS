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
    var batches = [[String]]()
    var batchIndex: NSNumber?
    var currentBatch: Batch?
    var draggableBackground: DraggableViewBackground?
    
    //should change where the token is located in the larger project
    //also should change the place to getUser to the login screen.
    let curateAuthToken = "mXa3EtKdNyr3guJ6iHfr"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //added in as a buffer updated after dispatch async
        self.draggableBackground = DraggableViewBackground(frame: self.view.frame)
        
        batchIndex = getBatchIndex()
        getUser(curateAuthToken) {
            currentUser in
            self.user = currentUser
            
            getSwipeBatch(currentUser) {
                swipeBatch in
                self.batches = swipeBatch
                
                // only add in the draggable background view after we have the swipe batches
                // so that we can load up the images
                // I gotta ask somebody about setting up these concurrency dealios
                dispatch_async(dispatch_get_main_queue(), {
                    self.draggableBackground!.removeFromSuperview()
                    self.draggableBackground  = DraggableViewBackground(frame: self.view.frame, swipeBatch: swipeBatch, batchIndex: Int(self.batchIndex!))
                    self.view.addSubview(self.draggableBackground!)
                })
            }
        }
        self.view.addSubview(self.draggableBackground!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBatchIndex() -> NSNumber {
        // Retrieves BatchIndex if it is already saved, otherwise saves new batchIndex starting at index 0
        var batch:Batch?
        if(hasBatchIndex()) {
            // gets tokens from persistent storage
            // Create a new fetch request using the Tokens entity
            let fetchRequest = NSFetchRequest(entityName: "Batch")
            
            // Execute the fetch request, and cast the results to an array of Tokens objects
            let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as [Batch]
            batch = fetchResults[0]
        } else {
            batch = NSEntityDescription.insertNewObjectForEntityForName("Batch", inManagedObjectContext: self.managedObjectContext!) as? Batch
            batch?.index = 0
        }
        var error: NSError?
        self.managedObjectContext?.save(&error)
        return batch!.index
    }
    
    func hasBatchIndex() ->Bool {
        let fetchRequest = NSFetchRequest(entityName: "Batch")
        let count = managedObjectContext?.countForFetchRequest(fetchRequest, error: nil)
        println("BatchIndex = \(count!)")
        return (count != 0) ? true:false
    }
    
    
}

