//
//  Curate.swift
//  Curate
//
//  Created by Kenneth Kuo on 3/31/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation
import CoreData

class Bottom: NSObject, NSCoding {
    
    var brand: String?
    var clothingType: String?
    var clothingType2: String?
    var collarType: String?
    var color1: String?
    var color2: String?
    var fit: String?
    var material: String?
    var image: NSData?
    
    override init() {
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.brand = aDecoder.decodeObjectForKey("brand") as String?
        self.clothingType = aDecoder.decodeObjectForKey("clothingType") as String?
        self.clothingType2 = aDecoder.decodeObjectForKey("clothingType2") as String?
        self.collarType = aDecoder.decodeObjectForKey("collarType") as String?
        self.color1 = aDecoder.decodeObjectForKey("color1") as String?
        self.color2 = aDecoder.decodeObjectForKey("color2") as String?
        self.fit = aDecoder.decodeObjectForKey("fit") as String?
        self.material = aDecoder.decodeObjectForKey("material") as String?
        self.image = aDecoder.decodeObjectForKey("image") as NSData?
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.brand, forKey: "brand")
        coder.encodeObject(self.clothingType, forKey: "clothingType")
        coder.encodeObject(self.clothingType2, forKey: "clothingType2")
        coder.encodeObject(self.collarType, forKey: "collarType")
        coder.encodeObject(self.color1, forKey: "color1")
        coder.encodeObject(self.color2, forKey: "color2")
        coder.encodeObject(self.fit, forKey: "fit")
        coder.encodeObject(self.material, forKey: "material")
        coder.encodeObject(self.image, forKey: "image")
        
    }
}
