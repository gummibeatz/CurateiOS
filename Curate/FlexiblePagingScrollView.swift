//
//  flexiblePagingScrollView.swift
//  Curate
//
//  Created by Linus Liang on 11/27/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//

import UIKit

class FlexiblePagingScrollView: UIView {
    
    var scrollViewImageView = UIImageView()
    var scrollView: UIScrollView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.pagingEnabled = true
        scrollView.clipsToBounds = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.addSubview(scrollView)
        scrollViewImageView.contentMode = .ScaleToFill
        scrollView.addSubview(scrollViewImageView)
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        return self.pointInside(point, withEvent: event) ? scrollView : nil
    }
    
    func setupFrameWith(pagesPerFrame pagesPerFrame:CGFloat, totalPages:CGFloat, startBuffer: CGFloat, endBuffer: CGFloat) {
        let width = SCREENWIDTH / pagesPerFrame
        let x = SCREENWIDTH/2 - width
        scrollView.frame = CGRect(x: x, y: 0, width: width, height: self.frame.height)
        scrollView.contentSize = CGSize(width: width * totalPages, height: self.frame.height)
        // doesn't allow you to scroll to the last item
        scrollView.contentInset = UIEdgeInsets(top: 0, left: -1 * width * startBuffer, bottom: 0, right: -1 * endBuffer * width)
    }
}
