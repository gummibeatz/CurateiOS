//
//  curateLoginTabBarController.swift
//  Curate
//
//  Created by Linus Liang on 12/27/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//

import UIKit

class CurateLoginTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    func setupViewControllers() {
        let curateSignInVC = CurateSignInVC()
        let curateSignUpVC = CurateSignUpVC()
        curateSignInVC.tabBarItem = UITabBarItem(title: "Log In", image: nil, tag: 0)
        curateSignUpVC.tabBarItem = UITabBarItem(title: "Sign Up", image: nil, tag: 1)
        self.viewControllers = [curateSignInVC, curateSignUpVC]
    }
    
}
