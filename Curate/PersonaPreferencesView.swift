//
//  PersonaBodyView.swift
//  Curate
//
//  Created by Linus Liang on 9/9/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation

class PersonaPreferencesView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabels()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupLabels() {
        var textHeight:CGFloat = 20
        
        var personaScript: UILabel = UILabel(frame: CGRect(x: 10, y: 0, width: self.frame.width, height: 100))
        personaScript.text = "Before I can turn you into a pussy slaying machine, you gotta answer a few questions. Tap my face when you’re done."
        personaScript.lineBreakMode = .ByWordWrapping
        personaScript.numberOfLines = 0
        
        var heightOffset = personaScript.frame.height+5
        
        var heightQuestion = UILabel(frame: CGRect(x: 10, y: heightOffset, width: self.frame.width-20, height: textHeight))
        heightQuestion.text = "How tall are you?"
        
        heightOffset = heightOffset + textHeight + heightQuestion.frame.height
        
        var weightQuestion = UILabel(frame: CGRect(x: 10, y: heightOffset, width: self.frame.width-20, height: 20))
        weightQuestion.text = "How much do you weigh?"
        
        heightOffset = weightQuestion.frame.height + heightOffset + textHeight
        
        var bodyTypeQuestion = UILabel(frame: CGRect(x: 10, y: heightOffset, width: self.frame.width-20, height: 20))
        bodyTypeQuestion.text = "Body Type"
        
        self.addSubview(personaScript)
        self.addSubview(heightQuestion)
        self.addSubview(weightQuestion)
        self.addSubview(bodyTypeQuestion)
    }
}

