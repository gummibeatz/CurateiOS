//
//  ViewController.swift
//  OutfitBuilder
//
//  Created by Kenneth Kuo on 11/5/14.
//  Copyright (c) 2014 Kenneth Kuo. All rights reserved.
//

import UIKit

protocol OutfitBuilderVCDelegate {
    func pickerViewWasTapped(image: UIImage)
}

class OutfitBuilderVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate {
    
    let shirtPicker = UIPickerView()
    let sweaterPicker = UIPickerView()
    let jacketPicker = UIPickerView()
    let pantsPicker = UIPickerView()
    let shoePicker = UIPickerView()
    
    var shirtPickerData = [String]()
    var sweaterPickerData = [String]()
    var jacketPickerData = [String]()
    var pantsPickerData = [String]()
    var shoePickerData = [String]()
    
    var outfitBuilderVCDelegate: OutfitBuilderVCDelegate?
    
    var blurEffectView: UIVisualEffectView =  UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
    
    let POPOUTSIZE = CGSize(width: 270, height: 320)
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up pickers
        setupPickerViewers()
        
        //add in picker data
        shirtPickerData.append("tshirt1.jpg")
        shirtPickerData.append("tshirt2.jpg")
        sweaterPickerData.append("tshirt1.jpg")
        sweaterPickerData.append("tshirt2.jpg")
        jacketPickerData = ["tshirt2.jpg","tshirt1.jpg"]
        pantsPickerData.append("tshirt2.jpg")
        pantsPickerData.append("tshirt1.jpg")
        shoePickerData.append("tshirt2.jpg")
        //        shoePickerData.append("tshirt1.jpg")
        
        
        //add in gesture recognizer for pickers
        setupGestureRecognizers()
        
        //setup ScrollView and add in subviews
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupGestureRecognizers() {
        var shirtSingleTapRecognizer = UITapGestureRecognizer(target: self, action: "shirtPickerViewTapGestureRecognized")
        var sweaterSingleTapRecognizer = UITapGestureRecognizer(target: self, action: "sweaterPickerViewTapGestureRecognized")
        var jacketSingleTapRecognizer = UITapGestureRecognizer(target: self, action: "jacketPickerViewTapGestureRecognized")
        var pantsSingleTapRecognizer = UITapGestureRecognizer(target: self, action: "pantsPickerViewTapGestureRecognized")
        var shoeSingleTapRecognizer = UITapGestureRecognizer(target: self, action: "shoePickerViewTapGestureRecognized")
        
        var shirtDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewDoubleTapGestureRecognized")
        var sweaterDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewDoubleTapGestureRecognized")
        var jacketDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewDoubleTapGestureRecognized")
        var pantsDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewDoubleTapGestureRecognized")
        var shoeDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewDoubleTapGestureRecognized")
        
        shirtDoubleTapRecognizer.numberOfTapsRequired = 2
        sweaterDoubleTapRecognizer.numberOfTapsRequired = 2
        jacketDoubleTapRecognizer.numberOfTapsRequired = 2
        pantsDoubleTapRecognizer.numberOfTapsRequired = 2
        shoeDoubleTapRecognizer.numberOfTapsRequired = 2
        
        shirtSingleTapRecognizer.requireGestureRecognizerToFail(shirtDoubleTapRecognizer)
        sweaterSingleTapRecognizer.requireGestureRecognizerToFail(sweaterDoubleTapRecognizer)
        jacketSingleTapRecognizer.requireGestureRecognizerToFail(jacketDoubleTapRecognizer)
        pantsSingleTapRecognizer.requireGestureRecognizerToFail(pantsDoubleTapRecognizer)
        shoeSingleTapRecognizer.requireGestureRecognizerToFail(shoeDoubleTapRecognizer)
        
        shirtPicker.addGestureRecognizer(shirtSingleTapRecognizer)
        sweaterPicker.addGestureRecognizer(sweaterSingleTapRecognizer)
        jacketPicker.addGestureRecognizer(jacketSingleTapRecognizer)
        pantsPicker.addGestureRecognizer(pantsSingleTapRecognizer)
        shoePicker.addGestureRecognizer(shoeSingleTapRecognizer)
        
        shirtPicker.addGestureRecognizer(shirtDoubleTapRecognizer)
        sweaterPicker.addGestureRecognizer(sweaterDoubleTapRecognizer)
        jacketPicker.addGestureRecognizer(jacketDoubleTapRecognizer)
        pantsPicker.addGestureRecognizer(pantsDoubleTapRecognizer)
        shoePicker.addGestureRecognizer(shoeDoubleTapRecognizer)
        
        shirtSingleTapRecognizer.delegate = self
        sweaterSingleTapRecognizer.delegate = self
        jacketSingleTapRecognizer.delegate = self
        pantsSingleTapRecognizer.delegate = self
        shoeSingleTapRecognizer.delegate = self
        
        shirtDoubleTapRecognizer.delegate = self
        sweaterDoubleTapRecognizer.delegate = self
        jacketDoubleTapRecognizer.delegate = self
        pantsDoubleTapRecognizer.delegate = self
        shoeDoubleTapRecognizer.delegate = self
    }
    
