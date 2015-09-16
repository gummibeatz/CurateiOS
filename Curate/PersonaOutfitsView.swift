//
//  PersonaOutfitsView.swift
//  Curate
//
//  Created by Linus Liang on 9/10/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import Foundation

class PersonaOutfitsView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        var personaLabel: UILabel = UILabel(frame: CGRect(x: 10, y: 0, width: self.frame.width, height: 100))
        personaLabel.text = "Alright, now that we've got that shit out of the way, let's go to the fun part. Tell me if you have any of these outfits. Once you're done, tap my face, or if you want to skip this. You can always enter it in later."
        personaLabel.lineBreakMode = .ByWordWrapping
        personaLabel.numberOfLines = 0
        personaLabel.font = UIFont(name: personaLabel.font.fontName, size: 14)
        
        let outfitHeightOffset = personaLabel.frame.height
        let outfitWidth = (self.frame.width-30)/3
        
        var outfit1: UIImageView = UIImageView(frame: CGRect(x: 10, y: outfitHeightOffset, width: outfitWidth, height: self.frame.height - outfitHeightOffset - 20))
        outfit1.backgroundColor = UIColor.blueColor()
        
        var outfit2: UIImageView = UIImageView(frame: CGRect(x: 10+outfitWidth, y: outfitHeightOffset, width: outfitWidth, height: self.frame.height - outfitHeightOffset - 20))
        outfit2.backgroundColor = UIColor.blackColor()
        
        var outfit3: UIImageView = UIImageView(frame: CGRect(x: 10+outfitWidth*2, y: outfitHeightOffset, width: outfitWidth, height: self.frame.height - outfitHeightOffset - 20))
        outfit3.backgroundColor = UIColor.blueColor()
        
        self.addSubview(personaLabel)
        self.addSubview(outfit1)
        self.addSubview(outfit2)
        self.addSubview(outfit3 )
    }
    
    
    
}