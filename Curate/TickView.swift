//
//  TickView.swift
//  Curate
//
//  Created by Linus Liang on 11/27/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//


import UIKit
import Foundation


class TickView: UIView {
    
    @IBOutlet weak var measurementLabel: UILabel! {
        didSet {
            print("measurement label set")
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        print("in override init frame")
        print(measurementLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        if self.subviews.count == 0 {
            let bundle = NSBundle(forClass: self.dynamicType)
            let view = bundle.loadNibNamed("TickView", owner: nil, options: nil).first as! TickView
            view.translatesAutoresizingMaskIntoConstraints = false
            let constraints = self.constraints
            self.removeConstraints(constraints)
            view.addConstraints(constraints)
            return view
        }
        return self
    }
    
    override func drawRect(rect: CGRect) {
        let borderWidth: CGFloat = CGFloat(10)
        let startAngle = 5 * π / 8
        let endAngle = 3 * π / 8
        let circleCenter = CGPoint(x: rect.width/2, y: 4*rect.height/9)
        
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(CGPoint(x: rect.width/2, y: rect.height - borderWidth))
        path.addArcWithCenter(circleCenter, radius: rect.width/2 - borderWidth, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.closePath()
        path.lineWidth = borderWidth
        
        curateDarkGrey.setFill()
        curateBlue.setStroke()
        path.fill()
        path.stroke()
    }
}
