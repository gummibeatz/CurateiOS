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

class OutfitBuilderVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate, AddOutfitViewDelegate {
    
    var addOutfitView: AddOutfitView?
    
    let shirtPicker = UIPickerView()
    let sweaterPicker = UIPickerView()
    let jacketPicker = UIPickerView()
    let pantsPicker = UIPickerView()
    let shoePicker = UIPickerView()
    
    var shirtPickerData:[Top] = [Top]()
    var sweaterPickerData:[Sweater] = [Sweater]()
    var jacketPickerData:[Jacket] = [Jacket]()
    var pantsPickerData:[Bottom] = [Bottom]()
    var shoePickerData:[Shoes] = [Shoes]()
    
    var outfitBuilderVCDelegate: OutfitBuilderVCDelegate?
    var ownedOutfits: [Outfit] = readCustomObjArrayFromUserDefaults("ownedOutfits") as [Outfit]
    
    var blurEffectView: UIVisualEffectView =  UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
    
    let POPOUTSIZE = CGSize(width: 270, height: 320)
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up pickers
        setupPickerViewers()
        
        //add in gesture recognizer for pickers
        setupGestureRecognizers()
        
        //setup ScrollView and add in subviews
        setupView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("AYYYY")
        shirtPickerData = readCustomObjArrayFromUserDefaults("ownedTops") as [Top]
        sweaterPickerData = readCustomObjArrayFromUserDefaults("ownedSweaters") as [Sweater]
        jacketPickerData = readCustomObjArrayFromUserDefaults("ownedJackets") as [Jacket]
        pantsPickerData = readCustomObjArrayFromUserDefaults("ownedBottoms") as [Bottom]
        println("pantspickerdatacount = \(pantsPickerData.count)")
        shoePickerData = readCustomObjArrayFromUserDefaults("ownedShoes") as [Shoes]
        
