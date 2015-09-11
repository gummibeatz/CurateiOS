//
//  Curate.swift
//  Curate
//
//  Created by Curate on 3/31/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import Foundation
import CoreData

class Bottom: Clothing {
    
//    var fileName: String?
//    var url: String?
//    var mainCategory: String?
    var occasion: String?
    var brand: String?
    var clothingType: String?
    var clothingType2: String?
    var pleat: String?
    var color1: String?
    var color2: String?
    var fit: String?
    var material: String?
//    var imageData: NSData?
    
    override init() {
        super.init()
    }
    
    init(bottom: NSDictionary, url: String, imageData: NSData) {
        super.init()
        self.fileName = bottom.objectForKey("file_name") as? String
        self.url = url
        self.properties = bottom
        self.mainCategory = bottom.objectForKey("main_category") as? String
        self.occasion = bottom.objectForKey("occasion") as? String
        self.brand = bottom.objectForKey("brand") as? String
        self.clothingType = bottom.objectForKey("clothing_type") as? String
        self.clothingType2 = bottom.objectForKey("clothing_type_2") as? String
        self.pleat = bottom.objectForKey("pleat") as? String
        self.color1 = bottom.objectForKey("color_1") as? String
        self.color2 = bottom.objectForKey("color_2") as? String
        self.fit = bottom.objectForKey("fit") as? String
        self.material = bottom.objectForKey("material") as? String
        self.imageData = imageData
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.fileName = aDecoder.decodeObjectForKey("fileName") as! String?
        self.url = aDecoder.decodeObjectForKey("url") as! String?
        self.properties = aDecoder.decodeObjectForKey("properties") as! NSDictionary?
        self.mainCategory = aDecoder.decodeObjectForKey("mainCategory") as! String?
        self.occasion = aDecoder.decodeObjectForKey("occasion") as! String?
        self.brand = aDecoder.decodeObjectForKey("brand") as! String?
        self.clothingType = aDecoder.decodeObjectForKey("clothingType") as! String?
        self.clothingType2 = aDecoder.decodeObjectForKey("clothingType2") as! String?
        self.pleat = aDecoder.decodeObjectForKey("pleat") as! String?
        self.color1 = aDecoder.decodeObjectForKey("color1") as! String?
        self.color2 = aDecoder.decodeObjectForKey("color2") as! String?
        self.fit = aDecoder.decodeObjectForKey("fit") as! String?
        self.material = aDecoder.decodeObjectForKey("material") as! String?
        self.imageData = aDecoder.decodeObjectForKey("imageData") as! NSData?
    }
    
    override func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.fileName, forKey: "fileName")
        coder.encodeObject(self.url, forKey: "url")
                coder.encodeObject(self.properties, forKey: "properties")
        coder.encodeObject(self.mainCategory, forKey: "mainCategory")
        coder.encodeObject(self.brand, forKey: "brand")
        coder.encodeObject(self.occasion, forKey: "occasion")
        coder.encodeObject(self.clothingType, forKey: "clothingType")
        coder.encodeObject(self.clothingType2, forKey: "clothingType2")
        coder.encodeObject(self.pleat, forKey: "pleat")
        coder.encodeObject(self.color1, forKey: "color1")
        coder.encodeObject(self.color2, forKey: "color2")
        coder.encodeObject(self.fit, forKey: "fit")
        coder.encodeObject(self.material, forKey: "material")
        coder.encodeObject(self.imageData, forKey: "imageData")
        
    }
}
