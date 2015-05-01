//
//  ViewController.swift
//  Measurements
//
//  Created by Kenneth Kuo on 10/14/14.
//  Copyright (c) 2014 Kenneth Kuo. All rights reserved.
//

import UIKit

class MeasurementsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    

    
    //initialization constants
    let heightPicker = UIPickerView()
    let weightPicker = UIPickerView()
    let agePicker = UIPickerView()
    let waistPicker = UIPickerView()
    let inseamPicker = UIPickerView()
    let shirtSizePicker = UIPickerView()
    let preferredFitPicker = UIPickerView()
    let shoeSizePicker = UIPickerView()
    
    let heightTextField = UITextField()
    let weightTextField = UITextField()
    let ageTextField = UITextField()
    let waistTextField = UITextField()
    let inseamTextField = UITextField()
    let shirtSizeTextField = UITextField()
    let preferredFitTextField = UITextField()
    let shoeSizeTextField = UITextField()
    
    let heightPickerData = ["5'1''","5'2''","5'3''","5'4''","5'5''","5'6''","5'7''","5'8''","5'9''","5'10''","5'11''","6'0''","6'1''","6'2''","6'3''","6'4''","6'5''","6'6''","6'7''","6'8''","6'9''","6'10''","6'11''"]
    var weightPickerData = [String]()
    var agePickerData = [String]()
    let waistPickerData = ["28","29","30","31","32","33","34","36","38","40","42"]
    let inseamPickerData = ["29","30","31","32","33","34","35","36","37","38","39","40"]
    let shirtSizePickerData = ["S","M","L","XL"]
    let preferredFitPickerData = ["Tailored","Extra Slim","Slim","Regular","Loose"]
    let shoeSizePickerData = ["7.5","8.0","8.5","9.0","9.5","10","10.5","11.0","11.5","12.0","12.5","13.0","13.5","14.0"]
    
    var activeTextField:UITextField?
    var okButton: UIButton?
    
    // Do any additional setup after loading the view, typically from a nib.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.fbLoginVC.setFBAuthToken()
        
        //creating labels
        let measurementLabel = UILabel()
        measurementLabel.text = "Height\n\nWeight\n\nAge\n\nWaist\n\nInseam\n\nShirt Size\n\nPreferred Fit\n\nShoe Size"
        measurementLabel.font = UIFont(name: "Avenir-Light", size: 18)
        measurementLabel.textColor = UIColor.blackColor()
        measurementLabel.textAlignment = .Left
        measurementLabel.frame = CGRectMake(5,0, 200, 500)
        measurementLabel.numberOfLines = 16
        
        //pickerview tool bar
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        var items = [AnyObject]()
        //making done button
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "donePressed")
        items.append(doneButton)
        
        toolbar.barStyle = UIBarStyle.Black
        toolbar.setItems(items, animated: true)
        
        //adding additional pickerdata
        weightPickerData = createArrayWithRange(100, end: 220)
        agePickerData = createArrayWithRange(0,end: 99)
        
        //creating textfields with a pickerview
        heightPicker.tag = 0
        weightPicker.tag = 1
        agePicker.tag = 2
        waistPicker.tag = 3
        inseamPicker.tag = 4
        shirtSizePicker.tag = 5
        preferredFitPicker.tag = 6
        shoeSizePicker.tag = 7
        
        heightPicker.delegate = self
        heightPicker.dataSource = self
        heightPicker.frame = CGRectMake(0, 0, 500, 80)
        heightTextField.delegate = self
        heightTextField.inputAccessoryView = toolbar
        heightTextField.inputView = heightPicker
        heightTextField.frame = CGRectMake(200, 55, 100, 35)
        heightTextField.backgroundColor = UIColor.blueColor()
        
        weightPicker.delegate = self
        weightPicker.dataSource = self
        weightPicker.frame = CGRectMake(0,0,500,80)
        weightPicker.selectRow(20, inComponent: 0, animated: false)
        weightTextField.delegate = self
        weightTextField.inputAccessoryView = toolbar
        weightTextField.inputView = weightPicker
        weightTextField.frame = CGRectMake(200, 105, 100, 35)
        weightTextField.backgroundColor = UIColor.blueColor()
        weightTextField.text = "120"
        
        agePicker.delegate = self
        agePicker.dataSource = self
        agePicker.frame = CGRectMake(0,0,500,80)
        agePicker.selectRow(20, inComponent: 0, animated: false)
        ageTextField.delegate = self
        ageTextField.inputAccessoryView = toolbar
        ageTextField.inputView = agePicker
        ageTextField.frame = CGRectMake(200, 155, 100, 35)
        ageTextField.backgroundColor = UIColor.blueColor()
        ageTextField.text = "20"
        
        waistPicker.delegate = self
        waistPicker.dataSource = self
        waistPicker.frame = CGRectMake(0,0,500,80)
        waistTextField.delegate = self
        waistTextField.inputAccessoryView = toolbar
        waistTextField.inputView = waistPicker
        waistTextField.frame = CGRectMake(200, 205, 100, 35)
        waistTextField.backgroundColor = UIColor.blueColor()
        
        inseamPicker.delegate = self
        inseamPicker.dataSource = self
        inseamPicker.frame = CGRectMake(0,0,500,80)
        inseamTextField.delegate = self
        inseamTextField.inputAccessoryView = toolbar
        inseamTextField.inputView = inseamPicker
        inseamTextField.frame = CGRectMake(200, 255, 100, 35)
        inseamTextField.backgroundColor = UIColor.blueColor()
        
        shirtSizePicker.delegate = self
        shirtSizePicker.dataSource = self
        shirtSizePicker.frame = CGRectMake(0,0,500,80)
        shirtSizeTextField.delegate = self
        shirtSizeTextField.inputAccessoryView = toolbar
        shirtSizeTextField.inputView = shirtSizePicker
        shirtSizeTextField.frame = CGRectMake(200, 305, 100, 35)
        shirtSizeTextField.backgroundColor = UIColor.blueColor()
        
        preferredFitPicker.delegate = self
        preferredFitPicker.dataSource = self
        preferredFitPicker.frame = CGRectMake(0,0,500,80)
        preferredFitTextField.delegate = self
        preferredFitTextField.inputAccessoryView = toolbar
        preferredFitTextField.inputView = preferredFitPicker
        preferredFitTextField.frame = CGRectMake(200, 355, 100, 35)
        preferredFitTextField.backgroundColor = UIColor.blueColor()
        
        shoeSizePicker.delegate = self
        shoeSizePicker.dataSource = self
        shoeSizePicker.frame = CGRectMake(0,0,500,80)
        shoeSizeTextField.delegate = self
        shoeSizeTextField.inputAccessoryView = toolbar
        shoeSizeTextField.inputView = shoeSizePicker
        shoeSizeTextField.frame = CGRectMake(200, 405, 100, 35)
        shoeSizeTextField.backgroundColor = UIColor.blueColor()
        
        
        
        //adding objs to viewController and misc. settings
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(measurementLabel)
        self.view.addSubview(heightTextField)
        self.view.addSubview(weightTextField)
        self.view.addSubview(ageTextField)
        self.view.addSubview(waistTextField)
        self.view.addSubview(inseamTextField)
        self.view.addSubview(shirtSizeTextField)
        self.view.addSubview(preferredFitTextField)
        self.view.addSubview(shoeSizeTextField)
        setupOkButton()
    }
    
    //hides the inputView for a UITextField
    func donePressed() {
        activeTextField?.resignFirstResponder()
    }
    
    //adds required elements to an array, must input the range
    func createArrayWithRange(start: Int, end: Int) -> [String] {
        var arr = [String]()
        for index in start...end{
            arr.append(String(index))
        }
        return arr
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupOkButton() {
        okButton = UIButton(frame: CGRect(x: UIScreen.mainScreen().bounds.midX - 20, y: 500, width: 50, height: 32))
        okButton!.addTarget(self, action: "returnButtonTapped", forControlEvents: .TouchUpInside)
        okButton!.setImage(UIImage(named: "okButton"), forState: .Normal)
        self.view.addSubview(okButton!)
    }
    
    func returnButtonTapped() {
        if (heightTextField.text.isEmpty || weightTextField.text.isEmpty || ageTextField.text.isEmpty || waistTextField.text.isEmpty || inseamTextField.text.isEmpty || shirtSizeTextField.text.isEmpty || preferredFitTextField.text.isEmpty || shoeSizeTextField.text.isEmpty) {
            var alert = UIAlertController(title: "Missing Fields", message: "Please fill in all fields to proceed", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            self.okButton!.removeFromSuperview()
            appDelegate.window?.rootViewController = appDelegate.navigationController
            appDelegate.setupMeasurementsButton()
        }
    }
}

//MARK: Data Sources UIPickerView
extension MeasurementsVC: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag{
        case heightPicker.tag:
            return heightPickerData.count
        case weightPicker.tag:
            return weightPickerData.count
        case agePicker.tag:
            return agePickerData.count
        case waistPicker.tag:
            return waistPickerData.count
        case inseamPicker.tag:
            return inseamPickerData.count
        case shirtSizePicker.tag:
            return shirtSizePickerData.count
        case preferredFitPicker.tag:
            return preferredFitPickerData.count
        case shoeSizePicker.tag:
            return shoeSizePickerData.count
        default:
            return 0
        }
    }
}

