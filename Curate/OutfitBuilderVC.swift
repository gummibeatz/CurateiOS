//
//  ViewController.swift
//  OutfitBuilder
//
//  Created by Kenneth Kuo on 11/5/14.
//  Copyright (c) 2014 Kenneth Kuo. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

protocol OutfitBuilderVCDelegate {
    func pickerViewWasTapped(image: UIImage)
}

class OutfitBuilderVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate, AddOutfitViewDelegate {
    
    var addOutfitView: AddOutfitView?
    var scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
    var addedPickers:[Bool] = [false,false,false,false,false]
    
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
    
    var locations = []
    let locationManager = CLLocationManager()
    
    var temp:Double = 0
    var curateAuthToken:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurateAuthToken(getFbAuthToken(), {
            curateAuthtoken in
            self.curateAuthToken = curateAuthtoken
        })
        
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            println("Clauthorizationstatus not determined")
            locationManager.requestWhenInUseAuthorization()
        } else if CLLocationManager.locationServicesEnabled() {
            println("CLauthorizationstatus location services enabled")
            locationManager.startUpdatingLocation()
        }
        
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
        shoePickerData = readCustomObjArrayFromUserDefaults("ownedShoes") as [Shoes]
        
        //adds in pickers if they have more than just NA symbol.
        if(shirtPickerData.count > 1 && addedPickers[0] == false) {
            scrollView.addSubview(shirtPicker)
            shirtPicker.selectRow(1, inComponent: 0, animated: false)
            addedPickers[0] = true
        }
        if(sweaterPickerData.count > 1 && addedPickers[1] == false) {
            scrollView.addSubview(sweaterPicker)
            sweaterPicker.selectRow(1, inComponent: 0, animated: false)
            addedPickers[1] = true
        }
        if(jacketPickerData.count > 1 && addedPickers[2] == false) {
            scrollView.addSubview(jacketPicker)
            jacketPicker.selectRow(1, inComponent: 0, animated: false)
            addedPickers[2] = true
        }
        if(pantsPickerData.count > 1 && addedPickers[3] == false) {
            scrollView.addSubview(pantsPicker)
            pantsPicker.selectRow(1, inComponent: 0, animated: false)
            addedPickers[3] = true
        }
        if(shoePickerData.count > 1 && addedPickers[4] == false) {
            scrollView.addSubview(shoePicker)
            shoePicker.selectRow(1, inComponent: 0, animated: false)
            addedPickers[4] = true
        }
        
        //reloads data
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
        var shirtSingleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewSingleTapGestureRecognized:")
        var sweaterSingleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewSingleTapGestureRecognized:")
        var jacketSingleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewSingleTapGestureRecognized:")
        var pantsSingleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewSingleTapGestureRecognized:")
        var shoeSingleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewSingleTapGestureRecognized:")
        
        var shirtDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewDoubleTapGestureRecognized:")
        var sweaterDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewDoubleTapGestureRecognized:")
        var jacketDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewDoubleTapGestureRecognized:")
        var pantsDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewDoubleTapGestureRecognized:")
        var shoeDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewDoubleTapGestureRecognized:")
        
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
        self.view.addSubview(scrollView)
        self.view.backgroundColor = UIColor.whiteColor()
        scrollView.contentSize = CGSize(width: 320, height: 758)
        scrollView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 44, right: 0)
        self.blurEffectView.frame = self.view.bounds
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
    
    func pickerViewSingleTapGestureRecognized(sender: UITapGestureRecognizer) {
        let pickerView: UIPickerView = sender.view as UIPickerView
        var image:UIImage?
        switch pickerView.tag {
        case shirtPicker.tag:
            image = UIImage(data: shirtPickerData[shirtPicker.selectedRowInComponent(0)].imageData!)!
        case sweaterPicker.tag:
            image = UIImage(data: sweaterPickerData[sweaterPicker.selectedRowInComponent(0)].image!)!
        case jacketPicker.tag:
            image = UIImage(data: jacketPickerData[jacketPicker.selectedRowInComponent(0)].image!)!
        case pantsPicker.tag:
            image = UIImage(data: pantsPickerData[pantsPicker.selectedRowInComponent(0)].imageData!)!
        case shoePicker.tag:
            image = UIImage(data:shoePickerData[shoePicker.selectedRowInComponent(0)].image!)!
        default:
            image = UIImage()
        }
        self.view.addSubview(self.blurEffectView)
        outfitBuilderVCDelegate?.pickerViewWasTapped(image!)
    }
    
    func pickerViewDoubleTapGestureRecognized(sender: UITapGestureRecognizer ) {
        println("double tapped")
        var baseClothing: String?
        let pickerView: UIPickerView = sender.view as UIPickerView
        switch pickerView.tag {
        case shirtPicker.tag:
            baseClothing = shirtPickerData[shirtPicker.selectedRowInComponent(0)].fileName!
        case sweaterPicker.tag:
            println()
        case jacketPicker.tag:
            println()
        case pantsPicker.tag:
            baseClothing = pantsPickerData[pantsPicker.selectedRowInComponent(0)].fileName!
        case shoePicker.tag:
            println()
        default:
            println()
        }

        getMatches(self.curateAuthToken!, self.temp, baseClothing!, {
            matchDict in
            println(matchDict)
        })
        
    }
    
    func blurEffectWasTapped(VC: UIViewController) {
        println("blur effect recognized")
        self.blurEffectView.removeFromSuperview()
    }
    
    func dismissOutfitView() {
        self.blurEffectView.removeFromSuperview()
        self.addOutfitView?.removeFromSuperview()
    }
    
    func getLocation() {
        var coord = locations.lastObject as CLLocation
        var lat = coord.coordinate.latitude
        var long = coord.coordinate.longitude
        println("(\(lat),\(long))")
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
        let resizedImg = RBResizeImage(img!, CGSize(width: 280, height: 120))
        let imageView = UIImageView(image: resizedImg)
        let tmpView = UIView(frame: CGRectMake(0, 0, 130, 130))
        let rotate = CGAffineTransformScale(CGAffineTransformMakeRotation(3.14/2), 0.25, 2.0)
        tmpView.transform = rotate
        tmpView.insertSubview(imageView, atIndex: 0)
        return tmpView
    }
}

//MARK: Delegates CLLocationManager
extension OutfitBuilderVC: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]){
        locationManager.startUpdatingLocation()
        var location: CLLocation = locations.last as CLLocation
        var lat: CLLocationDegrees = location.coordinate.latitude
        var lon: CLLocationDegrees = location.coordinate.longitude
        //        println("in did update location")
        //        println("(\(lat),\(long)")
        self.locations = locations
        getWeatherWithLocation(lat, lon, {
            currentTemp in
            self.temp = currentTemp
        })
        
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.AuthorizedAlways || status == CLAuthorizationStatus.AuthorizedWhenInUse) {
            manager.startUpdatingLocation()
        }
    }
    
}


