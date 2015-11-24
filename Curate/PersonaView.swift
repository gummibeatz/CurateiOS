//
//  PersonaView.swift
//  Curate
//
//  Created by Linus Liang on 11/24/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//

import UIKit

class PersonaView: UIView {
    @IBOutlet weak var stylishPersona: UIButton! {
        didSet {
//            print(stylishPersona.bounds)
//            print(stylishPersona.frame.size.height)
//            drawDashedBorderAroundView(stylishPersona)
            print(self.stylishPersona.frame.size.height)
        }
    }
    @IBOutlet weak var financePersona: UIButton!
    @IBOutlet weak var techPersona: UIButton!
    @IBOutlet weak var hipsterPersona: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //http://lukagabric.com/cashapelayer-example-round-corners-view-with-dashed-line-border/
    func drawDashedBorderAroundView(view:UIView) {
        print(view.frame)
        
        let cornerRadius:CGFloat = 10
        let borderWidth:CGFloat = 2
        let dashPattern1: NSNumber = 8
        let dashPattern2: NSNumber = 8
        let lineColor = UIColor(red: 97/255.0, green: 160/255.0, blue: 232/255.0, alpha: 1)
        let pi: CGFloat = CGFloat(M_PI)
        let pi_2: CGFloat = CGFloat(M_PI_2)
        let frameHeight: CGFloat = 200 + 55
        let frameWidth: CGFloat = 150
        
        
        let frame = view.frame
        let shapeLayer = CAShapeLayer()
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, view.frame.width, frameHeight - cornerRadius)
        CGPathAddLineToPoint(path, nil, view.frame.width, cornerRadius + view.frame.height )
        CGPathAddArc(path, nil, view.frame.width + cornerRadius, cornerRadius + view.frame.height, cornerRadius, pi, -pi_2, false)
        CGPathAddLineToPoint(path, nil, frameWidth - cornerRadius, view.frame.height)
        CGPathAddArc(path, nil, frameWidth - cornerRadius, cornerRadius + view.frame.height, cornerRadius, -pi_2, 0, false)
        CGPathAddLineToPoint(path, nil, frameWidth, frameHeight - cornerRadius)
        CGPathAddArc(path, nil, frameWidth - cornerRadius, frameHeight - cornerRadius , cornerRadius, 0, pi_2, false)
        CGPathAddLineToPoint(path, nil, view.frame.width + cornerRadius, frameHeight)
        CGPathAddArc(path, nil, view.frame.width + cornerRadius, frameHeight - cornerRadius, cornerRadius, pi_2, pi, false)
        shapeLayer.path = path
        
        shapeLayer.setValue(false, forKey: "isCircle")
        shapeLayer.backgroundColor = UIColor.clearColor().CGColor
        shapeLayer.frame = frame
        shapeLayer.masksToBounds = false
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = lineColor.CGColor
        shapeLayer.lineWidth = borderWidth
        shapeLayer.lineDashPattern = [dashPattern1, dashPattern2]
        shapeLayer.lineCap = kCALineCapRound
        
        view.layer.addSublayer(shapeLayer)
        view.layer.cornerRadius = cornerRadius
    }
}