    func setupPickerViewers() {
        shirtPicker.delegate = self
        sweaterPicker.delegate = self
        jacketPicker.delegate = self
        pantsPicker.delegate = self
        shoePicker.delegate = self
        
        shirtPicker.dataSource = self
        sweaterPicker.dataSource = self
        jacketPicker.dataSource = self
        pantsPicker.dataSource = self
        shoePicker.dataSource = self
        
        shirtPicker.tag = 0
        sweaterPicker.tag = 1
        jacketPicker.tag = 2
        pantsPicker.tag = 3
        shoePicker.tag = 4
        
        
        let pickerWidth = screenWidth*3/4
        shirtPicker.frame = CGRectMake(40, 20, pickerWidth, 180)
        sweaterPicker.frame = CGRectMake(40, 170, pickerWidth, 180)
        jacketPicker.frame = CGRectMake(40, 320, pickerWidth, 180)
        pantsPicker.frame = CGRectMake(40, 470, pickerWidth, 180)
        shoePicker.frame = CGRectMake(40, 620, pickerWidth, 180)
        
        
        let rotate = CGAffineTransformScale(CGAffineTransformMakeRotation(-3.14/2), 0.25, 2.0)
        self.shirtPicker.transform = rotate
        self.sweaterPicker.transform = rotate
        self.jacketPicker.transform = rotate
        self.pantsPicker.transform = rotate
        self.shoePicker.transform = rotate
    }
    
