//
//  PersonaView.swift
//  Curate
//
//  Created by Linus Liang on 11/24/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//

import UIKit

class PersonaView: UIView {
    @IBOutlet weak var stylishPersona: UIButton!
    @IBOutlet weak var financePersona: UIButton!
    @IBOutlet weak var techPersona: UIButton!
    @IBOutlet weak var hipsterPersona: UIButton!
    @IBOutlet weak var financerLabel: UILabel!
    @IBOutlet weak var buttonLabelConstraint: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func drawDashedBorderAroundPersona(persona: UIButton, borderColor: UIColor, heightOffset: CGFloat) -> CALayer {
        
        let cornerRadius:CGFloat = 10
        let borderWidth:CGFloat = 2
        let dashPattern1: NSNumber = 8
        let dashPattern2: NSNumber = 8
        let pi: CGFloat = CGFloat(M_PI)
        let pi_2: CGFloat = CGFloat(M_PI_2)
        print("buttonLabelConstraint = \(buttonLabelConstraint)")
        let frameHeight: CGFloat = persona.frame.height + financerLabel.frame.height + buttonLabelConstraint.constant
        let frameWidth: CGFloat = persona.frame.width
        
        let frame = persona.frame
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
}
