//
//  CurateSignInView.swift
//  Curate
//
//  Created by Linus Liang on 11/23/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//

import UIKit
import Foundation

class CurateSignInView: UIView {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
        }
    }
    @IBOutlet weak var loginContainerView: UIView! {
        didSet {
            loginContainerView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var logInButton: UIButton! {
        didSet {
            logInButton.layer.cornerRadius = 3
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("being called in the coder")
    }
    
}

extension CurateSignInView: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}