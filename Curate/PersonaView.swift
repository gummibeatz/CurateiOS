//
//  PersonaView.swift
//  Curate
//
//  Created by Linus Liang on 11/24/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//

import UIKit

class PersonaView: UIView {
    @IBOutlet weak var stylishPersona: UIButton!
    @IBOutlet weak var financePersona: UIButton!
    @IBOutlet weak var techPersona: UIButton!
    @IBOutlet weak var hipsterPersona: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
