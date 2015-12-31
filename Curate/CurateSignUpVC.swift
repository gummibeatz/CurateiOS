//
//  CurateSignUpVCViewController.swift
//  Curate
//
//  Created by Linus Liang on 12/27/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//

import UIKit

class CurateSignUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        let curateSignUp = NSBundle.mainBundle().loadNibNamed("CurateSignUpView", owner: self, options: nil).last as! CurateSignUpView
        curateSignUp.frame = self.view.frame
        curateSignUp.backButton.addTarget(self, action: "backButtonTapped", forControlEvents: .TouchUpInside)
        self.view.addSubview(curateSignUp)
    }
    
    func backButtonTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
