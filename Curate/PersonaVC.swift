//
//  PersonaVC.swift
//  Curate
//
//  Created by Curate on 8/5/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import Foundation

class PersonaVC: UIViewController, RecommendationVCDelegate {
    
    let hipsterTag = 1
    let techTag = 2
    let stylishTag = 3
    let financeTag = 4
    
    let heightOffset: CGFloat = SCREENHEIGHT/7
    let personaWidth: CGFloat = SCREENWIDTH/2
    let personaHeight: CGFloat = SCREENHEIGHT/2 - SCREENHEIGHT/7
    let labelHeight: CGFloat = 50
    
    lazy var personaChoiceView: PersonaScreen5sand6 = {
        return self.loadViewFromNibNamed("PersonaScreen5sand6") as! PersonaScreen5sand6
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
//    func setupPersonas() {
//        
//        let hipster: UIImageView = UIImageView(frame: CGRect(x: 0, y: heightOffset, width: personaWidth, height: personaHeight))
//        let hipsterGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "personaTapped:")
//        hipster.bounds = CGRectInset(hipster.frame, 20.0, 10)
//        hipster.image = UIImage(named: "Hipster Persona")
//        hipster.userInteractionEnabled = true
//        hipster.tag = hipsterTag
//        hipster.addGestureRecognizer(hipsterGesture)
//        
//        let tech: UIImageView = UIImageView(frame: CGRect(x: personaWidth, y: heightOffset, width: personaWidth, height: personaHeight))
//        let techGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "personaTapped:")
//        tech.bounds = CGRectInset(tech.frame, 20.0, 10)
//        tech.image = UIImage(named: "Tech Persona")
//        tech.userInteractionEnabled = true
//        tech.tag = techTag
//        tech.addGestureRecognizer(techGesture)
//        
//        let finance: UIImageView = UIImageView(frame: CGRect(x: 0, y: personaHeight+heightOffset+labelHeight-10, width: personaWidth, height: personaHeight))
//        let financeGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "personaTapped:")
//        finance.bounds = CGRectInset(finance.frame, 20.0, 10)
//        finance.image = UIImage(named: "Finance Persona")
//        finance.userInteractionEnabled = true
//        finance.tag = financeTag
//        finance.addGestureRecognizer(financeGesture)
//        
//        let stylish: UIImageView = UIImageView(frame: CGRect(x: personaWidth, y: personaHeight+heightOffset+labelHeight-10, width: personaWidth, height: personaHeight))
//        let stylishGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "personaTapped:")
//        stylish.bounds = CGRectInset(stylish.frame, 20.0, 10)
//        stylish.image = UIImage(named: "Stylish Persona")
//        stylish.userInteractionEnabled = true
//        stylish.tag = stylishTag
//        stylish.addGestureRecognizer(stylishGesture)
//        
//        self.view.addSubview(hipster)
//        self.view.addSubview(tech)
//        self.view.addSubview(finance)
//        self.view.addSubview(stylish)
//        
//    }
    
//    func setupLabels() {
//        let openingLabel = UILabel(frame: CGRect(x: 0, y: 20, width: SCREENWIDTH, height: heightOffset))
//        openingLabel.text = "Which of these dudes do you most identify with?"
//        openingLabel.numberOfLines = 2
//        openingLabel.textAlignment = NSTextAlignment.Center
//        self.view.addSubview(openingLabel)
//        
//        let hipsterLabel = UILabel(frame: CGRect(x: 0, y: heightOffset+personaHeight-10, width: personaWidth, height: labelHeight))
//        hipsterLabel.text = "Hipster enough\n for you?"
//        hipsterLabel.numberOfLines = 2
//        hipsterLabel.textAlignment = NSTextAlignment.Center
//        
//        let techLabel = UILabel(frame: CGRect(x: personaWidth, y: heightOffset+personaHeight-10, width: personaWidth, height: labelHeight))
//        techLabel.text = "Are you in\n stealth mode?"
//        techLabel.numberOfLines = 2
//        techLabel.textAlignment = NSTextAlignment.Center
//        
//        let financeLabel = UILabel(frame: CGRect(x: 0, y: heightOffset+personaHeight*2+labelHeight-20, width: personaWidth, height: labelHeight))
//        financeLabel.text = "You're suited and\n booted... constantly"
//        financeLabel.numberOfLines = 2
//        financeLabel.textAlignment = NSTextAlignment.Center
//        
//        let stylishLabel = UILabel(frame: CGRect(x: personaWidth, y: heightOffset+personaHeight*2+labelHeight-20, width: personaWidth, height: labelHeight))
//        stylishLabel.text = "You probably own\n a couple ascots"
//        stylishLabel.numberOfLines = 2
//        stylishLabel.textAlignment = NSTextAlignment.Center
//        
//        self.view.addSubview(hipsterLabel)
//        self.view.addSubview(techLabel)
//        self.view.addSubview(financeLabel)
//        self.view.addSubview(stylishLabel)
//    }
    
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
            print("finance tapped")
            recommendationVC.personaImage = UIImage(named: "Finance Persona")
        case financeTag:
            print("stylishtapped")
            recommendationVC.personaImage = UIImage(named: "Stylish Persona")
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