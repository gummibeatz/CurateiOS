//
//  CONSTANTS.swift
//  Curate
//
//  Created by Curate on 8/5/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import Foundation
import UIKit

let SCREENWIDTH = UIScreen.mainScreen().bounds.width
let SCREENHEIGHT = UIScreen.mainScreen().bounds.height
let π:CGFloat = CGFloat(M_PI)

//colors
let curateBlue = UIColor(red: 27/255.0, green: 161/255.0, blue: 253/255.0, alpha: 1)
let curateDarkGrey = UIColor(red: 78/255.0, green: 78/255.0, blue: 78/255.0, alpha: 1)

//don't know where to put this. figure it out later
func instanceFromNibNamed(nibName: String) -> UIView {
    return UINib(nibName: nibName, bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
}