//
//  PropertiesView.swift
//  OutfitBuilder
//
//  Created by Curate on 1/3/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import UIKit

protocol PropertiesViewVCDelegate {
    func blurEffectWasTapped(VC: UIViewController)
}

class PropertiesViewVC: UIViewController{
    
    let POPOUTSIZE = CGSize(width: 270, height: 320)
    let SCREENWIDTH = UIScreen.mainScreen().bounds.size.width
    
    var isFrontView = true
    
    var propertiesBackView: PropertiesBackView?
    var propertiesFrontView: PropertiesFrontView?
    
    var propertiesViewVCDelegate: PropertiesViewVCDelegate?
    var image: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(image)
    }
    
    func setupView(image: UIImage) {
        print("setupview for propertiesviewVC")
        let tappableBackView: UIView = createTappableBackView()
        propertiesBackView = createPropertiesBackView()
        propertiesFrontView = createPropertiesFrontView(image)
        self.view.addSubview(tappableBackView)
        self.view.addSubview(propertiesBackView!)
        self.view.addSubview(propertiesFrontView!)
    }
    
    func createTappableBackView() -> UIView {
        let view = UIView()
        view.frame = UIScreen.mainScreen().bounds
        view.backgroundColor = UIColor.clearColor()
        let backScreenTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "backViewWasTapped")
        view.addGestureRecognizer(backScreenTapGestureRecognizer)
        return view
    }
    
    func createPropertiesFrontView(image: UIImage) -> PropertiesFrontView {
        let frontView: PropertiesFrontView = PropertiesFrontView(frame: CGRect(x: (SCREENWIDTH -  POPOUTSIZE.width)/2, y: self.view.frame.height/2 - POPOUTSIZE.height/2, width: POPOUTSIZE.width, height: POPOUTSIZE.height))
        frontView.popoutImageView.image = image
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "popoutViewWasTapped")
        frontView.addGestureRecognizer(gestureRecognizer)
        return frontView
    }
    
    
    func createPropertiesBackView() -> PropertiesBackView {
        let backView = PropertiesBackView(frame: CGRect(x: (SCREENWIDTH -  POPOUTSIZE.width)/2, y: self.view.frame.height/2 - POPOUTSIZE.height/2, width: POPOUTSIZE.width, height: POPOUTSIZE.height))
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "popoutViewWasTapped")
        backView.addGestureRecognizer(gestureRecognizer)
        return backView
    }
    
    func popoutViewWasTapped() {
        if isFrontView {
            print("fronttapped")
            UIView.transitionFromView(propertiesFrontView!, toView: propertiesBackView!, duration: 1.0, options: .TransitionFlipFromRight, completion: nil)
            isFrontView = false
        } else {
            print("backtapped")
            isFrontView = true
            UIView.transitionFromView(propertiesBackView!, toView: propertiesFrontView!, duration: 1.0, options: .TransitionFlipFromRight, completion: nil)
        }
    }
    
    func backViewWasTapped() {
        print("backview send to blurview")
        propertiesViewVCDelegate?.blurEffectWasTapped(self)
    }
    
}
