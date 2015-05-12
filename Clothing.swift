//
//  Curate.swift
//  Curate
//
//  Created by Kenneth Kuo on 3/31/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation
import CoreData

class Clothing: NSObject, NSCoding {
    
    var fileName: String?
    var url: String?
    var mainCategory: String?
    var imageData: NSData?
    
    var properties: NSDictionary?

    
    override init() {
        super.init()
    }
    
    init(clothing: NSDictionary, url: String) {
        super.init()
        self.fileName = clothing.objectForKey("file_name") as? String
        self.url = url
        self.mainCategory = clothing.objectForKey("main_category") as? String
        self.properties = clothing
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.fileName = aDecoder.decodeObjectForKey("fileName") as String?
        self.url = aDecoder.decodeObjectForKey("url") as String?
        self.mainCategory = aDecoder.decodeObjectForKey("mainCategory") as String?
        
        self.properties = aDecoder.decodeObjectForKey("properties") as NSDictionary?
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.fileName, forKey: "fileName")
        coder.encodeObject(self.url, forKey: "url")
        coder.encodeObject(self.mainCategory, forKey: "mainCategory")
        coder.encodeObject(self.properties, forKey: "properties")
    }
}
