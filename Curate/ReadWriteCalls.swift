//
//  ReadWriteCalls.swift
//  Curate
//
//  Created by Curate on 3/31/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import Foundation
import CoreData

/// NSUSER DEFAULTS CALLS
func writeCustomObjArraytoUserDefaults(objectArray: [NSObject], fileName: String) {
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(objectArray)
    userDefaults.setObject(data, forKey: fileName)
    userDefaults.synchronize()
}


func readCustomObjArrayFromUserDefaults(fileName: String) -> [NSObject] {
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    if let data: NSData = userDefaults.objectForKey(fileName) as? NSData {
        var objectArray: [NSObject] = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [NSObject]
        return objectArray
    } else {
        return []
    }
}

/// CORE DATA CALLS

func getUserFromCoreData() -> User? {
    let fetchRequest = NSFetchRequest(entityName: "User")
    var error: NSError?
    if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [User] {
        println(fetchResults[0])
        return fetchResults[0]
    }
    return nil
}

func getBatchIndex() -> Indexes {
    // Retrieves BatchIndex if it is already saved, otherwise saves new batchIndex starting at index 0
    var indexes: Indexes?
    if(hasBatchIndex()) {
        // gets tokens from persistent storage
        // Create a new fetch request using the Tokens entity
        let fetchRequest = NSFetchRequest(entityName: "Indexes")
        
        // Execute the fetch request, and cast the results to an array of Tokens objects
        let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [Indexes]
        indexes = fetchResults[0]
    } else {
        indexes = NSEntityDescription.insertNewObjectForEntityForName("Indexes", inManagedObjectContext: managedObjectContext!) as? Indexes
        indexes?.batchIndex = 0
        indexes?.cardsIndex = 0
    }
    var error: NSError?
    managedObjectContext?.save(&error)
    return indexes!
}

func hasBatchIndex() ->Bool {
    let fetchRequest = NSFetchRequest(entityName: "Indexes")
    let count = managedObjectContext?.countForFetchRequest(fetchRequest, error: nil)
    println("Indexes = \(count!)")
    return (count != 0) ? true:false
}