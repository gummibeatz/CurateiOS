//
//  ReadWriteCalls.swift
//  Curate
//
//  Created by Curate on 3/31/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataErrors: ErrorType {
    case BadFetchRequest
    case BadSave
}

/// NSUSER DEFAULTS CALLS
func writeCustomObjArraytoUserDefaults(objectArray: [NSObject], fileName: String) {
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(objectArray)
    userDefaults.setObject(data, forKey: fileName)
    userDefaults.synchronize()
    print("write success")
}


func readCustomObjArrayFromUserDefaults(fileName: String) -> [NSObject] {
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    if let data: NSData = userDefaults.objectForKey(fileName) as? NSData {
        let objectArray: [NSObject] = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [NSObject]
        return objectArray
    } else {
        return []
    }
}

/// CORE DATA CALLS

func getUserFromCoreData() -> User? {
    let fetchRequest = NSFetchRequest(entityName: "User")
    do {
        guard let fetchResults = try managedObjectContext!.executeFetchRequest(fetchRequest) as? [User] else {
            throw CoreDataErrors.BadFetchRequest
        }
        print(fetchResults[0])
        return fetchResults[0]
        
    } catch {
        print("badfetchrequest")
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
        let fetchResults = (try! managedObjectContext!.executeFetchRequest(fetchRequest)) as! [Indexes]
        indexes = fetchResults[0]
    } else {
        indexes = NSEntityDescription.insertNewObjectForEntityForName("Indexes", inManagedObjectContext: managedObjectContext!) as? Indexes
        indexes?.batchIndex = 0
        indexes?.cardsIndex = 0
    }
    do {
        try managedObjectContext?.save()
    } catch {
        print("badsave")
    }
    return indexes!
}

func hasBatchIndex() -> Bool {
    let fetchRequest = NSFetchRequest(entityName: "Indexes")
    let count = managedObjectContext!.countForFetchRequest(fetchRequest, error: nil)
    print("Indexes = \(count)")
    return (count != 0) ? true:false
}