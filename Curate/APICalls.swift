//
//  APICalls.swift
//  WardrobeBuilder
//
//  Created by Kenneth Kuo on 3/4/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext


// takes in parameter of unique user curate Auth Token
// makes a request to curate website to retrieve and store user preferences
// in object User 
/// NEEED TO MAKE EDIT TO CHECK IF USER ALREADY EXISTS AND OVERWRITE
func getUser(curateAuthToken: String, completionHandler:(currentUser:User) ->()) {
    let request = NSMutableURLRequest(URL: NSURL(string: "http://curateanalytics.herokuapp.com/api/v1/user.json")!)
    request.HTTPMethod = "POST"
    let postDict = ["authentication_token":curateAuthToken] as Dictionary<String,String>
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(postDict, options: nil, error: nil)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
        var error:NSError?
        if let userDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary{
            
            println(curateAuthToken)
            var preferencesDict: NSDictionary = userDict.valueForKey("preferences") as NSDictionary
        
            
            /// MUST TAKE THESE OUT LATER!!!!!!!!!
            ///
            ///
            preferencesDict.setValue("9", forKey: "age")
            preferencesDict.setValue("Extra Slim", forKey: "preferred_shirt_fit")
            preferencesDict.setValue("Regular", forKey: "preferred_pants_fit")
            
//            println("preferencesDict = \(preferencesDict)")
            
            if let moc = WardrobeBuilderVC().managedObjectContext {
                var user: User = User.createInManagedObjectContext(moc, preferences: preferencesDict)
                println("user created and stored")
                completionHandler(currentUser: user)
            }
        } else {
            println("fucking hell shit goddamn it/ your authtoken isn't correct")
        }
    }
    task.resume()
}

//returns the dictionary of swipeBatches as a completion handler
func getSwipeBatch(user: User, completionHandler:(swipeBatch:Array<Array<Clothing>>) ->()) {
    println("in getSwipeBatch")
    var swipeBatch  = chooseSwipeBatch(user)
    println("going to http://curateanalytics.herokuapp.com/api/v1/batch?batch_folder=\(swipeBatch.folder)")
    let request = NSMutableURLRequest(URL: NSURL(string: "http://curateanalytics.herokuapp.com/api/v1/batch?batch_folder=\(swipeBatch.folder)")!)
    request.HTTPMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    println("just before task in getSwipeBatch")
    
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
        var error: NSError?
        if let batchArr: Array<Array<AnyObject>> = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? Array<Array<AnyObject>> {
            
            // hard coded in should make a function to create this string
            // auto make the extra_slim_shirt_regular_pant part
            
            println("before completion handler in getswipebatch")
//            println(batchDict.objectForKey("folder")?.objectForKey(swipeBatch.folder) as Array<Array<NSDictionary>> )
            completionHandler(swipeBatch: formatSwipeBatch(batchArr))
            println("after completion handler in get swipebatch")
        }
        
    }
    task.resume()
}

//func getFormattedBatchIndex(batchIndex: NSNumber) -> String {
//    let formatter = NSNumberFormatter()
//    let num:Int = batchIndex.integerValue + 1
//    formatter.minimumIntegerDigits = 2
//    return formatter.stringFromNumber(NSNumber(integer: num))!
//}

func getImageData(imagePath: String) -> NSData {
    let url = NSURL(string: imagePath)
    let data = NSData(contentsOfURL: url!)
    return data!
}

// chooses and returns the batchID that corresponds to the user preferences
func chooseSwipeBatch(user:User) -> (id: Int, folder: String) {
    let preferredFit = (shirtFit: user.preferredShirtFit, pantsFit: user.preferredPantsFit)
    
    switch preferredFit {
    case let("Extra Slim", "Regular"):
        return (1, "extra_slim_shirt_regular_pant")
    case let("Extra Slim", "Skinny"):
        return (2, "extra_slim_shirt_skinny_pant")
    case let("Extra Slim", "Slim"):
        return (3, "extra_slim_shirt_slim_pant")
    case let("Regular", "Regular"):
        return (4, "regular_shirt_regular_pant")
    case let("Regular", "Skinny"):
        return (5, "regular_shirt_skinny_pant")
    case let("Regular", "Slim"):
        return (6, "regular_shirt_slim_pant")
    case let("Extra Slim", "Regular"):
        return (7, "extra_slim_shirt_regular_pant")
    case let("Extra Slim", "Skinny"):
        return (8, "extra_slim_shirt_skinny_pant")
    case let("Extra Slim", "Slim"):
        return (9, "extra_slim_shirt_slim_pant")
    default:
        return (0, "error nothing matches")
    }
}

