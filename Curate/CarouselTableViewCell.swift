//
//  CarouselTableViewCell.swift
//  TestingCarouselView
//
//  Created by Linus Liang on 1/24/16.
//  Copyright © 2016 Linus Liang. All rights reserved.
//

import UIKit
import iCarousel

protocol CarouselTableViewCellDelegate {
    func toggleDropdown(idx: Int)
}

class CarouselTableViewCell: UITableViewCell, iCarouselDataSource, iCarouselDelegate {
    
    @IBOutlet weak var carousel: iCarousel! {
        didSet{
            carousel.backgroundColor = UIColor.whiteColor()
            carousel.perspective = -0.002
        }
    }
    
    var items = [Clothing]()
    var delegate: CarouselTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.whiteColor()
        
        setupCarousel()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupCarousel() {
        carousel.type = .Rotary
        carousel.delegate = self
        carousel.dataSource = self
    }
    
    func dropDownTapped(sender: UIImageView) {
        delegate?.toggleDropdown(self.tag)
    }
    
    // MARK: - iCarousel Data Source
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        print("number of items in carousel = \(items.count)")
        return items.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        var itemView: UIImageView
        //create new view if no view is available for recycling
        if (view == nil) {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            itemView = UIImageView(frame:CGRect(x:0, y:0, width:20, height:20))
            itemView.contentMode = .Center
            
        } else {
            //get a reference to the label in the recycled view
            itemView = view as! UIImageView;
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        itemView.clipsToBounds = true
        itemView.contentMode = .ScaleAspectFit
        itemView.image = UIImage(data: items[index].imageData!)
        itemView.frame = CGRect(x:0, y:0, width:100, height:100)
        //        itemView.layer.borderColor = UIColor(red: 166.0/255, green: 206.0/255, blue: 253.0/255, alpha: 1.0).CGColor
        itemView.layer.borderColor = UIColor.blackColor().CGColor
        return itemView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        
        if (option == .VisibleItems)
        {
            return 5
        }
        return value
    }
    
    // MARK: - iCarousel Delegate
    func carouselDidEndScrollingAnimation(carousel: iCarousel) {
        let idx = carousel.currentItemIndex
        carousel.itemViewAtIndex(idx)?.layer.borderWidth = 1.0
    }
    
    func carouselWillBeginDragging(carousel: iCarousel) {
        let idx = carousel.currentItemIndex
        carousel.itemViewAtIndex(idx)?.layer.borderWidth = 0
    }
}
