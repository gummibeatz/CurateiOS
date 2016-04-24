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

struct WeatherAPI {
    private static let APPID = "96da09ef7487b3c3da75fdfa247b21fe"
    private static let baseURL = "http://api.openweathermap.org/data/2.5/weather?"
    
    static func getWeather(completionHandler:(currentTemp:Double) ->()) {
        print("in getWeatherWithLocation")
        let location = (UIApplication.sharedApplication().delegate as! AppDelegate).location
        let lat: CLLocationDegrees = location.coordinate.latitude
        let lon: CLLocationDegrees = location.coordinate.longitude
        let url: NSURL = NSURL(string: baseURL + "lat=\(lat)&lon=\(lon)&units=imperial&APPID=\(APPID)" )!
        print("going to \(url)")
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
            do {
                guard let weatherDict: NSMutableDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSMutableDictionary else {
                    throw APIErrors.DictError
                }
                    //            println(weatherDict)
                let currentTemp:Double = weatherDict.objectForKey("main")?.objectForKey("temp") as! Double
                completionHandler(currentTemp: currentTemp)
            } catch {
                print("bad weather")
            }
        }
        task.resume()
    }
}