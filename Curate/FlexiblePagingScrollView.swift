//
//  flexiblePagingScrollView.swift
//  Curate
//
//  Created by Linus Liang on 11/27/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//

import UIKit

class FlexiblePagingScrollView: UIView {
    
    var scrollView: UIScrollView!
    var pages: Int {
        get {
            return self.pages
        }
        set {
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * CGFloat(newValue), height: self.scrollView.frame.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.pagingEnabled = true
        scrollView.clipsToBounds = false
        self.addSubview(scrollView)
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        return self.pointInside(point, withEvent: event) ? scrollView : nil
    }
    
    func setupFrameWith(pagesPerFrame pagesPerFrame:CGFloat, totalPages:CGFloat) {
        let width = SCREENWIDTH / pagesPerFrame
        let x = SCREENWIDTH/2 - width
        scrollView.frame = CGRect(x: x, y: 0, width: width, height: self.frame.height)
        scrollView.contentSize = CGSize(width: width * totalPages, height: self.frame.height)
    }
}
