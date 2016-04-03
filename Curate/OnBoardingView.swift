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
    var startOffset: Int?
    
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel! {
        didSet {
            labelTitle.textColor = UIColor.blackColor()
            labelTitle.numberOfLines = 2
        }
    }
    
    @IBOutlet weak var blueLine: UIView! {
        didSet {
            blueLine.backgroundColor = UIColor.blackColor()
//            blueLine.layer.shadowOffset = CGSize(width: 1, height: 1)
//            blueLine.layer.shadowColor = UIColor.darkGrayColor().CGColor
//            blueLine.layer.shadowOpacity = 1.0
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        startOffset = 0
        tickLabels = ["0"]
    }
    
    // - MARK hacky fix. make this nicer
    func setScrollViewImage(withHeight height: CGFloat) {
        flexiblePagingScrollView.scrollViewImageView.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: flexiblePagingScrollView.scrollView.contentSize.width, height:height))
        flexiblePagingScrollView.scrollViewImageView.image = rulerImage
        
    }
    
    func pagingIdx(scrollView: UIScrollView) -> Int {
        var pagingIdx = Int(round(scrollView.contentOffset.x/scrollView.frame.width)) - startOffset!
        if pagingIdx < 0 {
            pagingIdx = 0
        } else if pagingIdx >= tickLabels!.count {
            pagingIdx = tickLabels!.count - 1
        }
        return pagingIdx
    }
    
    func setInitialTickLabel() {
        tickView.measurementLabel.text = tickLabels?[pagingIdx(flexiblePagingScrollView.scrollView)]
    }
    
}

extension OnBoardingView: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        tickView.measurementLabel.text = tickLabels?[(pagingIdx(scrollView))]
    }
}