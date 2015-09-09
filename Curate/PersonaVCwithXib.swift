//
//  PersonaVC.swift
//  Curate
//
//  Created by Linus Liang on 9/9/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation

class PersonaVCwithXib: UIViewController {
    
    override func viewDidLoad() {
        var personaChoiceView: UIView = instanceFromNibNamed("PersonaChoiceView")
        personaChoiceView.frame = self.view.frame
        println(personaChoiceView.viewWithTag(1))
        
        self.view.addSubview(personaChoiceView)
    }
    
}