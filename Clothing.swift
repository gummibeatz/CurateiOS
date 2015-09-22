//
//  Curate.swift
//  Curate
//
//  Created by Curate on 3/31/15.
//  Copyright (c) 2015 Curate. All rights reserved.
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
    
    init(clothing: NSDictionary) {
        super.init()
        self.fileName = clothing.objectForKey("file_name") as? String
        self.url = clothing.objectForKey("url") as? String
        self.mainCategory = clothing.objectForKey("main_category") as? String
        self.properties = clothing
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.fileName = aDecoder.decodeObjectForKey("fileName") as! String?
        self.url = aDecoder.decodeObjectForKey("url") as! String?
        self.mainCategory = aDecoder.decodeObjectForKey("mainCategory") as! String?
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.fileName, forKey: "fileName")
        coder.encodeObject(self.url, forKey: "url")
        coder.encodeObject(self.mainCategory, forKey: "mainCategory")
        coder.encodeObject(self.properties, forKey: "properties")
    }
    
    func convertToDict() -> NSDictionary {
        let dict: NSMutableDictionary = NSMutableDictionary()
        print(self.fileName)
        dict.setObject(self.fileName!, forKey: "file_name")
        dict.setObject(self.url!, forKey: "url")
        dict.setObject(self.properties!, forKey: "properties")
        return dict
    }
}