        shirtPicker.reloadAllComponents()
        sweaterPicker.reloadAllComponents()
        jacketPicker.reloadAllComponents()
        pantsPicker.reloadAllComponents()
        shoePicker.reloadAllComponents()
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
        shirtPicker.frame = CGRectMake(40, 0, pickerWidth, 180)
        sweaterPicker.frame = CGRectMake(40, 150, pickerWidth, 180)
        jacketPicker.frame = CGRectMake(40, 300, pickerWidth, 180)
        pantsPicker.frame = CGRectMake(40, 450, pickerWidth, 180)
        shoePicker.frame = CGRectMake(40, 600, pickerWidth, 180)
        
        
        let rotate = CGAffineTransformScale(CGAffineTransformMakeRotation(-3.14/2), 0.25, 2.0)
        self.shirtPicker.transform = rotate
        self.sweaterPicker.transform = rotate
        self.jacketPicker.transform = rotate
        self.pantsPicker.transform = rotate
        self.shoePicker.transform = rotate
    }
    
    func setupView() {
        var fullScreenRect: CGRect = UIScreen.mainScreen().bounds
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
        setupToolBar()
    }
    
    func setupToolBar() {
        var toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height - 44, width: UIScreen.mainScreen().bounds.size.width, height: 44))
        var items: Array<UIBarButtonItem> =  []
        var addImage: UIImage = UIImage(named: "addButton")!
        addImage = RBResizeImage(addImage, CGSize(width: 35, height: 35))
        items.append(UIBarButtonItem(image: addImage.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: "addOutfit"))
        toolBar.setItems(items, animated: false)
        self.view.addSubview(toolBar)
    }
    
    func removeBlurEffectView() {
        blurEffectView.removeFromSuperview()
    }
    
    func addOutfit() {
        println("addOutfit Button hit")
        var outfit: Outfit = Outfit()
        outfit.top = shirtPickerData[shirtPicker.selectedRowInComponent(0)]
        outfit.sweater = sweaterPickerData[sweaterPicker.selectedRowInComponent(0)]
        outfit.jacket = jacketPickerData[jacketPicker.selectedRowInComponent(0)]
        outfit.bottom = pantsPickerData[pantsPicker.selectedRowInComponent(0)]
        outfit.shoes = shoePickerData[shoePicker.selectedRowInComponent(0)]
        self.addOutfitView = AddOutfitView(frame: CGRect(x: 20, y: 100, width: screenWidth-40, height: UIScreen.mainScreen().bounds.height - 150), outfit: outfit)
        addOutfitView?.delegate = self
        self.view.addSubview(blurEffectView)
        self.view.addSubview(self.addOutfitView!)
    }
    
    func shirtPickerViewTapGestureRecognized() {
        println("shirtPicker was tapped")
        var image:UIImage = UIImage(data: shirtPickerData[shirtPicker.selectedRowInComponent(0)].imageData!)!
        self.view.addSubview(self.blurEffectView)
        outfitBuilderVCDelegate?.pickerViewWasTapped(image)
    }
    
    
    func sweaterPickerViewTapGestureRecognized() {
        println("sweaterPicker was tapped")
        var image:UIImage = UIImage(data: sweaterPickerData[sweaterPicker.selectedRowInComponent(0)].image!)!
        self.view.addSubview(self.blurEffectView)
        outfitBuilderVCDelegate?.pickerViewWasTapped(image)
    }
    
    func jacketPickerViewTapGestureRecognized() {
        println("jacketPicker was tapped")
        var image:UIImage = UIImage(data: jacketPickerData[jacketPicker.selectedRowInComponent(0)].image!)!
        self.view.addSubview(self.blurEffectView)
        outfitBuilderVCDelegate?.pickerViewWasTapped(image)
    }
    
    func pantsPickerViewTapGestureRecognized() {
        println("pantsPicker was tapped")
        var image:UIImage = UIImage(data: pantsPickerData[pantsPicker.selectedRowInComponent(0)].imageData!)!
        self.view.addSubview(self.blurEffectView)
        outfitBuilderVCDelegate?.pickerViewWasTapped(image)
    }
    
    func shoePickerViewTapGestureRecognized() {
        println("shoePicker was tapped")
        var image:UIImage = UIImage(data:shoePickerData[shoePicker.selectedRowInComponent(0)].image!)!
        self.view.addSubview(self.blurEffectView)
        outfitBuilderVCDelegate?.pickerViewWasTapped(image)
    }
    
    func pickerViewDoubleTapGestureRecognized() {
        println("double tapped")
        
    }
    
    func blurEffectWasTapped(VC: UIViewController) {
        println("blur effect recognized")
        self.blurEffectView.removeFromSuperview()
    }
    
    func dismissOutfitView() {
        self.blurEffectView.removeFromSuperview()
        self.addOutfitView?.removeFromSuperview()
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
            return "MUST CHANGE LATER"
        case sweaterPicker.tag:
            return "MUST CHANGE LATER"
        case jacketPicker.tag:
            return "MUST CHANGE LATER"
        case pantsPicker.tag:
            return "MUST CHANGE LATER"
        case shoePicker.tag:
            return "MUST CHANGE LATER"
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
            img = UIImage(data:shirtPickerData[row].imageData!)
        case sweaterPicker.tag:
            img = UIImage(data: sweaterPickerData[row].image!)
        case jacketPicker.tag:
            img = UIImage(data: jacketPickerData[row].image!)
        case pantsPicker.tag:
            img = UIImage(data: pantsPickerData[row].imageData!)
        case shoePicker.tag:
            img = UIImage(data: shoePickerData[row].image!)
        default:
            img = nil
        }
        let resizedImg = RBResizeImage(img!, CGSize(width: 120, height: 100))
        let imageView = UIImageView(image: resizedImg)
        let tmpView = UIView(frame: CGRectMake(0, 0, 130, 130))
        let rotate = CGAffineTransformScale(CGAffineTransformMakeRotation(3.14/2), 0.25, 2.0)
        tmpView.transform = rotate
        tmpView.insertSubview(imageView, atIndex: 0)
        return tmpView
    }
}


