//
//  AddOutfitView.swift
//  Curate
//
//  Created by Curate on 4/30/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import Foundation
import UIKit

protocol AddOutfitViewDelegate {
    func dismissOutfitView()
}

class AddOutfitView: UIView, UITextFieldDelegate {
    
    var titleTextField: UITextField?
    var activeTextField: UITextField?
    var doneButton: UIButton?
    var backButton: UIButton?
    var outfit: Outfit?
    var ownedOutfits: [Outfit] = readCustomObjArrayFromUserDefaults("ownedOutfits") as! [Outfit]
    var delegate: AddOutfitViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // ...
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, outfit: Outfit) {
        super.init(frame: frame)
        self.outfit = outfit
        setupLayout()
        setupInputViews()
        setupCategoryTable()
        setupWeatherButtons()
        setupButtons()
    }
    
    func setupLayout() {
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 4
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSizeMake(1, 1)
    }
    
    func setupInputViews() {
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        var items = [UIBarButtonItem]()
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "donePressed")
        items.append(doneButton)
        
        toolbar.barStyle = UIBarStyle.Black
        toolbar.setItems(items, animated: true)
        
        titleTextField = UITextField(frame: CGRect(x: self.frame.width/2 - 80, y: 50, width: 160, height: 30))
        titleTextField!.borderStyle = UITextBorderStyle.Bezel
        titleTextField!.layer.borderColor = UIColor.grayColor().CGColor;
        titleTextField!.layer.cornerRadius = CGFloat(5.0)
        titleTextField!.delegate = self
        titleTextField!.inputAccessoryView = toolbar
        titleTextField!.tag = 0
        titleTextField?.textColor = UIColor.grayColor()
        titleTextField?.text = "Outfit Name"
        self.addSubview(titleTextField!)
    }
    
    func setupCategoryTable() {
        let temp: UILabel = UILabel(frame: CGRectMake(10, self.frame.height/4, self.frame.width - 20, self.frame.height/2))
        temp.layer.borderColor = UIColor.blackColor().CGColor
        temp.layer.borderWidth = 1.0
        temp.text = "customizable categories \n coming soon"
        temp.textAlignment = NSTextAlignment.Center
        temp.numberOfLines = 2
        self.addSubview(temp)
    }
    
    func setupWeatherButtons() {
        let temp: UILabel = UILabel(frame: CGRectMake(10, 4*self.frame.height/5, self.frame.width - 20, 50))
        temp.layer.borderColor = UIColor.blackColor().CGColor
        temp.layer.borderWidth = 1.0
        temp.text = "weather options coming soon"
        temp.textAlignment = NSTextAlignment.Center
        temp.numberOfLines = 2
        self.addSubview(temp)
    }
    
    
    func setupButtons() {
        self.backButton = UIButton(frame: CGRectMake(10, 10, 50, 20))
        self.backButton?.setTitle("Back", forState: UIControlState.Normal)
        self.backButton?.setTitleColor(UIColor.blueColor(), forState: .Normal)
        let backButtonGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "backButtonTapped")
        backButton?.addGestureRecognizer(backButtonGesture)
        
        self.doneButton = UIButton(frame: CGRectMake(self.frame.width - 55, 10, 50, 20))
        self.doneButton?.setTitle("Done", forState: .Normal)
        self.doneButton?.setTitleColor(UIColor.blueColor(), forState: .Normal)
        let doneButtonGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "doneButtonTapped")
        doneButton?.addGestureRecognizer(doneButtonGesture)
        
        self.addSubview(backButton!)
        self.addSubview(doneButton!)
    }
    
    func donePressed() {
        activeTextField?.resignFirstResponder()
        print("donePressed")
    }
    
    func doneButtonTapped() {
        print("doneButtonTapped")
        self.outfit!.title = titleTextField!.text!
        // need to find some other way to double check outfit
        
        
        if (outfitWithTitleExists(outfit!.title!)) {
            print("title already exists")
            let alert: UIAlertView = UIAlertView(title: "Outfit with same title", message: "choose another title", delegate: "nil", cancelButtonTitle: "ok")
            alert.show()
        } else {
            ownedOutfits.append(outfit!)
            writeCustomObjArraytoUserDefaults(ownedOutfits, fileName: "ownedOutfits")
            
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            appDelegate.segmentedControl.selectedSegmentIndex = appDelegate.OUTFITSINDEX
//            appDelegate.segmentsController.indexDidChangeForSegmentedControl(appDelegate.segmentedControl)
//            delegate?.dismissOutfitView()
        }
    }
    
    func backButtonTapped() {
        print("backButtonTapped")
        delegate?.dismissOutfitView()
    }
    
    func outfitWithTitleExists(title: String) -> Bool {
        for outfit in ownedOutfits {
            if(outfit.title == title) {
                return true
            }
        }
        return false
    }
}

///MARK Textfield Delegate methods
extension AddOutfitView {
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
        activeTextField = textField
        print("textfieldidbeginediting")
        activeTextField?.textColor = UIColor.blackColor()
        textField.text = ""
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        return false
    }
}