//
//  onBoardingView.swift
//  Curate
//
//  Created by Linus Liang on 11/25/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//

import Foundation
import UIKit

class OnBoardingView: UIView {
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var blueLine: UIView! {
        didSet {
            blueLine.backgroundColor = UIColor.curateBlueColor()
            blueLine.layer.shadowOffset = CGSize(width: 1, height: 1)
            blueLine.layer.shadowColor = UIColor.darkGrayColor().CGColor
            blueLine.layer.shadowOpacity = 1.0
        }
    }
    
    @IBOutlet weak var flexiblePagingScrollView: FlexiblePagingScrollView!{
        didSet{
            flexiblePagingScrollView.scrollView.delegate = self
            flexiblePagingScrollView.scrollView.decelerationRate = UIScrollViewDecelerationRateFast
            flexiblePagingScrollView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    @IBOutlet weak var tickView: TickView!
    
    var pagingIdx: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setScrollViewImage(image: UIImage) {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0,y: 0), size: flexiblePagingScrollView.scrollView.contentSize))
        imageView.image = image
        flexiblePagingScrollView.scrollView.addSubview(imageView)
    }
    
    func setInitialTickViewText() {
        switch self.tag {
        case 1:
            //height
            tickView.measurementLabel.text = heights[pagingIdx]
        case 2:
            //feet
            tickView.measurementLabel.text = feetSizes[pagingIdx]
        case 3:
            //shirt fit
            tickView.measurementLabel.text = shirtFits[pagingIdx]
        case 4:
            //shirt sizes
            tickView.measurementLabel.text = shirtSizes[pagingIdx]
        case 5:
            //waist sizes
            tickView.measurementLabel.text = waistSizes[pagingIdx]
        case 6:
            //inseam sizes
            tickView.measurementLabel.text = inseamSizes[pagingIdx]
        case 7:
            //pant sizes
            tickView.measurementLabel.text = pantSizes[pagingIdx]
        default:
            tickView.measurementLabel.text = String(pagingIdx)
        }
    }

    func setupScrollView(pages pages: Int) {
        flexiblePagingScrollView.pages = pages
    }
    
    //MARK - tickView Arrays
    let heights = ["3'8\"", "3'9\"", "3'10\"", "3'11\"",
                    "4'0\"", "4'1\"","4'2\"","4'3\"","4'4\"","4'5\"",
                    "4'6\"","4'7\"","4'8\"","4'9\"","4'10\"","4'11\"",
                    "5'0\"","5'1\"","5'2\"","5'3\"","5'4\"","5'5\"",
                    "5'6\"","5'7\"","5'8\"","5'9\"","5'10\"","5'11\"",
                    "6'0\"","6'1\"","6'2\"","6'3\"","6'4\"","6'5\"",
                    "6'6\"","6'7\"","6'8\"","6'9\"","6'10\"","6'11\"",
                    "7'0\"","7'1\"","7'2\"","7'3\"","7'4\"", "7'5\"",
    ]
    let feetSizes = ["6", "6.5", "7", "7.5", "8", "8.5", "9", "9.5", "10", "10.5", "11", "11.5", "12", "12.5", "13", "13.5", "14"]
    let shirtFits = ["Skinny", "Regular", "Loose"]
    let shirtSizes = ["XS", "S", "M", "L", "XL"]
    let waistSizes = ["30", "31", "32", "33", "34","35","36","37"]
    let inseamSizes = ["30", "31", "32", "33", "34","35","36","37"]
    let pantSizes = ["Skinny", "Slim", "Regular"]
}

extension OnBoardingView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pagingIdx = Int(round(scrollView.contentOffset.x/scrollView.frame.width))
        print(scrollView.contentOffset.x / scrollView.frame.width)
        switch self.tag {
        case 1:
            //height
            tickView.measurementLabel.text = heights[pagingIdx]
        case 2:
            //feet
            tickView.measurementLabel.text = feetSizes[pagingIdx]
        case 3:
            //shirt fit
            tickView.measurementLabel.text = shirtFits[pagingIdx]
        case 4:
            //shirt sizes
            tickView.measurementLabel.text = shirtSizes[pagingIdx]
        case 5:
            //waist sizes
            tickView.measurementLabel.text = waistSizes[pagingIdx]
        case 6:
            //inseam sizes
            tickView.measurementLabel.text = inseamSizes[pagingIdx]
        case 7:
            //pant sizes
            tickView.measurementLabel.text = pantSizes[pagingIdx]
        default:
            tickView.measurementLabel.text = String(pagingIdx)
        }
    }
    
}