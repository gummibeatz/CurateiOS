//
//  CurateSignInVCViewController.swift
//  Curate
//
//  Created by Linus Liang on 11/23/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//

import UIKit

class CurateSignInVC: UIViewController {

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
        let curateSignIn = NSBundle.mainBundle().loadNibNamed("CurateSignInView", owner: self, options: nil).last as! CurateSignInView
        curateSignIn.frame = self.view.frame
        curateSignIn.backButton.addTarget(self, action: "backButtonTapped", forControlEvents: .TouchUpInside)
        self.view.addSubview(curateSignIn)
    }
    
    func backButtonTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}