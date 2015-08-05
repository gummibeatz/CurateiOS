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
        var personaFace: UIImageView = UIImageView(frame: CGRect(x: 20, y: 50, width: 50, height: 50))
        personaFace.backgroundColor = UIColor.blueColor()
        personaFace.image = personaImage
        
        var personaText: UILabel = UILabel(frame: CGRect(x: 80, y: 50, width: SCREENWIDTH-80, height: 50))
        personaText.text = "persona text here"
        
        var outfitImageView: UIImageView = UIImageView(frame: CGRect(x: 20, y: 100, width: SCREENWIDTH*8/9, height: SCREENHEIGHT*5/7))
        outfitImageView.backgroundColor = UIColor.blackColor()
        
        self.view.addSubview(outfitImageView)
        self.view.addSubview(personaText)
        self.view.addSubview(personaFace)
    }
    
    func setupButtons() {
        
        var backButton: UIButton = UIButton(frame: CGRectMake(10, 30, 50, 20))
        backButton.setTitle("Back", forState: UIControlState.Normal)
        backButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        var backButtonGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "backButtonTapped:")
        backButton.addGestureRecognizer(backButtonGesture)
        
        var doneButton: UIButton = UIButton(frame: CGRectMake(self.view.frame.width - 55, 30, 50, 20))
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        var doneButtonGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "doneButtonTapped:")
        doneButton.addGestureRecognizer(doneButtonGesture)
        
        self.view.addSubview(backButton)
        self.view.addSubview(doneButton)
    }
    
    func backButtonTapped(sender: UITapGestureRecognizer) {
        println("backbutton tapped")
    }
    
    func doneButtonTapped(sender: UITapGestureRecognizer) {
        println("donebutton tapped")
        delegate?.dismissRecommendationView()
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window!.rootViewController = appDelegate.navigationController
        appDelegate.setupMeasurementsButton()
    }
}