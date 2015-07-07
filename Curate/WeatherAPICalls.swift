//
//  WeatherAPICalls.swift
//  Curate
//
//  Created by Kenneth Kuo on 7/7/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

func getWeatherWithLocation(lat:CLLocationDegrees, lon:CLLocationDegrees, completionHandler:(currentTemp:Double) ->()) {
//    println("in getWeatherWithLocation")
    let APPID = "30a49d36fdfb3a4585e13f39e31feb4d"
    let url: NSURL = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=imperial")!
//    println("going to \(url)")
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
        var error:NSError?
        if let weatherDict: NSMutableDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSMutableDictionary {
            //            println(weatherDict)
            var currentTemp:Double = weatherDict.objectForKey("main")?.objectForKey("temp") as Double
            completionHandler(currentTemp: currentTemp)
        }
    }
    task.resume()
    
}