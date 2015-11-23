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

//let baseURL: String = "http://localhost:3000"
let baseURL: String = "http://curateanalytics.herokuapp.com"

enum APIErrors: ErrorType {
    case NetworkError
    case DictError
}

// checks to see if user exists in nsuserdefaults, if not then
// takes in parameter of unique user curate Auth Token
// makes a request to cudrate website to retrieve and store user preferences
// in object User
/// NEEED TO MAKE EDIT TO CHECK IF USER ALREADY EXISTS AND OVERWRITE
func getUser(curateAuthToken: String, completionHandler:(currentUser:User) ->()) {
    print("in getUser")
    let url: NSURL = NSURL(string: baseURL + "/api/v1/user.json?authentication_token=\(curateAuthToken)")!
    print("going to \(url)")
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
        do {
            guard let userDict: NSMutableDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSMutableDictionary else {
                throw APIErrors.NetworkError
            }
            print(curateAuthToken)
            print(userDict)
            let tempDict = NSMutableDictionary()
            print(userDict["preferences"])
            if let preferencesDict: NSMutableDictionary = userDict["preferences"] as? NSMutableDictionary {
                
                
                /// MUST TAKE THESE OUT LATER!!!!!!!!!
                ///
                ///
                print("preferencesDict = \(preferencesDict)")
                
                if let moc = managedObjectContext {
                    let user: User = User.createInManagedObjectContext(moc, preferences: preferencesDict)
                    print("user created and stored")
                    completionHandler(currentUser: user)
                }
                
            } else {
                print("no preferencesDict")
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
                    let user: User = User.createInManagedObjectContext(moc, preferences: tempDict)
                    print("user created and stored")
                    completionHandler(currentUser: user)
                }
            }
        } catch {
            
        }
        
    }
    task.resume()
}

// stores user properties in database
func postUser(curateAuthToken: String, preferencesDict: NSDictionary) {
    print("posting user")
    let request = NSMutableURLRequest(URL: NSURL(string: baseURL + "/api/v1/user/1/edit.json")!)
    request.HTTPMethod = "POST"
    let postDict = ["authentication_token":curateAuthToken, "preferences":preferencesDict] as NSDictionary
    print(postDict)
    do {
        guard let json: NSData = try NSJSONSerialization.dataWithJSONObject(postDict, options: NSJSONWritingOptions.PrettyPrinted) else {
            throw APIErrors.DictError
        }
        print(json)
        request.HTTPBody = json
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
            print("posting userpreferences")
            print("response = \(response)")
            print("data = \(data)")
            print("error = \(error)")
        }
        task.resume()
    } catch {
        print("json not serialized")
    }
}


//stores users wardrobe
func postWardrobe(curateAuthToken: String, wardrobeDict: NSDictionary) {
    print("posting wardrobe")
    let request = NSMutableURLRequest(URL: NSURL(string: baseURL + "/api/v1/wardrobe/1/edit.json")!)
    request.HTTPMethod = "POST"
    let postDict = ["authentication_token":curateAuthToken, "wardrobe":wardrobeDict] as NSDictionary
//    println(postDict)
//    println(NSJSONSerialization.dataWithJSONObject(postDict, options: NSJSONWritingOptions.PrettyPrinted, error: nil))
    
    do {
        guard let json:NSData = try NSJSONSerialization.dataWithJSONObject(postDict, options: NSJSONWritingOptions.PrettyPrinted) else {
            throw APIErrors.DictError
        }
        request.HTTPBody = json
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
            print("posting wardrobe")
            print("response = \(response)")
    //        println("data = \(data)")
            print("error = \(error)")
        }
        task.resume()
    } catch {
        print("json error not serializaed")
    }
}

