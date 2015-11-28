//
//  onBoardingVC.swift
//  Curate
//
//  Created by Curate on 8/5/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class onBoardingVC: UIViewController {
    
    var personaTag:Int?
    var activeLayer: CALayer?
    var activeViewIdx: Int?
    
    let hipsterTag = 0
    let techTag = 1
    let stylishTag = 2
    let financeTag = 3
    
    let scrollViewImages: [UIImage] = [UIImage(named: "ruler")!,
                                       UIImage(named: "ruler")!,
                                       UIImage(named: "ruler")!,
                                       UIImage(named: "ruler")!,
                                       UIImage(named: "ruler")!,
                                        ]
    let viewLabelTitles: [String] = ["What's your vertical?",
                                     "How big are your feet?",
                                     "What's your waist?",
                                     "How do you fit in them jeans?",
                                     "How do you like your fit?",
    
                                    ]
    let viewImages: [UIImage] = [UIImage(named: "silhouette")!,
                                 UIImage(named: "brannock")!,
                                 UIImage(named: "silhouette")!,
                                 UIImage(named: "silhouette")!,
                                 UIImage(named: "silhouette")!,
                                ]
    
    let heightOffset: CGFloat = SCREENHEIGHT/7
    
    let viewFrame: CGRect = CGRect(x: 0, y: SCREENHEIGHT/8, width: SCREENWIDTH, height: 7*SCREENHEIGHT/8)
    
    lazy var onBoardingViews: [UIView] = {
        var views = [UIView]()
        views.append(NSBundle.mainBundle().loadNibNamed("PersonaView", owner: self, options: nil).last as! PersonaView)
        views.append(NSBundle.mainBundle().loadNibNamed("onBoardingView", owner: self, options: nil).last as! onBoardingView)
        views.append(NSBundle.mainBundle().loadNibNamed("onBoardingView", owner: self, options: nil).last as! onBoardingView)
        views.append(NSBundle.mainBundle().loadNibNamed("onBoardingView", owner: self, options: nil).last as! onBoardingView)
        views.append(NSBundle.mainBundle().loadNibNamed("onBoardingView", owner: self, options: nil).last as! onBoardingView)
        views.append(NSBundle.mainBundle().loadNibNamed("onBoardingView", owner: self, options: nil).last as! onBoardingView)
        return views
    }()
    
    lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .Default)
        progressBar.trackTintColor = UIColor.blackColor()
        progressBar.progressTintColor = curateBlue
        progressBar.frame = CGRect(x: SCREENWIDTH/4, y: SCREENHEIGHT/14, width: SCREENWIDTH/2, height: 20)
        return progressBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupBackground()
        let personaView = onBoardingViews.first!
        personaView.frame = viewFrame
        activeViewIdx = 0
        setupPersonaTargets(personaView as! PersonaView)
        self.view.addSubview(personaView)
    }
    
    func setupBackground() {
        //adding background picture
        let backgroundView = UIImageView(frame: self.view.bounds)
        backgroundView.image = UIImage(named: "personaViewBG")
        self.view.addSubview(backgroundView)
        
        //adding progress bar
        self.view.addSubview(progressBar)
    }
    
    func setupPersonaTargets(personaView: PersonaView) {
        personaView.hipsterPersona.addTarget(self, action: "personaTouched:", forControlEvents: .TouchDown)
        personaView.techPersona.addTarget(self, action: "personaTouched:", forControlEvents: .TouchDown )
        personaView.financePersona.addTarget(self, action: "personaTouched:", forControlEvents: .TouchDown)
        personaView.stylishPersona.addTarget(self, action: "personaTouched:", forControlEvents: .TouchDown)
        
        personaView.hipsterPersona.addTarget(self, action: "personaSelected:", forControlEvents: .TouchUpInside)
        personaView.techPersona.addTarget(self, action: "personaSelected:", forControlEvents: .TouchUpInside)
        personaView.financePersona.addTarget(self, action: "personaSelected:", forControlEvents: .TouchUpInside)
        personaView.stylishPersona.addTarget(self, action: "personaSelected:", forControlEvents: .TouchUpInside)
    }
    
    func personaTouched(sender: UIButton) {
        print("persona touched")
        removeActiveLayer()
        activeLayer = createDashedBorderAroundView(sender, heightOffset: heightOffset, borderColor: curateBlue)
        self.view.layer.addSublayer(activeLayer!)
    }
    
    func personaSelected(sender: UIButton) {
        personaTag = sender.tag
        loadNextView()
    }
    
    func loadNextView() {
        if activeViewIdx! + 1 >= onBoardingViews.count {
            return
        }
        let nextView = onBoardingViews[activeViewIdx! + 1]
        nextView.frame = viewFrame
        self.removeActiveLayer()
        UIView.transitionFromView( onBoardingViews[activeViewIdx!], toView: nextView, duration: 0.5, options: .TransitionCrossDissolve, completion: {
            completionHandler in
            print("animation transitioned")
            self.progressBar.setProgress(Float(self.activeViewIdx!) / Float(self.onBoardingViews.count), animated: true)
        })
        activeViewIdx = activeViewIdx! + 1
        setupMeasurementView(nextView as! onBoardingView)
    }
    
    func setupMeasurementView(view: onBoardingView) {
        view.setScrollViewImage(scrollViewImages[activeViewIdx! - 1])
        view.labelTitle.text = viewLabelTitles[activeViewIdx! - 1]
        view.centerImageView.image = viewImages[activeViewIdx! - 1]
        let tapGesture = UITapGestureRecognizer(target: self, action: "loadNextView")
        view.centerImageView.addGestureRecognizer(tapGesture)
        view.centerImageView.userInteractionEnabled = true
    }
    
    func removeActiveLayer() {
        if activeLayer != nil {
            activeLayer!.removeFromSuperlayer()
        }
    }
    
}