    func setupView() {
        var fullScreenRect: CGRect = UIScreen.mainScreen().applicationFrame
        var scrollView = UIScrollView(frame: fullScreenRect)
        //        self.view = scrollView
        
        self.view.addSubview(scrollView)
        self.view.backgroundColor = UIColor.whiteColor()
        scrollView.contentSize = CGSize(width: 320, height: 758)
        scrollView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 44, right: 0)
        self.blurEffectView.frame = self.view.bounds
        scrollView.addSubview(shirtPicker)
        scrollView.addSubview(sweaterPicker)
        scrollView.addSubview(jacketPicker)
        scrollView.addSubview(pantsPicker)
        scrollView.addSubview(shoePicker)
        
    }
    
    func removeBlurEffectView() {
        blurEffectView.removeFromSuperview()
    }
    
    func shirtPickerViewTapGestureRecognized() {
        println("shirtPicker was tapped")
        var image = UIImage(named:shirtPickerData[shirtPicker.selectedRowInComponent(0)])
        self.view.addSubview(self.blurEffectView)
        outfitBuilderVCDelegate?.pickerViewWasTapped(image!)
    }
    
    
    func sweaterPickerViewTapGestureRecognized() {
        println("sweaterPicker was tapped")
        var image = UIImage(named: sweaterPickerData[sweaterPicker.selectedRowInComponent(0)])
        self.view.addSubview(self.blurEffectView)
        outfitBuilderVCDelegate?.pickerViewWasTapped(image!)
    }
    
    func jacketPickerViewTapGestureRecognized() {
        println("jacketPicker was tapped")
        var image = UIImage(named: jacketPickerData[jacketPicker.selectedRowInComponent(0)])
        self.view.addSubview(self.blurEffectView)
        outfitBuilderVCDelegate?.pickerViewWasTapped(image!)
    }
    
    func pantsPickerViewTapGestureRecognized() {
        println("pantsPicker was tapped")
        var image = UIImage(named: pantsPickerData[pantsPicker.selectedRowInComponent(0)])
        self.view.addSubview(self.blurEffectView)
        outfitBuilderVCDelegate?.pickerViewWasTapped(image!)
    }
    
    func shoePickerViewTapGestureRecognized() {
        println("shoePicker was tapped")
        var image = UIImage(named:shoePickerData[shoePicker.selectedRowInComponent(0)])
        self.view.addSubview(self.blurEffectView)
        outfitBuilderVCDelegate?.pickerViewWasTapped(image!)
    }
    
    func pickerViewDoubleTapGestureRecognized() {
        println("double tapped")
        
    }
    
    func blurEffectWasTapped(VC: UIViewController) {
        println("blur effect recognized")
        self.blurEffectView.removeFromSuperview()
    }
}

extension OutfitBuilderVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        return true
    }
}

//MARK: Data Sources UIPickerView
extension OutfitBuilderVC: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag{
        case shirtPicker.tag:
            return shirtPickerData.count
        case sweaterPicker.tag:
            return sweaterPickerData.count
        case jacketPicker.tag:
            return jacketPickerData.count
        case pantsPicker.tag:
            return pantsPickerData.count
        case shoePicker.tag:
            return shoePickerData.count
        default:
            return 0
        }
    }
}

//MARK: Delegates UIPickerView
extension OutfitBuilderVC: UIPickerViewDelegate {
    // several optional methods:
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch pickerView.tag {
        case shirtPicker.tag:
            return shirtPickerData[row]
        case sweaterPicker.tag:
            return sweaterPickerData[row]
        case jacketPicker.tag:
            return jacketPickerData[row]
        case pantsPicker.tag:
            return pantsPickerData[row]
        case shoePicker.tag:
            return shoePickerData[row]
        default:
            return "nothing"
        }
    }
    
    //        func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
    //        }
    
    func pickerView(pickerView: UIPickerView!, widthForComponent component: Int) -> CGFloat{
        return 80
    }
    
    func pickerView(pickerView: UIPickerView!, rowHeightForComponent component: Int) -> CGFloat{
        return 80
    }
    
    // func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String!
    
    // func pickerView(pickerView: UIPickerView!, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString!
    
    func pickerView(pickerView: UIPickerView!, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView!{
        var img: UIImage?
        switch pickerView.tag {
        case shirtPicker.tag:
            img = UIImage(named:shirtPickerData[row])
        case sweaterPicker.tag:
            img = UIImage(named: sweaterPickerData[row])
        case jacketPicker.tag:
            img = UIImage(named: jacketPickerData[row])
        case pantsPicker.tag:
            img = UIImage(named: pantsPickerData[row])
        case shoePicker.tag:
            img = UIImage(named: shoePickerData[row])
        default:
            img = nil
        }
        let resizedImg = RBResizeImage(img!, CGSize(width: 70, height: 70))
        let imageView = UIImageView(image: resizedImg)
        let tmpView = UIView(frame: CGRectMake(0, 0, 80, 80))
        let rotate = CGAffineTransformScale(CGAffineTransformMakeRotation(3.14/2), 0.25, 2.0)
        tmpView.transform = rotate
        tmpView.insertSubview(imageView, atIndex: 0)
        return tmpView
    }
}


