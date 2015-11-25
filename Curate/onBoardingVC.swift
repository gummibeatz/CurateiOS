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
    
    let hipsterTag = 0
    let techTag = 1
    let stylishTag = 2
    let financeTag = 3
    
    let heightOffset: CGFloat = SCREENHEIGHT/7
    
    let viewFrames: CGRect = CGRect(x: 0, y: SCREENHEIGHT/8, width: SCREENWIDTH, height: 7*SCREENHEIGHT/8)
    
    lazy var personaView: PersonaView = {
       return NSBundle.mainBundle().loadNibNamed("PersonaView", owner: self, options: nil).last as! PersonaView
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
        
        personaView = NSBundle.mainBundle().loadNibNamed("PersonaView", owner: self, options: nil).last as! PersonaView
        setupBackground()
        personaView.frame = viewFrames
        setupPersonaTargets()
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
    
    func setupPersonaTargets() {
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
    }
    func removeActiveLayer() {
        if activeLayer != nil {
            activeLayer!.removeFromSuperlayer()
        }
    }
    
}