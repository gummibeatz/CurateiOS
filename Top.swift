//
//  WardrobeBuilder.swift
//  WardrobeBuilder
//
//  Created by Kenneth Kuo on 3/11/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation
import CoreData

class Top: NSManagedObject {

    @NSManaged var brand: String
    @NSManaged var clothingType: String
    @NSManaged var clothingType2: String
    @NSManaged var collarType: String
    @NSManaged var color1: String
    @NSManaged var color2: String
    @NSManaged var fit: String
    @NSManaged var material: String

}
