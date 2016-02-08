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
    
    init() {
        self.scrollViewImage = UIImage()
        self.centerPieceImage = UIImage()
        self.viewLabelTitle = ""
        self.scrollViewPagesPerFrame = 0
        self.scrollViewTotalPages = 0
        self.startBuffer = 0
        self.endBuffer = 0
    }
    
    static func createHeightProperties() -> OnBoardingViewProperties {
        var properties = OnBoardingViewProperties()
        properties.scrollViewImage = UIImage(named: "HeightRulerFull")!
        properties.centerPieceImage = UIImage(named: "Little Man")!
        properties.viewLabelTitle = "What's your vertical?"
        properties.scrollViewPagesPerFrame = 11*17/3.0
        properties.scrollViewTotalPages = 11*17
        properties.startBuffer = 11*6 - 1
        properties.endBuffer = 11*6
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
        properties.endBuffer = 2
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
        properties.endBuffer = 2
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
        return properties
    }
}