//formats swipeBatch by returning an array of Tops should probably choose if its bottoms or not later
// index    |  field
// 0        |  id
// 1        |  user preference
// 2        |  batch number
// 3        |  filename
// 4        |  url
// 5        |  Top properties
func formatSwipeBatch(batchArr: Array<Array<AnyObject>>) -> Array<Array<Clothing>> {
    println("in formatSwipeBatch")
    var batches: Array<Array<Clothing>> = Array<Array<Clothing>>()
    var batchRow: Array<Clothing> = Array<Clothing>()
    for var row = 0; row < batchArr.count; row++ {
        batchRow.removeAll(keepCapacity: false)
        for var col = 0; col < (batchArr[row]).count; col++ {
            let tempDict: NSDictionary = batchArr[row][col] as NSDictionary
            let url: String = tempDict.objectForKey("url") as String
            let clothingDict:NSDictionary = tempDict.objectForKey("properties") as NSDictionary
            var clothing: Clothing = Clothing()
            
            /// THIS IS SUPER SLOW CHANGE LATER???
            switch clothingDict.objectForKey("main_category") as String {
            case "Tops":
                println("making it a top")
                clothing = Top(top: clothingDict, url: url)
            case "Bottoms":
                println("making it a bottom")
                clothing = Bottom(bottom: clothingDict, url: url)
            default:
                println("not anything")
            }
            batchRow.append(clothing)
        }
        batches.append(batchRow)
    }
    println("finished formatting swipebatch")
    println("number of batch rows = \(batches.count)")
    println("number of batch col for first row = \(batches[1].count)")
    return batches
}

func hasUser(user: String) -> Bool {
    let fetchRequest = NSFetchRequest(entityName: user)
    let count = managedObjectContext?.countForFetchRequest(fetchRequest, error: nil)
    println("count with name, \(user) = \(count)")
    return (count != 0) ? true:false
}


// takes in parameter of user unique fbAuthToken and makes a request to curate website
// to get curate specific auth token
// saves curate auth token into field Tokens.curateAuthToken
func getCurateAuthToken(fbAuthToken: String,completionHandler:(curateAuthToken:String) ->()) {
    // setting up request
    println("==============\nin getCurateAuthToken")
    println("fbAuthToken = \(fbAuthToken)")
    
    let request = NSMutableURLRequest(URL: NSURL(string:  "http://curateanalytics.herokuapp.com/api/v1/tokens.json")!)
    request.HTTPMethod = "POST"
    
    let postDict = ["token":fbAuthToken] as Dictionary<String, String>
    var err:NSError?
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(postDict, options: nil, error: &err)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    //performing the request
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
        data, response, error in
        
        if error != nil {
            println("error=\(error)")
            return
        }
        println(response)
        var jsonResult:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as NSDictionary
        println(jsonResult)
        if let authentication_token: String = jsonResult["authentication_token"] as? String {
            println("curateAuthToken given")
            completionHandler(curateAuthToken: authentication_token)
        } else {
            println("error no curate AuthToken")
        }
        //            println(jsonResult)
        //            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
        //            println("responseString = \(responseString)")
        //            println("authentication_token = \(authentication_token)")
    }
    task.resume()
}

// accesses FB API and
// gets fbAuthToken and stores it into the field Tokens.fbAuthToken
func getFbAuthToken() -> String {
    var fbAuthToken = String()
    if (FBSession.activeSession().isOpen) {
        fbAuthToken = FBSession.activeSession().accessTokenData.accessToken
        //manually overridden
        // added in because APP ID and secret aren't set to CurateAnalytics but are set to loginTest
        
//        fbAuthToken = "CAAKsfqnOlxMBAKsZC08WBPRpG8s8MOQx99kZAeb5TnvCtftPOFZCieBatdjSDuZAljZBHnNcgwE2DBa0Fh9gHUyHsHGKTGIoa8DzI9a82290GUBDbMSd26rIgnvytNUpThT3q1AFGOZCevZBMhVW9eydizPW0aPL9xPqu1DZAQiOMWNPR0PuGMYmL5ZBFRrAUCgN2iXzGd9qdugnbZAaYXveEThrZAnT5vW6aqsqziqqKFIywZDZD"
        
        return fbAuthToken
    } else {
        println("not logged into FB")
    }
    return "not logged into FB"
}