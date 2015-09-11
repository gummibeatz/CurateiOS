//
//  PersonaBodyView.swift
//  Curate
//
//  Created by Linus Liang on 9/9/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import Foundation
import UIKit

class PersonaPreferencesView: UIView, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var activeTextField:UITextField?
    var toolbar: UIToolbar?
    
    let picker1 = UIPickerView()
    let picker2 = UIPickerView()
    let picker3 = UIPickerView()
    
    let textField1 = UITextField()
    let textField2 = UITextField()
    let textField3 = UITextField()
    
    var picker1Data: [String]?
    var picker2Data: [String]?
    var picker3Data: [String]?
    
    var personaScript: String?
    var question1: String?
    var question2: String?
    var question3: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, personaScript:String, question1:String, question2:String, question3:String) {
        super.init(frame:frame)
        self.personaScript = personaScript
        self.question1 = question1
        self.question2 = question2
        self.question3 = question3
        setupPickers()
        setupToolBar()
        setupView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        var textHeight:CGFloat = 30
        
        var personaLabel: UILabel = UILabel(frame: CGRect(x: 10, y: 0, width: self.frame.width, height: 100))
        personaLabel.text = personaScript
        personaLabel.lineBreakMode = .ByWordWrapping
        personaLabel.numberOfLines = 0
        
        var heightOffset = personaLabel.frame.height+5
        
        var questionLabel1 = UILabel(frame: CGRect(x: 10, y: heightOffset, width: self.frame.width-20, height: textHeight))
        questionLabel1.text = question1
        
        textField1.delegate = self
        textField1.inputAccessoryView = toolbar
        textField1.inputView = picker1
        textField1.frame = CGRect(x: 10, y: heightOffset+textHeight, width: 100, height: textHeight)
        textField1.borderStyle = UITextBorderStyle.RoundedRect
        textField1.layer.borderColor = UIColor.grayColor().CGColor;
        textField1.layer.cornerRadius = CGFloat(5.0)
        
        heightOffset = heightOffset + textHeight + questionLabel1.frame.height + 5
        
        var questionLabel2 = UILabel(frame: CGRect(x: 10, y: heightOffset, width: self.frame.width-20, height: 20))
        questionLabel2.text = question2
        
        textField2.delegate = self
        textField2.inputAccessoryView = toolbar
        textField2.inputView = picker2
        textField2.frame = CGRect(x: 10, y: heightOffset+textHeight, width: 100, height: textHeight)
        textField2.borderStyle = UITextBorderStyle.RoundedRect
        textField2.layer.borderColor = UIColor.grayColor().CGColor
        textField2.layer.cornerRadius = CGFloat(5.0)
        
        heightOffset = questionLabel2.frame.height + heightOffset + textHeight + 10
        
        var questionLabel3 = UILabel(frame: CGRect(x: 10, y: heightOffset, width: self.frame.width-20, height: 20))
        questionLabel3.text = question3
        textField3.delegate = self
        textField3.inputAccessoryView = toolbar
        textField3.inputView = picker3
        textField3.frame = CGRect(x: 10, y: heightOffset+textHeight, width: 100, height: textHeight)
        textField3.borderStyle = UITextBorderStyle.RoundedRect
        textField3.layer.borderColor = UIColor.grayColor().CGColor
        textField3.layer.cornerRadius = CGFloat(5.0)
        
        self.addSubview(personaLabel)
        self.addSubview(questionLabel1)
        self.addSubview(textField1)
        self.addSubview(questionLabel2)
        self.addSubview(textField2)
        self.addSubview(questionLabel3)
        self.addSubview(textField3)

    }
    
    func setupPickers() {
        picker1.tag = 0
        picker2.tag = 1
        picker3.tag = 2
        
        picker1.delegate = self
        picker1.dataSource = self
        
        picker2.delegate = self
        picker2.dataSource = self
        
        picker3.delegate = self
        picker3.dataSource = self
    }
    
    func setupToolBar() {
        //pickerview tool bar
        self.toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        var items = [AnyObject]()
        //making done button
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "donePressed")
        items.append(doneButton)
        
        self.toolbar!.barStyle = UIBarStyle.Black
        self.toolbar!.setItems(items, animated: true)
    }
    
    func donePressed() {
        activeTextField?.resignFirstResponder()
    }
}

//MARK: Data Sources UIPickerView
extension PersonaPreferencesView: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag{
        case picker1.tag:
            return picker1Data!.count
        case picker2.tag:
            return picker2Data!.count
        case picker3.tag:
            return picker3Data!.count
        default:
            return 0
        }
    }
}

//MARK: Delegates UIPickerView
extension PersonaPreferencesView: UIPickerViewDelegate {
    // several optional methods:
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch pickerView.tag {
        case picker1.tag:
            textField1.text = picker1Data![row]
            textField1.textColor = UIColor.blackColor()
            return picker1Data![row]
        case picker2.tag:
            textField2.text = picker2Data![row]
            textField2.textColor = UIColor.blackColor()
            return picker2Data![row]
        case picker3.tag:
            textField3.text = picker3Data![row]
            textField3.textColor = UIColor.blackColor()
            return picker3Data![row]
        default:
            return "nothing"
        }
    }
    
    // maybe go back to this if scrolling lags too much
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case picker1.tag:
            textField1.text = picker1Data![row]
            textField1.textColor = UIColor.blackColor()
        case picker2.tag:
            textField2.text = picker2Data![row]
            textField2.textColor = UIColor.blackColor()
        case picker3.tag:
            textField3.text = picker3Data![row]
            textField3.textColor = UIColor.blackColor()
        default:
            NSLog("Not here")
        }
    }
}

//Mark: Delegate UITextField
extension PersonaPreferencesView: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }
}

