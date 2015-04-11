//
//  Curate.swift
//  Curate
//
//  Created by Kenneth Kuo on 3/31/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation
import CoreData

class Outfit: NSObject, NSCoding {
    
    var title: String?
    var top: Top?
    var sweater: Sweater?
    var jacket: Jacket?
    var bottom: Bottom?
    var shoes: Shoes?
    
    override init() {
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.title = aDecoder.decodeObjectForKey("title") as String?
        self.top = aDecoder.decodeObjectForKey("top") as Top?
        self.sweater = aDecoder.decodeObjectForKey("sweater") as Sweater?
        self.jacket = aDecoder.decodeObjectForKey("jacket") as Jacket?
        self.bottom = aDecoder.decodeObjectForKey("bottom") as Bottom?
        self.shoes = aDecoder.decodeObjectForKey("shoes") as Shoes?
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.title, forKey: "title")
        coder.encodeObject(self.top, forKey: "top")
        coder.encodeObject(self.sweater, forKey: "sweater")
        coder.encodeObject(self.jacket, forKey: "jacket")
        coder.encodeObject(self.bottom , forKey: "bottom")
        coder.encodeObject(self.shoes, forKey: "shoes")
    }
}
