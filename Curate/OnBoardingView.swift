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
            blueLine.backgroundColor = curateBlue
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
    
    @IBOutlet weak var tickView: TickView! {
        didSet {
            tickView.measurementLabel.text = String(pagingIdx)
        }
    }
    
    var pagingIdx: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setScrollViewImage(image: UIImage) {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0,y: 0), size: flexiblePagingScrollView.scrollView.contentSize))
        imageView.image = image
        flexiblePagingScrollView.scrollView.addSubview(imageView)
    }

    func setupScrollView(pages pages: Int) {
        flexiblePagingScrollView.pages = pages
    }
}

extension OnBoardingView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pagingIdx = Int(scrollView.contentOffset.x / scrollView.frame.width)
        tickView.measurementLabel.text = String(pagingIdx)
    }
    
}