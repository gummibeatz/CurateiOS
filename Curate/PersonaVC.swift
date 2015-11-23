//
//  PersonaVC.swift
//  Curate
//
//  Created by Curate on 8/5/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class PersonaVC: UIViewController, RecommendationVCDelegate {
    
    let hipsterTag = 1
    let techTag = 2
    let stylishTag = 3
    let financeTag = 4
    
    let heightOffset: CGFloat = SCREENHEIGHT/7
    let personaWidth: CGFloat = SCREENWIDTH/2
    let personaHeight: CGFloat = SCREENHEIGHT/2 - SCREENHEIGHT/7
    let labelHeight: CGFloat = 50
    
    lazy var personaChoiceView: PersonaScreen = {
        return self.loadViewFromNibNamed("PersonaScreen5S") as! PersonaScreen
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("FBSDK access token = \(FBSDKAccessToken.currentAccessToken().tokenString)")
        self.view = personaChoiceView
        setupPersonaGestures()
    }
    
    func setupPersonaGestures() {
        let hipsterGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "personaTapped:")
        personaChoiceView.hipsterPersona.addGestureRecognizer(hipsterGesture)
        let techGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "personaTapped:")
        personaChoiceView.techPersona.addGestureRecognizer(techGesture)
        let financeGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "personaTapped:")
        personaChoiceView.financePersona.addGestureRecognizer(financeGesture)
        let stylishGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "personaTapped:")
        personaChoiceView.stylishPersona.addGestureRecognizer(stylishGesture)
    }
    
    func loadViewFromNibNamed(nibName: String) -> UIView {
        let bundle = NSBundle.mainBundle()
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).last as! UIView
        return view
    }
    
    func personaTapped(sender: UIGestureRecognizer) {
        print("tapped")
        let recommendationVC: RecommendationVC = RecommendationVC()
        switch (sender.view!.tag) {
        case hipsterTag:
            print("hipster tapped")
            recommendationVC.personaImage = UIImage(named: "Hipster Persona")
        case techTag:
            print("tech tapped")
            recommendationVC.personaImage = UIImage(named: "Tech Persona")
        case stylishTag:
            print("stylish tapped")
            recommendationVC.personaImage = UIImage(named: "Stylish Persona")
        case financeTag:
            print("finance tapped")
            recommendationVC.personaImage = UIImage(named: "Finance Persona")
        default:
            print("error no tags match tapped view")
        }
        recommendationVC.delegate = self
        self.presentViewController(recommendationVC, animated: false, completion: nil)
    }
}

extension PersonaVC {
    func dismissRecommendationView() {
        print("dismissRecommendationView")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}