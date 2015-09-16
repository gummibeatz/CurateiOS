//
//  APICalls.swift
//  WardrobeBuilder
//
//  Created by Curate on 3/4/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

let baseURL: String = "http://curateanalytics.herokuapp.com"


// checks to see if user exists in nsuserdefaults, if not then
// takes in parameter of unique user curate Auth Token
// makes a request to curate website to retrieve and store user preferences
// in object User
/// NEEED TO MAKE EDIT TO CHECK IF USER ALREADY EXISTS AND OVERWRITE
func getUser(curateAuthToken: String, completionHandler:(currentUser:User) ->()) {
    println("in getUser")
    let url: NSURL = NSURL(string: baseURL + "/api/v1/user.json?authentication_token=\(curateAuthToken)")!
    println("going to \(url)")
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
        var error:NSError?
        if let userDict: NSMutableDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSMutableDictionary {
            
            
            println(curateAuthToken)
            println(userDict)
            var tempDict = NSMutableDictionary()
            println(userDict["preferences"])
            if var preferencesDict: NSMutableDictionary = userDict["preferences"] as? NSMutableDictionary {
        
            
                /// MUST TAKE THESE OUT LATER!!!!!!!!!
                ///
                ///
                println("preferencesDict = \(preferencesDict)")
                
                if let moc = managedObjectContext {
                    var user: User = User.createInManagedObjectContext(moc, preferences: preferencesDict)
                    println("user created and stored")
                    completionHandler(currentUser: user)
                }
                
            } else {
                println("no preferencesDict")
                tempDict.setValue("height", forKey: "height")
                tempDict.setValue("weight", forKey: "weight")
                tempDict.setValue("age", forKey: "age")
                tempDict.setValue("waist", forKey: "waist_size")
                tempDict.setValue("inseam", forKey: "inseam")
                tempDict.setValue("shirt size", forKey: "shirt_size")
                tempDict.setValue("preferred shirt fit", forKey: "preferred_shirt_fit")
                tempDict.setValue("preferred pants fit", forKey: "preferred_pants_fit")
                tempDict.setValue("shoe size", forKey: "shoe_size")
                if let moc = managedObjectContext {
                    var user: User = User.createInManagedObjectContext(moc, preferences: tempDict)
                    println("user created and stored")
                    completionHandler(currentUser: user)
                }
            }
            

        } else {
            println("Ruh roh authtoken isn't correct")
        }
    }
    task.resume()
}

// stores user properties in database
func postUser(curateAuthToken: String, preferencesDict: NSDictionary) {
    println("posting user")
    let request = NSMutableURLRequest(URL: NSURL(string: baseURL + "/api/v1/user/1/edit.json")!)
    request.HTTPMethod = "POST"
    var postDict = ["authentication_token":curateAuthToken, "preferences":preferencesDict] as NSDictionary
    println(postDict)
    println(NSJSONSerialization.dataWithJSONObject(postDict, options: NSJSONWritingOptions.PrettyPrinted, error: nil))

    
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(postDict, options: nil, error: nil)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
        println("posting userpreferences")
        println("response = \(response)")
        println("data = \(data)")
        println("error = \(error)")
    }
    task.resume()
}


//stores users wardrobe
func postWardrobe(curateAuthToken: String, wardrobeDict: NSDictionary) {
    println("posting wardrobe")
    let request = NSMutableURLRequest(URL: NSURL(string: baseURL + "/api/v1/wardrobe/1/edit.json")!)
    request.HTTPMethod = "POST"
    var postDict = ["authentication_token":curateAuthToken, "wardrobe":wardrobeDict] as NSDictionary
//    println(postDict)
//    println(NSJSONSerialization.dataWithJSONObject(postDict, options: NSJSONWritingOptions.PrettyPrinted, error: nil))
    
    
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(postDict, options: nil, error: nil)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
        println("posting wardrobe")
        println("response = \(response)")
//        println("data = \(data)")
        println("error = \(error)")
    }
    task.resume()
}

//returns the dictionary of swipeBatches as a completion handler
func getSwipeBatch(user: User, completionHandler:(swipeBatch:Array<Array<Clothing>>) ->()) {
    println("in getSwipeBatch")
    var swipeBatch  = chooseSwipeBatch(user)
    let batchURL = baseURL + "/api/v1/batch"
    println("going to" + batchURL)
    let request = NSMutableURLRequest(URL: NSURL(string: batchURL)!)
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
    println(imagePath)
    let url = NSURL(string: imagePath)
    let data = NSData(contentsOfURL: url!)
    return data!
}

// chooses and returns the batchID that corresponds to the user preferences
func chooseSwipeBatch(user:User) -> (id: Int, folder: String) {
    let preferredFit = (shirtFit: user.preferredShirtFit, pantsFit: user.preferredPantsFit)
    println(user.preferredShirtFit)
    println(user.preferredPantsFit)
    
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
    case let("Slim", "Regular"):
        return (7, "slim_shirt_regular_pant")
    case let("Slim", "Skinny"):
        return (8, "slim_shirt_skinny_pant")
    case let("Slim", "Slim"):
        return (9, "slim_shirt_slim_pant")
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
            let clothingDict: NSDictionary = batchArr[row][col] as! NSDictionary
            var clothing = Clothing(clothing: clothingDict)
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
    println("============== in getCurateAuthToken =========")
    let request = NSMutableURLRequest(URL: NSURL(string:  baseURL + "/api/v1/tokens.json")!)
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
//        println(response)
        var jsonResult:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as! NSDictionary
//        println(jsonResult)
        if let authentication_token: String = jsonResult["authentication_token"] as? String {
            println("curateAuthToken given")
            println("curateAuthToken = \(authentication_token)")
            completionHandler(curateAuthToken: authentication_token)
        } else {
            println("error no curate AuthToken")
        }
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

// user sends 2 properties of article to be matched. color and main category style
// receives dictionary with main category of original article and color pairings
func getMatches(curateAuthToken: String, base_clothing: String, completionHandler:(matchDict: NSDictionary) -> ()) {
    println("in getMatches")
    var fbase_clothing: String = base_clothing.stringByReplacingOccurrencesOfString("&", withString: "%26", options: NSStringCompareOptions.LiteralSearch, range: nil)
    
    getWeather({
        currentTemp in
        let url: NSURL = NSURL(string: baseURL + "/api/v1/matches?authentication_token=\(curateAuthToken)&&temperature=\(currentTemp)&&base_clothing=\(fbase_clothing)")!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
            var error: NSError?
            if let matchDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary {
                completionHandler(matchDict: matchDict)
            } else {
                let matchDict: NSDictionary = ["message":"error"]
                completionHandler(matchDict: matchDict)
            }
//            println("data = \(data)")
            println("response = \(response)")
            println("error = \(error)")
        }
        task.resume()
    })

    
}

