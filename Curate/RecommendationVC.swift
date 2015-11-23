//
//  File.swift
//  Curate
//
//  Created by Curate on 8/5/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import Foundation
import UIKit

protocol RecommendationVCDelegate {
    func dismissRecommendationView()
}

class RecommendationVC: UIViewController {
    var personaImage: UIImage?
    var delegate: RecommendationVCDelegate?
    var fitView: PersonaPreferencesView?
    var bodyView: PersonaPreferencesView?
    var outfitsRecView: PersonaOutfitsView?
    
    var tapCount: Int = 0
    let yOffset: CGFloat = 30
    
    override func viewDidLoad() {
        setupLayout()
    }
    
    func setupLayout() {
        let yOffset:CGFloat = 50
        let personaFace: UIImageView = UIImageView(frame: CGRect(x: SCREENWIDTH/2-100, y: yOffset, width: 200, height: 200))
        personaFace.userInteractionEnabled = true
        personaFace.bounds = CGRectInset(personaFace.frame, 10.0, 0)
        personaFace.image = personaImage
        
        let faceTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "faceTapped:")
        personaFace.addGestureRecognizer(faceTapGesture)
    
        bodyView =  setupBodyView(personaFace.frame)
        fitView = setupFitView(personaFace.frame)
        outfitsRecView = PersonaOutfitsView(frame: CGRect(x: 10, y: personaFace.frame.height + yOffset, width: SCREENWIDTH-20, height: SCREENHEIGHT - (personaFace.frame.height + yOffset + 10)))

        self.view.addSubview(bodyView!)
        
        self.view.addSubview(personaFace)
    }
    
    func setupBodyView(personaFaceFrame: CGRect) -> PersonaPreferencesView {
        let personaScript = "Before I can turn you into a FASHION GAWD, you should answer a few questions. Tap my face when you're done, or if you want to skip this. You can always enter it in later."
        let question1 = "How tall are you?"
        let question2 = "How much do you weight"
        let question3 = "Body type?"
        
        bodyView = PersonaPreferencesView(frame: CGRect(x: 10, y: personaFaceFrame.height + yOffset, width: SCREENWIDTH-20, height: SCREENHEIGHT - (personaFaceFrame.height + yOffset + 10)), personaScript: personaScript, question1: question1, question2: question2, question3: question3)
        bodyView!.picker1Data = ["5'1''","5'2''","5'3''","5'4''","5'5''","5'6''","5'7''","5'8''","5'9''","5'10''","5'11''","6'0''","6'1''","6'2''","6'3''","6'4''","6'5''","6'6''","6'7''","6'8''","6'9''","6'10''","6'11''"]

        bodyView!.picker2Data = createArrayWithRange(80, end: 360)
        bodyView!.picker3Data = ["Skinny", "Ripped", "Jacked", "Chicks", "dig bigger dudes"]
        return bodyView!
    }
    
    func setupFitView(personaFaceFrame: CGRect) -> PersonaPreferencesView {
        let personaScript = "Word. Now, tell me how you like your clothes to fit. The key to looking FRESH AF is to have shit that actually fits you right. If your shit doesn’t fit right, we’ll tell you. Tap my face when you’re done, or if you want to skip this. You can always enter it in later."
        let question1 = "How do you like your shirts to fit?"
        let question2 = "How do you like your pants to fit?"
        let question3 = "Do you get your shit tailored?"
        
        fitView = PersonaPreferencesView(frame: CGRect(x: 10, y: personaFaceFrame.height + yOffset, width: SCREENWIDTH-20, height: SCREENHEIGHT - (personaFaceFrame.height + yOffset + 10)), personaScript: personaScript, question1: question1, question2: question2, question3: question3)
        fitView!.picker1Data = ["Skin tight, son", "Slim", "Regular"]
        
        fitView!.picker2Data = ["Looks like I'm wearing Lululemons", "Slim", "Regular"]
        fitView!.picker3Data = ["Yes", "No"]
        return fitView!
        
    }
    
    func createArrayWithRange(start: Int, end: Int) -> [String] {
        var arr = [String]()
        for index in start...end{
            arr.append(String(index))
        }
        return arr
    }
    
    func faceTapped(sender: UITapGestureRecognizer) {
        print("face was tapped")
        switch tapCount {
        case 0:
            bodyView?.removeFromSuperview()
            self.view.addSubview(fitView!)
            tapCount++
        case 1:
            fitView?.removeFromSuperview()
            self.view.addSubview(outfitsRecView!)
            tapCount++
        case 2:
            outfitsRecView?.removeFromSuperview()
            delegate?.dismissRecommendationView()
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window!.rootViewController = MainTabBarController()
//            appDelegate.window!.rootViewController = appDelegate.navigationController
            
//            appDelegate.setupMeasurementsButton()
        default:
            print("no cases match")
        }
    }
}