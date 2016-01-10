//
//  circleLabel.swift
//  WheelControl
//
//  Created by Linus Liang on 12/12/15.
//  Copyright © 2015 Linus Liang. All rights reserved.
//

import UIKit

class CircleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        let offset: CGFloat = 30
        let borderWidth: CGFloat = 1
        let centerPoint = CGPoint(x: rect.width/2, y: rect.height/2)
        let outerPath = UIBezierPath(arcCenter: centerPoint, radius: rect.width / 2 - borderWidth, startAngle: 0, endAngle: 2 * π, clockwise: true)
        let innerPath = UIBezierPath(arcCenter: centerPoint, radius: rect.width / 2 - borderWidth - offset, startAngle: 0, endAngle: 2 * π, clockwise: true)
        UIColor.curateBlueColor().setFill()
        UIColor.curateBlueColor().setStroke()
        outerPath.stroke()
        outerPath.fill()
        UIColor.blackColor().setStroke()
        UIColor.curateDarkGrayColor().setFill()
        innerPath.stroke()
        innerPath.fill()
        super.drawRect(rect)
    }

}
