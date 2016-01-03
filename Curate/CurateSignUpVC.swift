//
//  CurateSignUpVCViewController.swift
//  Curate
//
//  Created by Linus Liang on 12/27/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//

import UIKit

class CurateSignUpVC: UIViewController {
    
    var curateSignUp: CurateSignUpView!

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
        curateSignUp = NSBundle.mainBundle().loadNibNamed("CurateSignUpView", owner: self, options: nil).last as! CurateSignUpView
        curateSignUp.frame = self.view.frame
        curateSignUp.backButton.addTarget(self, action: "backButtonTapped", forControlEvents: .TouchUpInside)
        curateSignUp.signUpButton.addTarget(self, action: "signUpTapped", forControlEvents: .TouchUpInside)
        self.view.addSubview(curateSignUp)
    }
    
    func backButtonTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpTapped() {
        let email = curateSignUp.loginTextField.text!
        let password = curateSignUp.passwordTextField!.text!
        let passwordConfirmation = curateSignUp.passwordConfirmationTextField.text!
        if email.rangeOfString("@") != nil && password == passwordConfirmation && password.characters.count > 5 {
            getCurateAuthToken(email, password: password, isLogin: false, completionHandler: {
                curateAuthToken in
                writeCustomObjArraytoUserDefaults([curateAuthToken], fileName: "curateAuthToken")
                let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                dispatch_async(dispatch_get_main_queue(), {
                    appDelegate.window?.rootViewController = OnBoardingVC()
                    self.resignFirstResponder()
                })
            })
        } else {
            let alertViewController = UIAlertController(title: "Invalid Password or Email", message: "Must have a valid email, matching passwords, and password length greater than 5", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertViewController.addAction(defaultAction)
            self.presentViewController(alertViewController, animated: true, completion: nil)
        }
    }
}
