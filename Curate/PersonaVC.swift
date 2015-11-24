//
//  PersonaVC.swift
//  Curate
//
//  Created by Curate on 8/5/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class PersonaVC: UIViewController {
    
    var personaTag:Int?
    var activeLayer: CALayer?
    
    let hipsterTag = 0
    let techTag = 1
    let stylishTag = 2
    let financeTag = 3
    
    let heightOffset: CGFloat = SCREENHEIGHT/7
    let personaWidth: CGFloat = SCREENWIDTH/2
    let personaHeight: CGFloat = SCREENHEIGHT/2 - SCREENHEIGHT/7
    let labelHeight: CGFloat = 50
    let viewFrames: CGRect = CGRect(x: 0, y: UIScreen.mainScreen().bounds.height/8, width: UIScreen.mainScreen().bounds.width, height: 7*UIScreen.mainScreen().bounds.height/8)
    
    lazy var personaView: PersonaView = {
       return NSBundle.mainBundle().loadNibNamed("PersonaView", owner: self, options: nil).last as! PersonaView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        personaView = NSBundle.mainBundle().loadNibNamed("PersonaView", owner: self, options: nil).last as! PersonaView
        setupBackground()
        personaView.frame = viewFrames
        self.view.addSubview(personaView)
        setupPersonaGestures()
    }
    
    func setupBackground() {
        let backgroundView = UIImageView(frame: self.view.bounds)
        backgroundView.image = UIImage(named: "personaViewBG")
        self.view.addSubview(backgroundView)
    }
    
    func setupPersonaGestures() {
        let hipsterGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "personaTapped:")
        personaView.hipsterPersona.addGestureRecognizer(hipsterGesture)
        let techGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "personaTapped:")
        personaView.techPersona.addGestureRecognizer(techGesture)
        let financeGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "personaTapped:")
        personaView.financePersona.addGestureRecognizer(financeGesture)
        let stylishGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "personaTapped:")
        personaView.stylishPersona.addGestureRecognizer(stylishGesture)
    }
    
    func personaTapped(sender: UIGestureRecognizer) {
        print("persona tapped")
        personaTag = sender.view!.tag
        print(sender.view!.frame.size)
        removeActiveLayer()
        drawDashedBorderAroundView(sender.view!)
    }
    
    func removeActiveLayer() {
        if activeLayer != nil {
            activeLayer!.removeFromSuperlayer()
        }
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
        shapeLayer.strokeColor = lineColor.CGColor
        shapeLayer.lineWidth = borderWidth
        shapeLayer.lineDashPattern = [dashPattern1, dashPattern2]
        shapeLayer.lineCap = kCALineCapRound
        
        activeLayer = shapeLayer
        self.view.layer.addSublayer(shapeLayer)
        view.layer.cornerRadius = cornerRadius
    }
}