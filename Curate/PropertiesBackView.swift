//
//  PropertiesBackView.swift
//  OutfitBuilder
//
//  Created by Kenneth Kuo on 1/2/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import UIKit

class PropertiesBackView: UIView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // ...
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        var image: UIImage = UIImage(named: "notAvailable")!
        image = RBResizeImage(image, CGSize(width: frame.width, height: frame.height))
        var imageView: UIImageView = UIImageView(image: image)
        self.addSubview(imageView)
    }
    
    func setupView() {
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 4
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSizeMake(1, 1)
    }
}
