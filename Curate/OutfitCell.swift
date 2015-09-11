//
//  OutfitCell.swift
//  Outfits
//
//  Created by Curate on 1/6/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import UIKit

class OutfitCell: UITableViewCell {
    
    //change magic number constants at some point
    
    //    var outfitImage: UIImageView?
    var outfitImage = UIImageView(frame:CGRect(x: 20, y: 0, width: 50, height: 40))
    var outfitName = UILabel(frame: CGRect(x: 20
        , y: 10, width: 200, height: 40))
    var img: UIImage?
    var outfit: Outfit?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//                outfitImage.backgroundColor = UIColor.blueColor()
        //        outfitImage?.frame = CGRect(x: 4, y: 3, width: 40, height: 36)
        self.selectionStyle = UITableViewCellSelectionStyle.Default
        self.addSubview(outfitName)
//        self.addSubview(outfitImage)
    }
    
    
    override func layoutSubviews() {
        
    }
}
