//
//  SpinningWheelView.swift
//  WheelControl
//
//  Created by Linus Liang on 12/6/15.
//  Copyright © 2015 Linus Liang. All rights reserved.
//

import Foundation
import UIKit

class SpinningWheelView: UIControl {
    
    init(frame: CGRect, numberOfSections: Int) {
        super.init(frame: frame)
        print("spinning wheel view frame is \(frame)")
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: min(frame.width, frame.height), height: min(frame.width,frame.height))
        imageView.center = CGPoint(x: frame.width/2, y: frame.height/2)
        imageView.image = UIImage(named: "WeightWheelFull")
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        print("drawRect rect = \(rect)")
        let borderWidth:CGFloat = 20
        
        let path = UIBezierPath()
        let center: CGPoint = CGPoint(x: rect.width/2, y: rect.height/2)
    
        path.moveToPoint(CGPoint(x: rect.width/2 - borderWidth, y: rect.height - borderWidth))
        path.addArcWithCenter(center, radius: min(rect.height/2, rect.width/2) - borderWidth, startAngle: 0, endAngle: 2 * π, clockwise: true)
        path.closePath()
        curateBlue.setStroke()
        UIColor.whiteColor().setFill()
        
        path.lineWidth = borderWidth
        
        path.stroke()
        path.fill()
        
        let lineMarkerPath = UIBezierPath()
        lineMarkerPath.moveToPoint(CGPoint(x: rect.width/2 - borderWidth, y: rect.height - borderWidth))
        lineMarkerPath.addLineToPoint(CGPoint(x: rect.width/2, y: rect.width/2))
            
        lineMarkerPath.stroke()
    }
}