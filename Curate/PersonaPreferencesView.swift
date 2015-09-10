//
//  PersonaBodyView.swift
//  Curate
//
//  Created by Linus Liang on 9/9/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation
import UIKit

class PersonaPreferencesView: UIView, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var activeTextField:UITextField?
    var toolbar: UIToolbar?
    
    let heightPicker = UIPickerView()
    let weightPicker = UIPickerView()
    let bodyTypePicker = UIPickerView()
    
    var heightPickerData = [String()]
    var weightPickerData = [String]()
    var bodyTypePickerData = [String]()
    
    let heightTextField = UITextField()
    let weightTextField = UITextField()
    let bodyTypeTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPickers()
        setupToolBar()
        addPickerData()
        setupView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addPickerData() {
        heightPickerData = ["5'1''","5'2''","5'3''","5'4''","5'5''","5'6''","5'7''","5'8''","5'9''","5'10''","5'11''","6'0''","6'1''","6'2''","6'3''","6'4''","6'5''","6'6''","6'7''","6'8''","6'9''","6'10''","6'11''"]
        weightPickerData = createArrayWithRange(100, end: 220)
        bodyTypePickerData = ["Skinny","Ripped","Jacked","Chicks dig bigger dudes"]
    }
    
    func setupView() {
        var textHeight:CGFloat = 30
        
        var personaScript: UILabel = UILabel(frame: CGRect(x: 10, y: 0, width: self.frame.width, height: 100))
        personaScript.text = "Before I can turn you into a pussy slaying machine, you gotta answer a few questions. Tap my face when you’re done."
        personaScript.lineBreakMode = .ByWordWrapping
        personaScript.numberOfLines = 0
        
        var heightOffset = personaScript.frame.height+5
        
        var heightQuestion = UILabel(frame: CGRect(x: 10, y: heightOffset, width: self.frame.width-20, height: textHeight))
        heightQuestion.text = "How tall are you?"
        
        heightTextField.delegate = self
        heightTextField.inputAccessoryView = toolbar
        heightTextField.inputView = heightPicker
        heightTextField.frame = CGRect(x: 10, y: heightOffset+textHeight, width: 100, height: textHeight)
        heightTextField.borderStyle = UITextBorderStyle.RoundedRect
        heightTextField.layer.borderColor = UIColor.grayColor().CGColor;
        heightTextField.layer.cornerRadius = CGFloat(5.0)
        
        heightOffset = heightOffset + textHeight + heightQuestion.frame.height + 5
        
        var weightQuestion = UILabel(frame: CGRect(x: 10, y: heightOffset, width: self.frame.width-20, height: 20))
        weightQuestion.text = "How much do you weigh?"
        
        weightTextField.delegate = self
        weightTextField.inputAccessoryView = toolbar
        weightTextField.inputView = weightPicker
        weightTextField.frame = CGRect(x: 10, y: heightOffset+textHeight, width: 100, height: textHeight)
        weightTextField.borderStyle = UITextBorderStyle.RoundedRect
        weightTextField.layer.borderColor = UIColor.grayColor().CGColor
        weightTextField.layer.cornerRadius = CGFloat(5.0)
        
        heightOffset = weightQuestion.frame.height + heightOffset + textHeight + 10
        
        var bodyTypeQuestion = UILabel(frame: CGRect(x: 10, y: heightOffset, width: self.frame.width-20, height: 20))
        bodyTypeQuestion.text = "Body Type"
        bodyTypeTextField.delegate = self
        bodyTypeTextField.inputAccessoryView = toolbar
        bodyTypeTextField.inputView = bodyTypePicker
        bodyTypeTextField.frame = CGRect(x: 10, y: heightOffset+textHeight, width: 100, height: textHeight)
        bodyTypeTextField.borderStyle = UITextBorderStyle.RoundedRect
        bodyTypeTextField.layer.borderColor = UIColor.grayColor().CGColor
        bodyTypeTextField.layer.cornerRadius = CGFloat(5.0)
        
        self.addSubview(personaScript)
        self.addSubview(heightQuestion)
        self.addSubview(heightTextField)
        self.addSubview(weightQuestion)
        self.addSubview(weightTextField)
        self.addSubview(bodyTypeQuestion)
        self.addSubview(bodyTypeTextField)

    }
    
    func setupPickers() {
        heightPicker.tag = 0
        weightPicker.tag = 1
        bodyTypePicker.tag = 2
        
        heightPicker.delegate = self
        heightPicker.dataSource = self
        
        weightPicker.delegate = self
        weightPicker.dataSource = self
        
        bodyTypePicker.delegate = self
        bodyTypePicker.dataSource = self
    }
    
    func createArrayWithRange(start: Int, end: Int) -> [String] {
        var arr = [String]()
        for index in start...end{
            arr.append(String(index))
        }
        return arr
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
        case heightPicker.tag:
            return heightPickerData.count
        case weightPicker.tag:
            return weightPickerData.count
        case bodyTypePicker.tag:
            return bodyTypePickerData.count
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
        case heightPicker.tag:
            heightTextField.text = heightPickerData[row]
            heightTextField.textColor = UIColor.blackColor()
            return heightPickerData[row]
        case weightPicker.tag:
            weightTextField.text = weightPickerData[row]
            weightTextField.textColor = UIColor.blackColor()
            return weightPickerData[row]
        case bodyTypePicker.tag:
            bodyTypeTextField.text = bodyTypePickerData[row]
            bodyTypeTextField.textColor = UIColor.blackColor()
            return bodyTypePickerData[row]
        default:
            return "nothing"
        }
    }
    
    // maybe go back to this if scrolling lags too much
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case heightPicker.tag:
            heightTextField.text = heightPickerData[row]
            heightTextField.textColor = UIColor.blackColor()
        case weightPicker.tag:
            weightTextField.text = weightPickerData[row]
            weightTextField.textColor = UIColor.blackColor()
        case bodyTypePicker.tag:
            bodyTypeTextField.text = bodyTypePickerData[row]
            bodyTypeTextField.textColor = UIColor.blackColor()
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

