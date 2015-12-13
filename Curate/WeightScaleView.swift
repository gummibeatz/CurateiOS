//
//  WeightScaleView.swift
//  WheelControl
//
//  Created by Linus Liang on 12/6/15.
//  Copyright © 2015 Linus Liang. All rights reserved.
//

import UIKit
import Foundation

class WeightScaleView: UIView {
    
    var containerView: SpinningWheelView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainerView()
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupContainerView() {
        let length = min(self.frame.height, self.frame.width)
        containerView = SpinningWheelView(frame: CGRect(x: (self.frame.width - length) / 2, y: (self.frame.height - length) / 2, width: length, height: length),  numberOfSections: 3)
        containerView.backgroundColor = UIColor.clearColor()
        let panningGesture = UIPanGestureRecognizer(target: self, action: "rotate:")
        containerView.addGestureRecognizer(panningGesture)
        
        self.addSubview(containerView!)
    }
    
    func setupLabel() {
        let label = CircleLabel(frame: CGRect(x: 0, y: 0, width: containerView.bounds.width/2.5, height: containerView.bounds.height/2.5))
        label.center = containerView.center
        
        let attributes = [NSFontAttributeName : UIFont(name: "Arial-BoldMT", size: 24)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        let lbString = NSAttributedString(string: " lbs", attributes: attributes)
        let text = NSMutableAttributedString(string: "20", attributes: attributes)
        text.appendAttributedString(lbString)
        
        
        label.attributedText = text
        label.textAlignment = .Center
        label.backgroundColor = UIColor.clearColor()
        self.addSubview(label)
    }
    
    func rotate(sender: UIPanGestureRecognizer) {
        let velocity: CGPoint = sender.velocityInView(self)
        let location: CGPoint = sender.locationInView(self)
        let angle: CGFloat = getAngle(location: location, velocity: velocity)
        
        let t = CGAffineTransformRotate(containerView.transform, angle)
        containerView.transform = t
        if abs(angle) > 0.1 {
            finishRotation(angle)
            
        }
        print("rotating at speed \(angle)")
    }
    
    func getAngle(location location: CGPoint, velocity: CGPoint) -> CGFloat {
        //quadrant 1
        let angle: CGFloat = sqrt(velocity.x * velocity.x + velocity.y * velocity.y)/4500
        print(location)
        //calculate kth vector of cross product to indicate direction
        let containerCenter = self.convertPoint(containerView.center, fromView: containerView)
        let x = location.x - containerCenter.x
        let y = location.y - containerCenter.y
        print(containerView.center)
        print("x = \(x), y = \(y)")
        return (x * velocity.y - y * velocity.x > 0) ? angle : angle * -1
    }
    
    func finishRotation(xV: CGFloat) {
        UIView.animateWithDuration(0.7, delay: 0, options: [UIViewAnimationOptions.CurveEaseOut , UIViewAnimationOptions.AllowUserInteraction] , animations: {
            let t = CGAffineTransformRotate(self.containerView.transform, xV)
            self.containerView.transform = t
            }, completion: nil)
    }
    
}

