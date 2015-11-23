//
//  PersonaVC.swift
//  Curate
//
//  Created by Linus Liang on 9/9/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import Foundation
import UIKit

class PersonaVCwithXib: UIViewController {
    
    override func viewDidLoad() {
        let personaChoiceView: UIView = instanceFromNibNamed("PersonaChoiceView")
        personaChoiceView.frame = self.view.frame
        print(personaChoiceView.viewWithTag(1))
        
        self.view.addSubview(personaChoiceView)
    }
    
}