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
            return Int(self.frame.width / scrollView.frame.width)
        }
        set {
            let width = SCREENWIDTH / CGFloat(newValue)
            let x = SCREENWIDTH/2 - width / 2.0
            scrollView.frame = CGRect(x: x, y: 0, width: width, height: self.frame.height)
            print(scrollView.frame)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("from decoder")
        scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: SCREENWIDTH * 10, height: self.frame.height)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.pagingEnabled = true
        scrollView.clipsToBounds = false
        self.addSubview(scrollView)
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        return self.pointInside(point, withEvent: event) ? scrollView : nil
    }
}