//MARK: Delegates UIPickerView
extension MeasurementsVC: UIPickerViewDelegate {
    // several optional methods:
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch pickerView.tag {
        case heightPicker.tag:
            return heightPickerData[row]
        case weightPicker.tag:
            return weightPickerData[row]
        case agePicker.tag:
            return agePickerData[row]
        case waistPicker.tag:
            return waistPickerData[row]
        case inseamPicker.tag:
            return inseamPickerData[row]
        case shirtSizePicker.tag:
            return shirtSizePickerData[row]
        case preferredFitPicker.tag:
            return preferredFitPickerData[row]
        case shoeSizePicker.tag:
            return shoeSizePickerData[row]
        default:
            return "nothing"
        }
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case heightPicker.tag:
            heightTextField.text = heightPickerData[row]
        case weightPicker.tag:
            weightTextField.text = weightPickerData[row]
        case agePicker.tag:
            ageTextField.text = agePickerData[row]
        case waistPicker.tag:
            waistTextField.text = waistPickerData[row]
        case inseamPicker.tag:
            inseamTextField.text = inseamPickerData[row]
        case shirtSizePicker.tag:
            shirtSizeTextField.text = shirtSizePickerData[row]
        case preferredFitPicker.tag:
            preferredFitTextField.text = preferredFitPickerData[row]
        case shoeSizePicker.tag:
            shoeSizeTextField.text = shoeSizePickerData[row]
        default:
            NSLog("Not here")
        }
    }
    
    // func pickerView(pickerView: UIPickerView!, widthForComponent component: Int) -> CGFloat
    
    // func pickerView(pickerView: UIPickerView!, rowHeightForComponent component: Int) -> CGFloat
    
    // func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String!
    
    // func pickerView(pickerView: UIPickerView!, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString!
    
    // func pickerView(pickerView: UIPickerView!, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView!
}

//Mark: Delegate UITextField
extension MeasurementsVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField!) {
        activeTextField = textField
    }
}



