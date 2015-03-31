//
//  WardrobeBuilder.swift
//  WardrobeBuilder
//
//  Created by Kenneth Kuo on 3/11/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var age: String
    @NSManaged var height: String
    @NSManaged var inseam: String
    @NSManaged var preferredPantsFit: String
    @NSManaged var preferredShirtFit: String
    @NSManaged var shirtSize: String
    @NSManaged var shoeSize: String
    @NSManaged var waistSize: String
    @NSManaged var weight: String

    //maybe need to change store as "User" to store as unique name to actual user take it as an input
    class func createInManagedObjectContext(moc: NSManagedObjectContext, preferences: NSDictionary) -> User {
        let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as User
        
        let null: String = ""
        
        if preferences["age"] is String{
            newUser.age = preferences["age"] as String
        } else {
            newUser.age = null
        }
        
        if preferences["height"] is String{
            newUser.height = preferences["height"] as String
        } else {
            newUser.height = null
        }
        
        if preferences["inseam"] is String{
            newUser.inseam = preferences["inseam"] as String
        } else {
            newUser.inseam = null
        }
        
        if preferences["weight"] is String{
            newUser.weight = preferences["weight"] as String
        } else {
            newUser.weight = null
        }
        
        if preferences["preferred_pants_fit"] is String{
            newUser.preferredPantsFit = preferences["preferred_pants_fit"] as String
        } else {
            newUser.preferredPantsFit = null
        }
        
        if preferences["preferred_shirt_fit"] is String{
            newUser.preferredShirtFit = preferences["preferred_shirt_fit"] as String
        } else {
            newUser.preferredShirtFit = null
        }
        
        if preferences["shirt_size"] is String{
            newUser.shirtSize = preferences["shirt_size"] as String
        } else {
            newUser.shirtSize = null
        }
        
        if preferences["shoe_size"] is String{
            newUser.shoeSize = preferences["shoe_size"] as String
        } else {
            newUser.shoeSize = null
        }
        
        if preferences["waist_size"] is String{
            newUser.waistSize = preferences["waist_size"] as String
        } else {
            newUser.waistSize = null
        }
        
        return newUser
    }
}