//returns the dictionary of swipeBatches as a completion handler
func getSwipeBatch(user: User, completionHandler:(swipeBatch:Array<Array<Clothing>>) ->()) {
    print("in getSwipeBatch")
    let batchURL = baseURL + "/api/v1/batch"
    print("going to" + batchURL)
    let request = NSMutableURLRequest(URL: NSURL(string: batchURL)!)
    request.HTTPMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    print("just before task in getSwipeBatch")
    
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
        do {
            guard let batchArr: Array<Array<AnyObject>> = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? Array<Array<AnyObject>> else {
                throw APIErrors.DictError
            }
            // hard coded in should make a function to create this string
            // auto make the extra_slim_shirt_regular_pant part
            
            print("before completion handler in getswipebatch")
            //            println(batchDict.objectForKey("folder")?.objectForKey(swipeBatch.folder) as Array<Array<NSDictionary>> )
            completionHandler(swipeBatch: formatSwipeBatch(batchArr))
            print("after completion handler in get swipebatch")
        } catch {
            
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
    print(imagePath)
    let url = NSURL(string: imagePath)
    let data = NSData(contentsOfURL: url!)
    return data!
}

// chooses and returns the batchID that corresponds to the user preferences
func chooseSwipeBatch(user:User) -> (id: Int, folder: String) {
    let preferredFit = (shirtFit: user.preferredShirtFit, pantsFit: user.preferredPantsFit)
    print(user.preferredShirtFit)
    print(user.preferredPantsFit)
    
    switch preferredFit {
    case ("Extra Slim", "Regular"):
        return (1, "extra_slim_shirt_regular_pant")
    case ("Extra Slim", "Skinny"):
        return (2, "extra_slim_shirt_skinny_pant")
    case ("Extra Slim", "Slim"):
        return (3, "extra_slim_shirt_slim_pant")
    case ("Regular", "Regular"):
        return (4, "regular_shirt_regular_pant")
    case ("Regular", "Skinny"):
        return (5, "regular_shirt_skinny_pant")
    case ("Regular", "Slim"):
        return (6, "regular_shirt_slim_pant")
    case ("Slim", "Regular"):
        return (7, "slim_shirt_regular_pant")
    case ("Slim", "Skinny"):
        return (8, "slim_shirt_skinny_pant")
    case ("Slim", "Slim"):
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
    print("in formatSwipeBatch")
    var batches: Array<Array<Clothing>> = Array<Array<Clothing>>()
    var batchRow: Array<Clothing> = Array<Clothing>()
    for var row = 0; row < batchArr.count; row++ {
        batchRow.removeAll(keepCapacity: false)
        for var col = 0; col < (batchArr[row]).count; col++ {
            let clothingDict: NSDictionary = batchArr[row][col] as! NSDictionary
            let clothing = Clothing(clothing: clothingDict)
            batchRow.append(clothing)
        }
        batches.append(batchRow)
    }
    print("finished formatting swipebatch")
    print("number of batch rows = \(batches.count)")
    print("number of batch col for first row = \(batches[1].count)")
    return batches
}

func hasUser(user: String) -> Bool {
    let fetchRequest = NSFetchRequest(entityName: user)
    let count = managedObjectContext?.countForFetchRequest(fetchRequest, error: nil)
    print("count with name, \(user) = \(count)")
    return (count != 0) ? true:false
}


// takes in parameter of user unique fbAuthToken and makes a request to curate website
// to get curate specific auth token
// saves curate auth token into field Tokens.curateAuthToken
func getCurateAuthToken(fbAuthToken: String,completionHandler:(curateAuthToken:String) ->()) {
    // setting up request
    print("============== in getCurateAuthToken =========")
    let request = NSMutableURLRequest(URL: NSURL(string:  baseURL + "/api/v1/tokens.json")!)
    request.HTTPMethod = "POST"
    let postDict = ["token":fbAuthToken] as Dictionary<String, String>
    
    do {
        guard let json: NSData = try NSJSONSerialization.dataWithJSONObject(postDict, options: .PrettyPrinted) else {
            throw APIErrors.DictError
        }
        request.HTTPBody = json
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let finalRequest: NSURLRequest = request
        //performing the request
        let task = NSURLSession.sharedSession().dataTaskWithRequest(finalRequest) {(data, response, error) in
            print("error=\(error)")
            do {
                guard let jsonResult:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary  else {
                    throw APIErrors.DictError
                }
                
                if let authentication_token: String = jsonResult["authentication_token"] as? String {
                    print("curateAuthToken given")
                    print("curateAuthToken = \(authentication_token)")
                    completionHandler(curateAuthToken: authentication_token)
                } else {
                    print("error no curateAuthToken given")
                }
            } catch {
                print(" task error")
            }

        }
        task.resume()
    } catch {
        
    }
}

// accesses FB API and
// gets fbAuthToken and stores it into the field Tokens.fbAuthToken
/*
func getFbAuthToken() -> String {
    var fbAuthToken = String()
    if (FBSession.activeSession().isOpen) {
        fbAuthToken = FBSession.activeSession().accessTokenData.accessToken
        //manually overridden
        // added in because APP ID and secret aren't set to CurateAnalytics but are set to loginTest
        
//        fbAuthToken = "CAAKsfqnOlxMBAKsZC08WBPRpG8s8MOQx99kZAeb5TnvCtftPOFZCieBatdjSDuZAljZBHnNcgwE2DBa0Fh9gHUyHsHGKTGIoa8DzI9a82290GUBDbMSd26rIgnvytNUpThT3q1AFGOZCevZBMhVW9eydizPW0aPL9xPqu1DZAQiOMWNPR0PuGMYmL5ZBFRrAUCgN2iXzGd9qdugnbZAaYXveEThrZAnT5vW6aqsqziqqKFIywZDZD"
        
        return fbAuthToken
    } else {
        print("not logged into FB")
    }
    return "not logged into FB"
}
*/

// user sends 2 properties of article to be matched. color and main category style
// receives dictionary with main category of original article and color pairings
func getMatches(curateAuthToken: String, base_clothing: String, completionHandler:(matchDict: NSDictionary) -> ()) {
    print("in getMatches")
    let fbase_clothing: String = base_clothing.stringByReplacingOccurrencesOfString("&", withString: "%26", options: NSStringCompareOptions.LiteralSearch, range: nil)
    
    getWeather({
        currentTemp in
        let url: NSURL = NSURL(string: baseURL + "/api/v1/matches?authentication_token=\(curateAuthToken)&&temperature=\(currentTemp)&&base_clothing=\(fbase_clothing)")!
        print(url)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
            do {
                guard let matchDict: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary else {
                    throw APIErrors.DictError
                }
                completionHandler(matchDict: matchDict)
                print("response = \(response)")
                print("error = \(error)")
                
            } catch {
                let matchDict: NSDictionary = ["message":"error"]
                completionHandler(matchDict: matchDict)
            }

        }
        task.resume()
    })

    
}

