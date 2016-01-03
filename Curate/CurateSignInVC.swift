//
//  CurateSignInVCViewController.swift
//  Curate
//
//  Created by Linus Liang on 11/23/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//

import UIKit

class CurateSignInVC: UIViewController {
    
    var curateSignIn: CurateSignInView!

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
        curateSignIn = NSBundle.mainBundle().loadNibNamed("CurateSignInView", owner: self, options: nil).last as! CurateSignInView
        curateSignIn.frame = self.view.frame
        curateSignIn.backButton.addTarget(self, action: "backButtonTapped", forControlEvents: .TouchUpInside)
        curateSignIn.logInButton.addTarget(self, action: "loginButtonTapped", forControlEvents: .TouchUpInside)
        self.view.addSubview(curateSignIn)
    }
    
    func backButtonTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loginButtonTapped() {
        let email = curateSignIn.emailTextField.text!
        let password = curateSignIn.passwordTextField.text!
        getCurateAuthToken(email, password: password, isLogin: true, completionHandler: {
            curateAuthToken in
            if curateAuthToken == "no_token" {
                let alertController = UIAlertController(title: "Invalid email or password", message: "We didn't find any matches please try again", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                writeCustomObjArraytoUserDefaults([curateAuthToken], fileName: "curateAuthToken")
                dispatch_async(dispatch_get_main_queue(), {
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.window?.rootViewController = OnBoardingVC()
                })
            }
        })
    }
}