//
//  OverlayView.swift
//  WardrobeBuilder
//
//  Created by Curate on 12/13/14.
//  Copyright (c) 2014 Curate. All rights reserved.
//

import UIKit

enum GGOverlayViewMode: Int {
    case Left
    case Right
    case Tap
}

class OverlayView: UIView {
    
    var imageView: UIImageView = UIImageView()
    var mode = GGOverlayViewMode?()
    
    required init?(coder aDecoder: (NSCoder!)) {
        super.init(coder: aDecoder)
        // ...
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        imageView = UIImageView(image: UIImage(named: "noButton"))
        dispatch_async(dispatch_get_main_queue(), {
            self.layoutSubviews()
            self.addSubview(self.imageView)
        })
        
    }
    
    func setMode(mode: GGOverlayViewMode) {
        
        if(mode == GGOverlayViewMode.Tap){
            imageView.image = UIImage(named: "haveButton")
        } else if(mode == GGOverlayViewMode.Right){
            imageView.image = UIImage(named: "yesButton")
        } else if(mode == GGOverlayViewMode.Left){
            imageView.image = UIImage(named: "noButton")
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRectMake(0, 0, 100, 100)
    }
}
