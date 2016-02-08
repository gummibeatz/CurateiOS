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
    var rulerImage: UIImage?
    var tickLabels: [String]?
    
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
   
    // - MARK hacky fix. make this nicer
    func setScrollViewImage(withHeight height: CGFloat) {
        flexiblePagingScrollView.scrollViewImageView.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: flexiblePagingScrollView.scrollView.contentSize.width, height:height))
        flexiblePagingScrollView.scrollViewImageView.image = rulerImage
        print(rulerImage)
        print(flexiblePagingScrollView.scrollViewImageView.image)
        print(flexiblePagingScrollView.scrollViewImageView.frame)
        print(flexiblePagingScrollView.scrollViewImageView.layer)
    }
    
    func setInitialTickViewText() {
        tickView.measurementLabel.text = String(pagingIdx)
    }
}

extension OnBoardingView: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        pagingIdx = Int(round(scrollView.contentOffset.x/scrollView.frame.width))
        tickView.measurementLabel.text = String(pagingIdx)
    }
    
}