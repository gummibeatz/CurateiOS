//
//  WeatherAPICalls.swift
//  Curate
//
//  Created by Curate on 7/7/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

func getWeather(completionHandler:(currentTemp:Double) ->()) {
//    println("in getWeatherWithLocation")
    let APPID = "30a49d36fdfb3a4585e13f39e31feb4d"
    let location = (UIApplication.sharedApplication().delegate as! AppDelegate).location
    let lat: CLLocationDegrees = location.coordinate.latitude
    let lon: CLLocationDegrees = location.coordinate.longitude
    let url: NSURL = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=imperial")!
//    println("going to \(url)")
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
        var error:NSError?
        if let weatherDict: NSMutableDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSMutableDictionary {
            //            println(weatherDict)
            var currentTemp:Double = weatherDict.objectForKey("main")?.objectForKey("temp") as! Double
            completionHandler(currentTemp: currentTemp)
        }
    }
    task.resume()
    
}