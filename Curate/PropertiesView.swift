//
//  PropertiesView.swift
//  OutfitBuilder
//
//  Created by Kenneth Kuo on 12/24/14.
//  Copyright (c) 2014 Kenneth Kuo. All rights reserved.
//

import UIKit

protocol PropertiesViewDelegate {
    func popoutViewWasTapped()
}

class PropertiesView: UIView {
    
    var popoutImageView: UIImageView = UIImageView()
    var delegate: PropertiesViewDelegate?
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        // ...
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        popoutImageView = UIImageView(frame: CGRectMake(20, 30, frame.width - 40, frame.height-60))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "wasTapped:")
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        self.addGestureRecognizer(tapGestureRecognizer)
        
        self.addSubview(popoutImageView)
        
    }
    
    func setupView() {
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 4
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSizeMake(1, 1)
    }
    
    func wasTapped(gestureRecognizer: UIGestureRecognizer) {
        var timeInterval: NSTimeInterval = 0.7
        var delay: NSTimeInterval = 0
        if(gestureRecognizer.state == UIGestureRecognizerState.Ended) {
            UIView.animateWithDuration(timeInterval, delay: delay, options: nil, animations: {
                UIView.performSystemAnimation(UISystemAnimation.Delete, onViews: [self], options: nil, animations: nil, completion: { animationFinished in
                    self.removeFromSuperview()
                    
                })
                }, completion: nil)
        }
        delegate?.popoutViewWasTapped()
    }
    
    
    
}
