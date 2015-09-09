//
//  File.swift
//  Curate
//
//  Created by Kenneth Kuo on 8/5/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation

protocol RecommendationVCDelegate {
    func dismissRecommendationView()
}

class RecommendationVC: UIViewController {
    var personaImage: UIImage?
    var delegate: RecommendationVCDelegate?
    
    override func viewDidLoad() {
        setupLayout()
        setupButtons()
    }
    
    func setupLayout() {
        let yOffset:CGFloat = 50
        var personaFace: UIImageView = UIImageView(frame: CGRect(x: SCREENWIDTH/2-100, y: yOffset, width: 200, height: 200))
        personaFace.bounds = CGRectInset(personaFace.frame, 10.0, 0)
        personaFace.image = personaImage
        
        var doneGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "doneButtonTapped:")
        personaFace.addGestureRecognizer(doneGesture)
        
        var view = PersonaPreferencesView(frame: CGRect(x: 10, y: personaFace.frame.height + yOffset, width: SCREENWIDTH-20, height: SCREENHEIGHT - (personaFace.frame.height + yOffset + 10) ))
//        view.backgroundColor = UIColor.blueColor()
        self.view.addSubview(view)
        
        self.view.addSubview(personaFace)
    }
    
    func setupButtons() {
        
        var doneButton: UIButton = UIButton(frame: CGRectMake(self.view.frame.width - 55, 30, 50, 20))
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        var doneButtonGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "doneButtonTapped:")
        doneButton.addGestureRecognizer(doneButtonGesture)
        self.view.addSubview(doneButton)
    }
    
    func doneButtonTapped(sender: UITapGestureRecognizer) {
        println("donebutton tapped")
        delegate?.dismissRecommendationView()
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window!.rootViewController = appDelegate.navigationController
        appDelegate.setupMeasurementsButton()
    }
}