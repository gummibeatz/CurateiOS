//
//  CarouselCompressedTableViewCell.swift
//  TestingCarouselView
//
//  Created by Linus Liang on 1/24/16.
//  Copyright © 2016 Linus Liang. All rights reserved.
//

import UIKit

protocol CarouselCompressedTableViewCellDelegate {
    func toggleDropdown(idx: Int)
}

class CarouselCompressedTableViewCell: UITableViewCell {
    
    var delegate: CarouselCompressedTableViewCellDelegate?
    
    @IBOutlet weak var dropDownArrow: UIImageView!{
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: "dropDownTapped:")
            dropDownArrow.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet weak var clothingCategoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func dropDownTapped(sender: UIImageView) {
        delegate?.toggleDropdown(self.tag)
    }
}
