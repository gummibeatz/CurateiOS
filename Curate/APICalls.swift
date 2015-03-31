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
            var preferencesDict: NSDictionary = userDict["preferences"] as NSDictionary
            
            
            /// MUST TAKE THESE OUT LATER!!!!!!!!!
            ///
            ///
            preferencesDict.setValue("9", forKey: "age")
            preferencesDict.setValue("Extra Slim", forKey: "preferred_shirt_fit")
            preferencesDict.setValue("Regular", forKey: "preferred_pants_fit")
            
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

//returns the dictionary of swipeBatches.
func getSwipeBatch(user: User, completionHandler:(swipeBatch:[[String]]) ->()) {
    var swipeBatch  = chooseSwipeBatch(user)
    println("going to http://curateanalytics.herokuapp.com/api/v1/user.json/\(swipeBatch.id)")
    let request = NSMutableURLRequest(URL: NSURL(string: "http://curateanalytics.herokuapp.com/api/v1/batch/\(swipeBatch.id)")!)
    request.HTTPMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    println("just before task")
    
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
        var error: NSError?
        if let batchDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary {
            
            // hard coded in should make a function to create this string
            // auto make the extra_slim_shirt_regular_pant part
            
            
            completionHandler(swipeBatch: formatSwipeBatch(batchDict.objectForKey("folder")?.objectForKey(swipeBatch.folder) as NSDictionary))
        }
        
    }
    task.resume()
}

func getImage(imagePath: String) -> NSData {
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

//formats swipeBatches into a 2D array with row number corresponding to batch number
func formatSwipeBatch(batchDict: NSDictionary) -> [[String]] {
    var batches = Array<Array<String>>()
    for var row = 0; row < 18; row++ {
        if row < 9 {
            
            let filename:[String] = batchDict.objectForKey("batch_0\(row+1)")!.objectForKey("filenames")! as [String]
            batches.append(filename)

        } else {
            let filename:[String] = batchDict.objectForKey("batch_\(row+1)")!.objectForKey("filenames")! as [String]
            batches.append(filename)
        }
    }
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
        var jsonResult:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as NSDictionary
        
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
func getFbAuthToken(authTokens: Tokens) {
    var fbAuthToken = String()
    if (FBSession.activeSession().isOpen) {
        fbAuthToken = FBSession.activeSession().accessTokenData.accessToken
        //manually overridden
        // added in because APP ID and secret aren't set to CurateAnalytics but are set to loginTest
        fbAuthToken = "CAAKsfqnOlxMBAKsZC08WBPRpG8s8MOQx99kZAeb5TnvCtftPOFZCieBatdjSDuZAljZBHnNcgwE2DBa0Fh9gHUyHsHGKTGIoa8DzI9a82290GUBDbMSd26rIgnvytNUpThT3q1AFGOZCevZBMhVW9eydizPW0aPL9xPqu1DZAQiOMWNPR0PuGMYmL5ZBFRrAUCgN2iXzGd9qdugnbZAaYXveEThrZAnT5vW6aqsqziqqKFIywZDZD"
        
        authTokens.fbAuthToken = fbAuthToken
        
    } else {
        println("not logged into FB")
    }
}