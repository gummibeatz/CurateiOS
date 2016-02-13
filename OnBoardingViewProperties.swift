//
//  OnBoardingViewProperties.swift
//  Curate
//
//  Created by Linus Liang on 1/31/16.
//  Copyright © 2016 Kenneth Kuo. All rights reserved.
//

import Foundation
import UIKit

struct OnBoardingViewProperties {
    var scrollViewImage: UIImage
    var centerPieceImage: UIImage
    var viewLabelTitle: String
    var scrollViewPagesPerFrame: CGFloat
    var scrollViewTotalPages: CGFloat
    var startBuffer: CGFloat
    var endBuffer: CGFloat
    var tickLabels: [String]
    
    init() {
        self.scrollViewImage = UIImage()
        self.centerPieceImage = UIImage()
        self.viewLabelTitle = ""
        self.scrollViewPagesPerFrame = 0
        self.scrollViewTotalPages = 0
        self.startBuffer = 0
        self.endBuffer = 0
        self.tickLabels = [String]()
    }
    
    static func createHeightProperties() -> OnBoardingViewProperties {
        var properties = OnBoardingViewProperties()
        properties.scrollViewImage = UIImage(named: "HeightRulerFull")!
        properties.centerPieceImage = UIImage(named: "Little Man")!
        properties.viewLabelTitle = "What's your vertical?"
        properties.scrollViewPagesPerFrame = 12*17/3.0
        properties.scrollViewTotalPages = 12*17
        properties.startBuffer = 12*7 - 5
        properties.endBuffer = 12*7 + 1
        properties.tickLabels = ["3'8\"", "3'9\"", "3'10\"", "3'11\"",
                    "4'0\"", "4'1\"","4'2\"","4'3\"","4'4\"","4'5\"",
                    "4'6\"","4'7\"","4'8\"","4'9\"","4'10\"","4'11\"",
                    "5'0\"","5'1\"","5'2\"","5'3\"","5'4\"","5'5\"",
                    "5'6\"","5'7\"","5'8\"","5'9\"","5'10\"","5'11\"",
                    "6'0\"","6'1\"","6'2\"","6'3\"","6'4\"","6'5\"",
                    "6'6\"","6'7\"","6'8\"","6'9\"","6'10\"","6'11\"","7'0\""
                    ]
        return properties
    }
    
    static func createFeetSizeProperties() -> OnBoardingViewProperties {
        var properties = OnBoardingViewProperties()
        properties.scrollViewImage = UIImage(named: "FeetSizeRulerFull")!
        properties.centerPieceImage = UIImage(named: "Shoe Thing")!
        properties.viewLabelTitle = "How big are your feet?"
        properties.scrollViewPagesPerFrame = 34/3.0
        properties.scrollViewTotalPages = 34
        properties.startBuffer = 5
        properties.endBuffer = 4
        properties.tickLabels = ["6", "6.5", "7", "7.5", "8", "8.5", "9", "9.5", "10", "10.5", "11", "11.5", "12", "12.5", "13", "13.5", "14", "14.5", "15", "15.5","16","16.5","17","17.5","18"]
        return properties
    }
    
    static func createShirtFitProperties() -> OnBoardingViewProperties {
        var properties = OnBoardingViewProperties()
        properties.scrollViewImage = UIImage(named: "ShirtFitRulerFull")!
        properties.centerPieceImage = UIImage(named: "Shirt Fit")!
        properties.viewLabelTitle = "What's your shirt fit?"
        properties.scrollViewPagesPerFrame = 17/3.0
        properties.scrollViewTotalPages = 17
        properties.startBuffer = 5
        properties.endBuffer = 8
        properties.tickLabels = ["Tailored", "Slim","Regular", "Loose"]
        return properties
    }
    
    static func createShirtSizeProperties() -> OnBoardingViewProperties {
        var properties = OnBoardingViewProperties()
        properties.scrollViewImage = UIImage(named: "ShirtSizeRulerFull")!
        properties.centerPieceImage = UIImage(named: "Pants Waist")!
        properties.viewLabelTitle = "What's your shirt size?"
        properties.scrollViewPagesPerFrame = 17/3.0
        properties.scrollViewTotalPages = 17
        properties.startBuffer = 5
        properties.endBuffer = 7
        properties.tickLabels = ["XS", "S", "M", "L", "XL"]
        return properties
    }
    
    static func createWaistSizeProperties() -> OnBoardingViewProperties {
        var properties = OnBoardingViewProperties()
        properties.scrollViewImage = UIImage(named: "InseamRulerFull")!
        properties.centerPieceImage = UIImage(named: "Pants Inseam")!
        properties.viewLabelTitle = "What's your waist size?"
        properties.scrollViewPagesPerFrame = 17/3.0
        properties.scrollViewTotalPages = 17
        properties.startBuffer = 2
        properties.endBuffer = 3
        properties.tickLabels = ["28","29","30", "31", "32", "33", "34","35","36","37","38","39"]
        return properties
    }
    
    static func createInseamProperties() -> OnBoardingViewProperties {
        var properties = OnBoardingViewProperties()
        properties.scrollViewImage = UIImage(named: "InseamRulerFull")!
        properties.centerPieceImage = UIImage(named: "Little Man")!
        properties.viewLabelTitle = "How do you fit in them jeans?"
        properties.scrollViewPagesPerFrame = 17/3.0
        properties.scrollViewTotalPages = 17
        properties.startBuffer = 2
        properties.endBuffer = 3
        properties.tickLabels = ["28","29","30", "31", "32", "33", "34","35","36","37","38","39"]
        return properties
    }
    
    static func createPantsFitProperties() -> OnBoardingViewProperties {
        var properties = OnBoardingViewProperties()
        properties.scrollViewImage = UIImage(named: "PantsFitRulerFull")!
        properties.centerPieceImage = UIImage(named: "Pant Fit")!
        properties.viewLabelTitle = "How do you like your fit?"
        properties.scrollViewPagesPerFrame = 17/3.0
        properties.scrollViewTotalPages = 17
        properties.startBuffer = 5
        properties.endBuffer = 8
        properties.tickLabels = ["Skinny", "Slim", "Regular", "Loose"]
        return properties
    }
}
