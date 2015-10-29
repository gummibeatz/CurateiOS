//
//  PersonaScreen5sand6.swift
//  Curate
//
//  Created by Linus Liang on 10/3/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//

import Foundation
import UIKit

class PersonaScreen: UIView {
    @IBOutlet weak var techPersona: UIImageView!
    @IBOutlet weak var stylishPersona: UIImageView!
    @IBOutlet weak var financePersona: UIImageView!
    @IBOutlet weak var hipsterPersona: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}