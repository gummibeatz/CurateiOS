//
//  Curate.swift
//  Curate
//
//  Created by Kenneth Kuo on 3/31/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation
import CoreData

class Top: Clothing {

//    var fileName: String?
//    var url: String?
//    var mainCategory: String?
    var brand: String?
    var clothingType: String?
    var clothingType2: String?
    var collarType: String?
    var color1: String?
    var color2: String?
    var fit: String?
    var material: String?
//    var imageData: NSData?
    
    override init() {
        super.init()
    }
    
    init(top: NSDictionary, url: String, imageData: NSData) {
        super.init()
        self.fileName = top.objectForKey("file_name") as? String
        println(fileName!)
        self.url = url
        self.properties = top
        self.mainCategory = top.objectForKey("main_category") as? String
        self.brand = top.objectForKey("brand") as? String
        self.clothingType = top.objectForKey("clothing_type") as? String
        self.clothingType2 = top.objectForKey("clothing_type_2") as? String
        self.collarType = top.objectForKey("collar_type") as? String
        self.color1 = top.objectForKey("color_1") as? String
        self.color2 = top.objectForKey("color_2") as? String
        self.fit = top.objectForKey("fit") as? String
        self.material = top.objectForKey("material") as? String
        self.imageData = imageData
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.fileName = aDecoder.decodeObjectForKey("fileName") as! String?
        self.url = aDecoder.decodeObjectForKey("url") as! String?
        self.properties = aDecoder.decodeObjectForKey("properties") as! NSDictionary?
        self.mainCategory = aDecoder.decodeObjectForKey("mainCategory") as! String?
        self.brand = aDecoder.decodeObjectForKey("brand") as! String?
        self.clothingType = aDecoder.decodeObjectForKey("clothingType") as! String?
        self.clothingType2 = aDecoder.decodeObjectForKey("clothingType2") as! String?
        self.collarType = aDecoder.decodeObjectForKey("collarType") as! String?
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
        coder.encodeObject(self.clothingType, forKey: "clothingType")
        coder.encodeObject(self.clothingType2, forKey: "clothingType2")
        coder.encodeObject(self.collarType, forKey: "collarType")
        coder.encodeObject(self.color1, forKey: "color1")
        coder.encodeObject(self.color2, forKey: "color2")
        coder.encodeObject(self.fit, forKey: "fit")
        coder.encodeObject(self.material, forKey: "material")
        coder.encodeObject(self.imageData, forKey: "imageData")

    }
}
