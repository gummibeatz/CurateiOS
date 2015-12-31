//
//  CurateSignUpView.swift
//  Curate
//
//  Created by Linus Liang on 12/27/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//

import UIKit

class CurateSignUpView: UIView {

    @IBOutlet weak var signUpContainerView: UIView! {
        didSet {
            signUpContainerView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            layer.cornerRadius = 3
        }
    }
    @IBOutlet weak var backButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension CurateSignInVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
