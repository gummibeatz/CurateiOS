//
//  ViewController.swift
//  OutfitBuilder
//
//  Created by Kenneth Kuo on 11/5/14.
//  Copyright (c) 2014 Kenneth Kuo. All rights reserved.
//

import UIKit

class OutfitBuilderVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let topPicker = UIPickerView()
    let bottomPicker = UIPickerView()
    let shoePicker = UIPickerView()
    var topPickerData = [String]()
    var bottomPickerData = [String]()
    var shoePickerData = [String]()
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up pickers
        topPicker.delegate = self
        bottomPicker.delegate = self
        shoePicker.delegate = self
        topPicker.dataSource = self
        bottomPicker.dataSource = self
        shoePicker.dataSource = self
        
        topPicker.tag = 0
        bottomPicker.tag = 1
        shoePicker.tag = 2
        
        let pickerWidth = screenWidth*3/4
        topPicker.frame = CGRectMake(40, 20, pickerWidth, 180)
        bottomPicker.frame = CGRectMake(40, 170, pickerWidth, 180)
        shoePicker.frame = CGRectMake(40, 320, pickerWidth, 180)
        
        
        let rotate = CGAffineTransformScale(CGAffineTransformMakeRotation(-3.14/2), 0.25, 2.0)
        self.topPicker.transform = rotate
        self.bottomPicker.transform = rotate
        self.shoePicker.transform = rotate
        
        //add in picker data
        topPickerData.append("tshirt1.jpg")
        topPickerData.append("tshirt2.jpg")
        bottomPickerData.append("tshirt1.jpg")
        bottomPickerData.append("tshirt2.jpg")
        shoePickerData.append("tshirt2.jpg")
        shoePickerData.append("tshirt1.jpg")
        
        
        //adding objs to viewController and misc. settings
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(topPicker)
        self.view.addSubview(bottomPicker)
        self.view.addSubview(shoePicker)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Data Sources UIPickerView
extension OutfitBuilderVC: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag{
        case topPicker.tag:
            return topPickerData.count
        case bottomPicker.tag:
            return bottomPickerData.count
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
        case topPicker.tag:
            return topPickerData[row]
        case bottomPicker.tag:
            println("in bottompicker delegate")
            return bottomPickerData[row]
        case shoePicker.tag:
            return shoePickerData[row]
        default:
            return "nothing"
        }
    }
    
    //        func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    
    func pickerView(pickerView: UIPickerView!, widthForComponent component: Int) -> CGFloat{
        return 80
    }
    
    func pickerView(pickerView: UIPickerView!, rowHeightForComponent component: Int) -> CGFloat{
        return 80
    }
    
    // func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String!
    
    // func pickerView(pickerView: UIPickerView!, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString!
    
    func pickerView(pickerView: UIPickerView!, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView!{
        let img = UIImage(named:topPickerData[row])
        let resizedImg = RBResizeImage(img, CGSize(width: 70, height: 70))
        let imageView = UIImageView(image: resizedImg)
        let tmpView = UIView(frame: CGRectMake(0, 0, 80, 80))
        let rotate = CGAffineTransformScale(CGAffineTransformMakeRotation(3.14/2), 0.25, 2.0)
        tmpView.transform = rotate
        tmpView.insertSubview(imageView, atIndex: 0)
        return tmpView
    }
}


