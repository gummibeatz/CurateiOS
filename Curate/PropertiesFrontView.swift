//
//  PropertiesView.swift
//  OutfitBuilder
//
//  Created by Kenneth Kuo on 12/24/14.
//  Copyright (c) 2014 Kenneth Kuo. All rights reserved.
//

import UIKit

class PropertiesFrontView: UIView {
    
    var popoutImageView: UIImageView = UIImageView()
    
    required init(coder aDecoder: (NSCoder!)) {
        super.init(coder: aDecoder)
        // ...
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        popoutImageView = UIImageView(frame: CGRectMake(20, 30, frame.width - 40, frame.height-60))
        self.addSubview(popoutImageView)
    }
    
    func setupView() {
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 4
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSizeMake(1, 1)
    }
}
