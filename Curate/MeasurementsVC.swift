//
//  ViewController.swift
//  Measurements
//
//  Created by Curate on 10/14/14.
//  Copyright (c) 2014 Curate. All rights reserved.
//

import UIKit

class MeasurementsVC: UIViewController {
    
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var user:User?
    
    //initialization constants
    let picker1 = UIPickerView()
    let picker2 = UIPickerView()
    let agePicker = UIPickerView()
    let waistPicker = UIPickerView()
    let inseamPicker = UIPickerView()
    let shirtSizePicker = UIPickerView()
    let preferredShirtFitPicker = UIPickerView()
    let preferredPantsFitPicker = UIPickerView()
    let shoeSizePicker = UIPickerView()
    
    let textField1 = UITextField()
    let textField2 = UITextField()
    let ageTextField = UITextField()
    let waistTextField = UITextField()
    let inseamTextField = UITextField()
    let shirtSizeTextField = UITextField()
    let preferredShirtFitTextField = UITextField()
    let preferredPantsFitTextField = UITextField()
    let shoeSizeTextField = UITextField()
    
    var picker1Data = [String()]
    var picker2Data = [String]()
    var agePickerData = [String]()
    var waistPickerData = [String]()
    var inseamPickerData = [String]()
    var shirtSizePickerData = [String]()
    var preferredShirtFitPickerData = [String]()
    var preferredPantsFitPickerData = [String]()
    var shoeSizePickerData = [String]()
    
    var toolbar: UIToolbar?
    var activeTextField:UITextField?
    var okButton: UIButton?
    
    var scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
    
    // Do any additional setup after loading the view, typically from a nib.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scrollview edits
        
