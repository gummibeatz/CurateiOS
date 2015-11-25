//
//  CustomDraw.swift
//  Curate
//
//  Created by Linus Liang on 11/25/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//

import Foundation
import UIKit

    //http://lukagabric.com/cashapelayer-example-round-corners-view-with-dashed-line-border/
func createDashedBorderAroundView(view:UIView, heightOffset: CGFloat, borderColor: UIColor) -> CAShapeLayer {
        print(view.frame)
        
        let cornerRadius:CGFloat = 10
        let borderWidth:CGFloat = 2
        let dashPattern1: NSNumber = 8
        let dashPattern2: NSNumber = 8
        let pi: CGFloat = CGFloat(M_PI)
        let pi_2: CGFloat = CGFloat(M_PI_2)
        let frameHeight: CGFloat = 200 + 35
        let frameWidth: CGFloat = 150
        
        let frame = view.frame
        let shapeLayer = CAShapeLayer()
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0 , heightOffset + frameHeight - cornerRadius)
        CGPathAddLineToPoint(path, nil, 0, heightOffset + cornerRadius)
        CGPathAddArc(path, nil, cornerRadius, heightOffset + cornerRadius , cornerRadius, pi, -pi_2, false)
        CGPathAddLineToPoint(path, nil, frameWidth - cornerRadius, heightOffset)
        CGPathAddArc(path, nil, frameWidth - cornerRadius, heightOffset + cornerRadius, cornerRadius, -pi_2, 0, false)
        CGPathAddLineToPoint(path, nil, frameWidth, heightOffset + frameHeight - cornerRadius)
        CGPathAddArc(path, nil, frameWidth - cornerRadius, heightOffset + frameHeight - cornerRadius , cornerRadius, 0, pi_2, false)
        CGPathAddLineToPoint(path, nil, cornerRadius, heightOffset + frameHeight)
        CGPathAddArc(path, nil, cornerRadius, heightOffset + frameHeight - cornerRadius, cornerRadius, pi_2, pi, false)
        shapeLayer.path = path
        
        shapeLayer.setValue(false, forKey: "isCircle")
        shapeLayer.backgroundColor = UIColor.clearColor().CGColor
        shapeLayer.frame = frame
        shapeLayer.masksToBounds = false
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = borderColor.CGColor
        shapeLayer.lineWidth = borderWidth
        shapeLayer.lineDashPattern = [dashPattern1, dashPattern2]
        shapeLayer.lineCap = kCALineCapRound
    
        return shapeLayer
    }