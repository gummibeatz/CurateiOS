//
//  ReadWriteCalls.swift
//  Curate
//
//  Created by Kenneth Kuo on 3/31/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation

func writeCustomObjArraytoUserDefaults(objectArray: [NSObject], fileName: String) {
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(objectArray)
    userDefaults.setObject(data, forKey: fileName)
    userDefaults.synchronize()
}


func readCustomObjArrayFromUserDefaults(fileName: String) -> [NSObject] {
    let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    if let data: NSData = userDefaults.objectForKey(fileName) as? NSData {
        var objectArray: [NSObject] = NSKeyedUnarchiver.unarchiveObjectWithData(data) as [NSObject]
        return objectArray
    } else {
        return []
    }
}