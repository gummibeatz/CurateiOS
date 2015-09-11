//
//  WardrobeBuilder.swift
//  WardrobeBuilder
//
//  Created by Curate on 3/11/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import Foundation
import CoreData

class Tokens: NSManagedObject {

    @NSManaged var curateAuthToken: String
    @NSManaged var fbAuthToken: String

}
