//
//  AddOutfitView.swift
//  Curate
//
//  Created by Kenneth Kuo on 4/30/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation
import UIKit

protocol AddOutfitViewDelegate {
    func dismissOutfitView()
}

class AddOutfitView: UIView, UITextFieldDelegate {
    
    var titleTextField: UITextField?
    var outfitTags:Array<String> = [String]()
    var activeTextField: UITextField?
    var okButton: UIButton?
    var cancelButton: UIButton?
    var outfit: Outfit?
    var ownedOutfits: [Outfit] = readCustomObjArrayFromUserDefaults("ownedOutfits") as! [Outfit]
    var delegate: AddOutfitViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
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
        var labels: UILabel = UILabel(frame: CGRect(x: 10, y: 40, width: 35, height: 80))
        labels.text = "Title\n\nTag"
        labels.numberOfLines = 3
        labels.textAlignment = .Left
        
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        var items = [UIBarButtonItem]()
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "donePressed")
        items.append(doneButton)
        
        toolbar.barStyle = UIBarStyle.Black
        toolbar.setItems(items, animated: true)
        
        titleTextField = UITextField(frame: CGRect(x: self.frame.width/2 - 50, y: 40, width: 160, height: 30))
        titleTextField!.borderStyle = UITextBorderStyle.Bezel
        titleTextField!.layer.borderColor = UIColor.grayColor().CGColor;
        titleTextField!.layer.cornerRadius = CGFloat(5.0)
        titleTextField!.delegate = self
        titleTextField!.inputAccessoryView = toolbar
        titleTextField!.tag = 0
        titleTextField?.textColor = UIColor.grayColor()
        titleTextField?.text = "title"
        
        var tagTextField: UITextField = UITextField(frame: CGRect(x: self.frame.width/2 - 50 , y: 90, width: 160, height: 30))
        tagTextField.borderStyle = UITextBorderStyle.Bezel
        tagTextField.layer.borderColor = UIColor.grayColor().CGColor;
        tagTextField.layer.cornerRadius = CGFloat(5.0)
        tagTextField.delegate = self
        tagTextField.inputAccessoryView = toolbar
        tagTextField.tag = 1
        tagTextField.textColor = UIColor.grayColor()
        tagTextField.text = "#hashtags"

        self.addSubview(labels)
        self.addSubview(titleTextField!)
        self.addSubview(tagTextField)
    }
    
    func setupButtons() {
        okButton = UIButton(frame: CGRect(x: UIScreen.mainScreen().bounds.midX - 80, y: 350, width: 50, height: 32))
        okButton!.addTarget(self, action: "okButtonTapped", forControlEvents: .TouchUpInside)
        okButton!.setImage(UIImage(named: "okButton"), forState: .Normal)
        
        cancelButton = UIButton(frame: CGRect(x: UIScreen.mainScreen().bounds.midX, y: 350, width: 80, height: 32))
        cancelButton!.addTarget(self, action: "cancelButtonTapped", forControlEvents: .TouchUpInside)
        cancelButton!.setImage(UIImage(named: "cancelButton"), forState: .Normal)
        
        self.addSubview(okButton!)
        self.addSubview(cancelButton!)
    }
    
    func donePressed() {
        activeTextField?.resignFirstResponder()
        println("donePressed")
    }
    
    func okButtonTapped() {
        println("okButtonTapped")
        self.outfit!.title = titleTextField!.text!
        self.outfit!.tags = outfitTags
        // need to find some other way to double check outfit
        
//        if( find(ownedOutfits, self.outfit) != nil) {
//            println("outfit already exists")
//        } else
        
        if (outfitWithTitleExists(outfit!.title!)) {
            println("title already exists")
            var alert: UIAlertView = UIAlertView(title: "Outfit with same title", message: "choose another title", delegate: "nil", cancelButtonTitle: "ok")
            alert.show()
        } else {
            ownedOutfits.append(outfit!)
            writeCustomObjArraytoUserDefaults(ownedOutfits, "ownedOutfits")
            
            var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.segmentedControl.selectedSegmentIndex = appDelegate.OUTFITSINDEX
            appDelegate.segmentsController.indexDidChangeForSegmentedControl(appDelegate.segmentedControl)
            delegate?.dismissOutfitView()
        }
    }
    
    func cancelButtonTapped() {
        println("cancelButtonTapped")
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
extension AddOutfitView: UITextFieldDelegate{
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
        activeTextField = textField
        println("textfieldidbeginediting")
        activeTextField?.textColor = UIColor.blackColor()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        if textField.tag == 1 {
            outfitTags.append(textField.text!)
            textField.text = ""
            println("outfitTags = \(outfitTags)")
            return true
        }
        return false
    }
}