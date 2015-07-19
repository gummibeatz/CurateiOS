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
    
//    saves the filename of all appropriate outfits
    var title: String?
    var tags: [String]?
    var jacket: String?
    var lightLayer: String?
    var collaredShirt: String?
    var longSleeveShirt: String?
    var shortSleeveShirt: String?
    var bottoms: String?
    
    override init() {
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.title = aDecoder.decodeObjectForKey("title") as! String?
        self.tags = aDecoder.decodeObjectForKey("tags")as! [String]?
        self.jacket = aDecoder.decodeObjectForKey("jacket") as! String?
        self.lightLayer = aDecoder.decodeObjectForKey("lightLayer") as! String?
        self.collaredShirt = aDecoder.decodeObjectForKey("collaredShirt") as! String?
        self.longSleeveShirt = aDecoder.decodeObjectForKey("longSleeveShirt") as! String?
        self.shortSleeveShirt = aDecoder.decodeObjectForKey("shortSleeveShirt") as! String?
        self.bottoms = aDecoder.decodeObjectForKey("bottoms") as! String?
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.title, forKey: "title")
        coder.encodeObject(self.tags, forKey: "tags")
        coder.encodeObject(self.jacket, forKey: "jacket")
        coder.encodeObject(self.lightLayer, forKey: "lightLayer")
        coder.encodeObject(self.collaredShirt, forKey: "collaredShirt")
        coder.encodeObject(self.longSleeveShirt, forKey: "longSleeveShirt")
        coder.encodeObject(self.shortSleeveShirt, forKey: "shortSleeveShirt")
        coder.encodeObject(self.bottoms , forKey: "bottoms")
    }
}
