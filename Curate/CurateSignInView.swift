//
//  CurateSignInView.swift
//  Curate
//
//  Created by Linus Liang on 11/23/15.
//  Copyright © 2015 Kenneth Kuo. All rights reserved.
//

import UIKit
import Foundation

protocol CurateSignInViewDelegate {
    func backButtonTapped()
}

class CurateSignInView: UIView {
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.addTarget(self, action: "backButtonTapped", forControlEvents: .TouchUpInside )
        }
    }

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
    
    @IBOutlet weak var loginTextView: UIView! {
        didSet {
            loginTextView.layer.cornerRadius = 8
        }
    }
    
    var delegate: CurateSignInViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("being called in the coder")
    }
    
    func backButtonTapped() {
        delegate?.backButtonTapped()
    }
}

extension CurateSignInView: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}