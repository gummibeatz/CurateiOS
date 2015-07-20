//
//  OutfitView.swift
//  Curate
//
//  Created by Kenneth Kuo on 7/19/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation
import UIKit

class OutfitView: UIView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // ...
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, outfit: Outfit) {
        super.init(frame: frame)
        setupLayout()
    }
    
    func setupLayout() {
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 4
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSizeMake(1, 1)
    }
    
}