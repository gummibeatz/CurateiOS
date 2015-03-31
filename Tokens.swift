//
//  WardrobeBuilder.swift
//  WardrobeBuilder
//
//  Created by Kenneth Kuo on 3/11/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation
import CoreData

class Tokens: NSManagedObject {

    @NSManaged var curateAuthToken: String
    @NSManaged var fbAuthToken: String

}
