//
//  PersonaVC.swift
//  Curate
//
//  Created by Kenneth Kuo on 8/5/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation

class PersonaVC: UIViewController, RecommendationVCDelegate {
    
    let hipsterTag = 1
    let techTag = 2
    let financeTag = 3
    let stylishTag = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPersonas()
    }
    
    func setupPersonas() {
        var hipster: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH/2, height: SCREENHEIGHT/2))
        let hipsterGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "personaTapped:")
        hipster.backgroundColor = UIColor.greenColor()
        hipster.userInteractionEnabled = true
        hipster.tag = hipsterTag
        hipster.addGestureRecognizer(hipsterGesture)
        
        var tech: UIImageView = UIImageView(frame: CGRect(x: SCREENWIDTH/2, y: 0, width: SCREENWIDTH/2, height: SCREENHEIGHT/2))
        let techGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "personaTapped:")
        tech.backgroundColor = UIColor.blueColor()
        tech.userInteractionEnabled = true
        tech.tag = techTag
        tech.addGestureRecognizer(techGesture)
        
        var finance: UIImageView = UIImageView(frame: CGRect(x: 0, y: SCREENHEIGHT/2, width: SCREENWIDTH/2, height: SCREENHEIGHT/2))
        let financeGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "personaTapped:")
        finance.backgroundColor = UIColor.blackColor()
        finance.userInteractionEnabled = true
        finance.tag = financeTag
        finance.addGestureRecognizer(financeGesture)
        
        var stylish: UIImageView = UIImageView(frame: CGRect(x: SCREENWIDTH/2, y: SCREENHEIGHT/2, width: SCREENWIDTH/2, height: SCREENHEIGHT/2))
        let stylishGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "personaTapped:")
        stylish.backgroundColor = UIColor.redColor()
        stylish.userInteractionEnabled = true
        stylish.tag = stylishTag
        stylish.addGestureRecognizer(stylishGesture)
        
        self.view.addSubview(hipster)
        self.view.addSubview(tech)
        self.view.addSubview(finance)
        self.view.addSubview(stylish)
    }
    
    func personaTapped(sender: UIGestureRecognizer) {
        var recommendationVC: RecommendationVC = RecommendationVC()
        switch (sender.view!.tag) {
        case hipsterTag:
            println("hipster tapped")
            recommendationVC.personaImage = UIImage(named: "stockPerson")
        case techTag:
            println("tech tapped")
            recommendationVC.personaImage = UIImage(named: "stockPerson")
        case financeTag:
            println("finance tapped")
            recommendationVC.personaImage = UIImage(named: "stockPerson")
        case stylishTag:
            println("stylishtapped")
            recommendationVC.personaImage = UIImage(named: "stockPerson")
        default:
            println("error no tags match tapped view")
        }
        recommendationVC.delegate = self
        self.presentViewController(recommendationVC, animated: false, completion: nil)
    }
}

extension PersonaVC: RecommendationVCDelegate {
    func dismissRecommendationView() {
        println("dismissRecommendationView")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}