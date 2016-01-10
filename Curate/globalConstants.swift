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

//don't know where to put this. figure it out later
func instanceFromNibNamed(nibName: String) -> UIView {
    return UINib(nibName: nibName, bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
}