        self.scrollView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height + 100)
        self.scrollView.scrollEnabled = false
        //scrollview edits end
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.fbLoginVC.setFBAuthToken()
        
        setupLabels()
        setupToolBar()
        addPickerData()
        
        
        //creating textfields with a pickerview
        picker1.tag = 0
        picker2.tag = 1
        agePicker.tag = 2
        waistPicker.tag = 3
        inseamPicker.tag = 4
        shirtSizePicker.tag = 5
        preferredShirtFitPicker.tag = 6
        preferredPantsFitPicker.tag = 7
        shoeSizePicker.tag = 8
        
        picker1.delegate = self
        picker1.dataSource = self
        picker1.frame = CGRectMake(0, 0, 500, 80)
        textField1.delegate = self
        textField1.inputAccessoryView = toolbar
        textField1.inputView = picker1
        textField1.frame = CGRectMake(200, 60, 100, 35)
        textField1.borderStyle = UITextBorderStyle.RoundedRect
        textField1.layer.borderColor = UIColor.grayColor().CGColor;
        textField1.layer.cornerRadius = CGFloat(5.0)
        
        picker2.frame = CGRectMake(0,0,500,80)
        picker2.selectRow(20, inComponent: 0, animated: false)
        textField2.delegate = self
        textField2.inputAccessoryView = toolbar
        textField2.inputView = picker2
        textField2.frame = CGRectMake(200, 110, 100, 35)
        textField2.borderStyle = UITextBorderStyle.RoundedRect
        textField2.layer.borderColor = UIColor.grayColor().CGColor
        textField2.layer.cornerRadius = CGFloat(5.0)
 
        agePicker.delegate = self
        agePicker.dataSource = self
        agePicker.frame = CGRectMake(0,0,500,80)
        agePicker.selectRow(20, inComponent: 0, animated: false)
        ageTextField.delegate = self
        ageTextField.inputAccessoryView = toolbar
        ageTextField.inputView = agePicker
        ageTextField.frame = CGRectMake(200, 160, 100, 35)
        ageTextField.borderStyle = UITextBorderStyle.RoundedRect
        ageTextField.layer.borderColor = UIColor.grayColor().CGColor
        ageTextField.layer.cornerRadius = CGFloat(5.0)
        
        waistPicker.delegate = self
        waistPicker.dataSource = self
        waistPicker.frame = CGRectMake(0,0,500,80)
        waistTextField.delegate = self
        waistTextField.inputAccessoryView = toolbar
        waistTextField.inputView = waistPicker
        waistTextField.frame = CGRectMake(200, 210, 100, 35)
        waistTextField.borderStyle = UITextBorderStyle.RoundedRect
        waistTextField.layer.borderColor = UIColor.grayColor().CGColor
        waistTextField.layer.cornerRadius = CGFloat(5.0)
        
        inseamPicker.delegate = self
        inseamPicker.dataSource = self
        inseamPicker.frame = CGRectMake(0,0,500,80)
        inseamTextField.delegate = self
        inseamTextField.inputAccessoryView = toolbar
        inseamTextField.inputView = inseamPicker
        inseamTextField.frame = CGRectMake(200, 260, 100, 35)
        inseamTextField.borderStyle = UITextBorderStyle.RoundedRect
        inseamTextField.layer.borderColor = UIColor.grayColor().CGColor
        inseamTextField.layer.cornerRadius = CGFloat(5.0)
        
        shirtSizePicker.delegate = self
        shirtSizePicker.dataSource = self
        shirtSizePicker.frame = CGRectMake(0,0,500,80)
        shirtSizeTextField.delegate = self
        shirtSizeTextField.inputAccessoryView = toolbar
        shirtSizeTextField.inputView = shirtSizePicker
        shirtSizeTextField.frame = CGRectMake(200, 310, 100, 35)
        shirtSizeTextField.borderStyle = UITextBorderStyle.RoundedRect
        shirtSizeTextField.layer.borderColor = UIColor.grayColor().CGColor
        shirtSizeTextField.layer.cornerRadius = CGFloat(5.0)
        
        preferredShirtFitPicker.delegate = self
        preferredShirtFitPicker.dataSource = self
        preferredShirtFitPicker.frame = CGRectMake(0,0,500,80)
        preferredShirtFitTextField.delegate = self
        preferredShirtFitTextField.inputAccessoryView = toolbar
        preferredShirtFitTextField.inputView = preferredShirtFitPicker
        preferredShirtFitTextField.frame = CGRectMake(200, 360, 100, 35)
        preferredShirtFitTextField.borderStyle = UITextBorderStyle.RoundedRect
        preferredShirtFitTextField.layer.borderColor = UIColor.grayColor().CGColor
        preferredShirtFitTextField.layer.cornerRadius = CGFloat(5.0)
        
        preferredPantsFitPicker.delegate = self
        preferredPantsFitPicker.dataSource = self
        preferredPantsFitPicker.frame = CGRectMake(0,0,500,80)
        preferredPantsFitTextField.delegate = self
        preferredPantsFitTextField.inputAccessoryView = toolbar
        preferredPantsFitTextField.inputView = preferredPantsFitPicker
        preferredPantsFitTextField.frame = CGRectMake(200, 410, 100, 35)
        preferredPantsFitTextField.borderStyle = UITextBorderStyle.RoundedRect
        preferredPantsFitTextField.layer.borderColor = UIColor.grayColor().CGColor
        preferredPantsFitTextField.layer.cornerRadius = CGFloat(5.0)
        
        shoeSizePicker.delegate = self
        shoeSizePicker.dataSource = self
        shoeSizePicker.frame = CGRectMake(0,0,500,80)
        shoeSizeTextField.delegate = self
        shoeSizeTextField.inputAccessoryView = toolbar
        shoeSizeTextField.inputView = shoeSizePicker
        shoeSizeTextField.frame = CGRectMake(200, 460, 100, 35)
        shoeSizeTextField.borderStyle = UITextBorderStyle.RoundedRect
        shoeSizeTextField.layer.borderColor = UIColor.grayColor().CGColor
        shoeSizeTextField.layer.cornerRadius = CGFloat(5.0)
        
        //Default values that will appear
        textField1.text = "height"
        textField2.text = "weight"
        ageTextField.text = "age"
        waistTextField.text = "waist"
        inseamTextField.text = "inseam"
        shirtSizeTextField.text = "shirt size"
        preferredShirtFitTextField.text = "preferred shirt fit"
        preferredPantsFitTextField.text = "preferred pants fit"
        shoeSizeTextField.text = "shoe size"
        
        textField1.textColor = UIColor.grayColor()
        textField2.textColor = UIColor.grayColor()
        ageTextField.textColor = UIColor.grayColor()
        waistTextField.textColor = UIColor.grayColor()
        inseamTextField.textColor = UIColor.grayColor()
        shirtSizeTextField.textColor = UIColor.grayColor()
        preferredShirtFitTextField.textColor = UIColor.grayColor()
        preferredPantsFitTextField.textColor = UIColor.grayColor()
        shoeSizeTextField.textColor = UIColor.grayColor()
        
        //adding objs to viewController and misc. settings
        self.view.addSubview(self.scrollView)

        self.scrollView.addSubview(textField1)
        self.scrollView.addSubview(textField2)
        self.scrollView.addSubview(ageTextField)
        self.scrollView.addSubview(waistTextField)
        self.scrollView.addSubview(inseamTextField)
        self.scrollView.addSubview(shirtSizeTextField)
        self.scrollView.addSubview(preferredShirtFitTextField)
        self.scrollView.addSubview(preferredPantsFitTextField)
        self.scrollView.addSubview(shoeSizeTextField)
        setupOkButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(hasUser("User")){
            user = getUserFromCoreData()
            textField1.text = user?.height
            textField1.textColor = UIColor.blackColor()
            textField2.text = user?.weight
            textField2.textColor = UIColor.blackColor()
            ageTextField.text = user?.age
            ageTextField.textColor = UIColor.blackColor()
            waistTextField.text = user?.waistSize
            waistTextField.textColor = UIColor.blackColor()
            inseamTextField.text = user?.inseam
            inseamTextField.textColor = UIColor.blackColor()
            shirtSizeTextField.text = user?.shirtSize
            shirtSizeTextField.textColor = UIColor.blackColor()
            preferredShirtFitTextField.text = user?.preferredShirtFit
            preferredShirtFitTextField.textColor = UIColor.blackColor()
            preferredPantsFitTextField.text = user?.preferredPantsFit
            preferredPantsFitTextField.textColor = UIColor.blackColor()
            shoeSizeTextField.text = user?.shoeSize
            shoeSizeTextField.textColor = UIColor.blackColor()
            print("has user")
        } else {
            let bufferDict: NSDictionary = NSDictionary()
            self.user = User.createInManagedObjectContext(managedObjectContext!, preferences: bufferDict)
            print("no user")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLabels() {
        let measurementLabel = UILabel()
        let stringLabel: String = "Height\nWeight\nAge\nWaist\nInseam\nShirt Size\nPreferred Shirt Fit\nPreferred Pants Fit\nShoe Size"
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: stringLabel)
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.lineSpacing = 30
        attrString.addAttribute(NSParagraphStyleAttributeName , value: style, range: NSMakeRange(0,stringLabel.characters.count))
        measurementLabel.attributedText = attrString
        measurementLabel.frame = CGRectMake(5,55, 150, 450)
        measurementLabel.numberOfLines = 10
        self.scrollView.addSubview(measurementLabel)
    }
    
    func setupToolBar() {
        //pickerview tool bar
        self.toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        var items = [UIBarButtonItem]()
        //making done button
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "donePressed")
        items.append(doneButton)
        
        self.toolbar!.barStyle = UIBarStyle.Black
        self.toolbar!.setItems(items, animated: true)
    }
    
    func addPickerData() {
        picker1Data = ["5'1''","5'2''","5'3''","5'4''","5'5''","5'6''","5'7''","5'8''","5'9''","5'10''","5'11''","6'0''","6'1''","6'2''","6'3''","6'4''","6'5''","6'6''","6'7''","6'8''","6'9''","6'10''","6'11''"]
        picker2Data = createArrayWithRange(100, end: 220)
        agePickerData = createArrayWithRange(0,end: 99)
        waistPickerData = ["26","27","28","29","30","31","32","33","34","36","38","40","42"]
        inseamPickerData = ["25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40"]
        shirtSizePickerData = ["S","M","L","XL"]
        preferredShirtFitPickerData = ["Extra Slim","Slim","Regular"]
        preferredPantsFitPickerData = ["Skinny","Slim","Regular"]
        shoeSizePickerData = ["7.5","8.0","8.5","9.0","9.5","10","10.5","11.0","11.5","12.0","12.5","13.0","13.5","14.0"]
    }
    
    //hides the inputView for a UITextField
    func donePressed() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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
    
    func setupOkButton() {
        okButton = UIButton(frame: CGRect(x: UIScreen.mainScreen().bounds.width - 75, y: 20, width: 50, height: 32))
        okButton!.addTarget(self, action: "returnButtonTapped", forControlEvents: .TouchUpInside)
        okButton!.setTitle("Done", forState: .Normal)
        okButton?.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.scrollView.addSubview(okButton!)
    }
    
    func returnButtonTapped() {
        if (textField1.text == "height" || textField2.text == "weight" || ageTextField.text == "age" || waistTextField.text == "waist" || inseamTextField.text == "inseam" || shirtSizeTextField.text == "shirt size" || preferredShirtFitTextField.text == "preferred shirt fit" || preferredPantsFitTextField == "preferred pants fit" || shoeSizeTextField.text == "shoe size") {
            let alert = UIAlertController(title: "Missing Fields", message: "Please fill in all fields to proceed", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            user?.height = textField1.text!
            user?.weight = textField2.text!
            user?.age = ageTextField.text!
            user?.waistSize = waistTextField.text!
            user?.inseam = inseamTextField.text!
            user?.shirtSize = shirtSizeTextField.text!
            user?.preferredShirtFit = preferredShirtFitTextField.text!
            user?.preferredPantsFit = preferredPantsFitTextField.text!
            user?.shoeSize = shoeSizeTextField.text!
            do {
                try self.managedObjectContext?.save()
            } catch _ {
            }
            
            let preferencesDict: NSMutableDictionary = NSMutableDictionary()
            preferencesDict.setValue(textField1.text, forKey: "height")
            preferencesDict.setValue(textField2.text, forKey: "weight")
            preferencesDict.setValue(ageTextField.text, forKey: "age")
            preferencesDict.setValue(waistTextField.text, forKey: "waist_size")
            preferencesDict.setValue(inseamTextField.text, forKey: "inseam")
            preferencesDict.setValue(preferredPantsFitTextField.text, forKey: "preferred_pants_fit")
            preferencesDict.setValue(shirtSizeTextField.text, forKey: "shirt_size")
            preferencesDict.setValue(preferredShirtFitTextField.text, forKey: "preferred_shirt_fit")
            preferencesDict.setValue(shoeSizeTextField.text, forKey: "shoe_size")
            let fbAuthToken = getFbAuthToken()
            getCurateAuthToken(fbAuthToken, completionHandler: {
                curateAuthToken in
                postUser(curateAuthToken, preferencesDict: preferencesDict)
            })
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            self.okButton!.removeFromSuperview()
            appDelegate.window!.rootViewController = appDelegate.navigationController
//            appDelegate.setupMeasurementsButton()
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
        case picker1.tag:
            return picker1Data.count
        case picker2.tag:
            return picker2Data.count
        case agePicker.tag:
            return agePickerData.count
        case waistPicker.tag:
            return waistPickerData.count
        case inseamPicker.tag:
            return inseamPickerData.count
        case shirtSizePicker.tag:
            return shirtSizePickerData.count
        case preferredShirtFitPicker.tag:
            return preferredShirtFitPickerData.count
        case preferredPantsFitPicker.tag:
            return preferredPantsFitPickerData.count
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
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case picker1.tag:
            textField1.text = picker1Data[row]
            textField1.textColor = UIColor.blackColor()
            return picker1Data[row]
        case picker2.tag:
            textField2.text = picker2Data[row]
            textField2.textColor = UIColor.blackColor()
            return picker2Data[row]
        case agePicker.tag:
            ageTextField.text = agePickerData[row]
            ageTextField.textColor = UIColor.blackColor()
            return agePickerData[row]
        case waistPicker.tag:
            waistTextField.text = waistPickerData[row]
            waistTextField.textColor = UIColor.blackColor()
            return waistPickerData[row]
        case inseamPicker.tag:
            inseamTextField.text = inseamPickerData[row]
            inseamTextField.textColor = UIColor.blackColor()
            return inseamPickerData[row]
        case shirtSizePicker.tag:
            shirtSizeTextField.text = shirtSizePickerData[row]
            shirtSizeTextField.textColor = UIColor.blackColor()
            return shirtSizePickerData[row]
        case preferredShirtFitPicker.tag:
            preferredShirtFitTextField.text = preferredShirtFitPickerData[row]
            preferredShirtFitTextField.textColor = UIColor.blackColor()
            return preferredShirtFitPickerData[row]
        case preferredPantsFitPicker.tag:
            preferredPantsFitTextField.text = preferredPantsFitPickerData[row]
            preferredPantsFitTextField.textColor = UIColor.blackColor()
            return preferredPantsFitPickerData[row]
        case shoeSizePicker.tag:
            shoeSizeTextField.text = shoeSizePickerData[row]
            shoeSizeTextField.textColor = UIColor.blackColor()
            return shoeSizePickerData[row]
        default:
            return "nothing"
        }
    }
    
    // maybe go back to this if scrolling lags too much
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case picker1.tag:
            textField1.text = picker1Data[row]
            textField1.textColor = UIColor.blackColor()
        case picker2.tag:
            textField2.text = picker2Data[row]
            textField2.textColor = UIColor.blackColor()
        case agePicker.tag:
            ageTextField.text = agePickerData[row]
            ageTextField.textColor = UIColor.blackColor()
        case waistPicker.tag:
            waistTextField.text = waistPickerData[row]
            waistTextField.textColor = UIColor.blackColor()
        case inseamPicker.tag:
            inseamTextField.text = inseamPickerData[row]
            inseamTextField.textColor = UIColor.blackColor()
        case shirtSizePicker.tag:
            shirtSizeTextField.text = shirtSizePickerData[row]
            shirtSizeTextField.textColor = UIColor.blackColor()
        case preferredShirtFitPicker.tag:
            preferredShirtFitTextField.text = preferredShirtFitPickerData[row]
            preferredShirtFitTextField.textColor = UIColor.blackColor()
        case preferredPantsFitPicker.tag:
            preferredPantsFitTextField.text = preferredPantsFitPickerData[row]
            preferredPantsFitTextField.textColor = UIColor.blackColor()
        case shoeSizePicker.tag:
            shoeSizeTextField.text = shoeSizePickerData[row]
            shoeSizeTextField.textColor = UIColor.blackColor()
        default:
            NSLog("Not here")
        }
    }
    
}

//Mark: Delegate UITextField
extension MeasurementsVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        //maybe not make magic numbers. calculate size of keyboard
        scrollView.setContentOffset(CGPoint(x: 0, y: 160), animated: true)
    }
}



