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
    var tags: [String]?
    var jacket: Top?
    var lightLayer: Top?
    var collaredShirt: Top?
    var longSleeveShirt: Top?
    var shortSleeveShirt: Top?
    var pants: Bottom?
    var shorts: Bottom?
    
    override init() {
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.title = aDecoder.decodeObjectForKey("title") as String?
        self.tags = aDecoder.decodeObjectForKey("tags") as [String]?
        self.jacket = aDecoder.decodeObjectForKey("jacket") as Top?
        self.lightLayer = aDecoder.decodeObjectForKey("lightLayer") as Top?
        self.collaredShirt = aDecoder.decodeObjectForKey("collaredShirt") as Top?
        self.longSleeveShirt = aDecoder.decodeObjectForKey("longSleeveShirt") as Top?
        self.shortSleeveShirt = aDecoder.decodeObjectForKey("shortSleeveShirt") as Top?
        self.pants = aDecoder.decodeObjectForKey("pants") as Bottom?
        self.shorts = aDecoder.decodeObjectForKey("shorts") as Bottom?
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.title, forKey: "title")
        coder.encodeObject(self.tags, forKey: "tags")
        coder.encodeObject(self.jacket, forKey: "jacket")
        coder.encodeObject(self.lightLayer, forKey: "lightLayer")
        coder.encodeObject(self.collaredShirt, forKey: "collaredShirt")
        coder.encodeObject(self.longSleeveShirt, forKey: "longSleeveShirt")
        coder.encodeObject(self.shortSleeveShirt, forKey: "shortSleeveShirt")
        coder.encodeObject(self.pants , forKey: "pants")
        coder.encodeObject(self.shorts, forKey: "shorts")
    }
}
