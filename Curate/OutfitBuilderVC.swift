//
//  ViewController.swift
//  OutfitBuilder
//
//  Created by Curate on 11/5/14.
//  Copyright (c) 2014 Curate. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

protocol OutfitBuilderVCDelegate {
    func pickerViewWasTapped(image: UIImage)
}

class OutfitBuilderVC: UIViewController, AddOutfitViewDelegate {
    
    var addOutfitView: AddOutfitView?
    var scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
    var addedPickers:[Bool] = [Bool](count: 7, repeatedValue: false)
    
    let jacketPicker = UIPickerView()
    let lightLayerPicker = UIPickerView()
    let collaredShirtPicker = UIPickerView()
    let longSleeveShirtPicker = UIPickerView()
    let shortSleeveShirtPicker = UIPickerView()
    let bottomsPicker = UIPickerView()
    
    var jacketPickerData:[Top] = [Top]()
    var lightLayerPickerData:[Top] = [Top]()
    var collaredShirtPickerData:[Top] = [Top]()
    var longSleeveShirtPickerData:[Top] = [Top]()
    var shortSleeveShirtPickerData:[Top] = [Top]()
    var bottomsPickerData:[Bottom] = [Bottom]()
    
    var outfitBuilderVCDelegate: OutfitBuilderVCDelegate?
    var ownedOutfits: [Outfit] = readCustomObjArrayFromUserDefaults("ownedOutfits") as! [Outfit]
    
    var blurEffectView: UIVisualEffectView =  UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
    
    let POPOUTSIZE = CGSize(width: 270, height: 320)
    
    var temp:Double = 0
    var curateAuthToken:String?
    var previousMatch: [NSDictionary] = [NSDictionary]()
    var previousMatchIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurateAuthToken(getFbAuthToken(), completionHandler: {
            curateAuthtoken in
            self.curateAuthToken = curateAuthtoken
        })
        
        //set up pickers
        setupPickerViewers()
        
        //add in gesture recognizer for pickers
        setupGestureRecognizers()
        
        //setup ScrollView and add in subviews
        setupView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("AYYYY")
        jacketPickerData = readCustomObjArrayFromUserDefaults("ownedJackets") as! [Top]
        lightLayerPickerData = readCustomObjArrayFromUserDefaults("ownedLightLayers") as! [Top]
        collaredShirtPickerData = readCustomObjArrayFromUserDefaults("ownedCollaredShirts") as! [Top]
        longSleeveShirtPickerData = readCustomObjArrayFromUserDefaults("ownedLongSleeveShirts") as! [Top]
        shortSleeveShirtPickerData = readCustomObjArrayFromUserDefaults("ownedShortSleeveShirts") as! [Top]
        bottomsPickerData = readCustomObjArrayFromUserDefaults("ownedBottoms") as! [Bottom]
        
        //adds in pickers if they have more than just NA symbol.
        if(jacketPickerData.count > 1 && addedPickers[0] == false) {
            scrollView.addSubview(jacketPicker)
            jacketPicker.selectRow(1, inComponent: 0, animated: false)
            addedPickers[0] = true
        }
        if(lightLayerPickerData.count > 1 && addedPickers[1] == false) {
            scrollView.addSubview(lightLayerPicker)
            lightLayerPicker.selectRow(1, inComponent: 0, animated: false)
            addedPickers[1] = true
        }
        if(collaredShirtPickerData.count > 1 && addedPickers[2] == false) {
            scrollView.addSubview(collaredShirtPicker)
            collaredShirtPicker.selectRow(1, inComponent: 0, animated: false)
            addedPickers[2] = true
        }
        if(longSleeveShirtPickerData.count > 1 && addedPickers[3] == false) {
            scrollView.addSubview(longSleeveShirtPicker)
            longSleeveShirtPicker.selectRow(1, inComponent: 0, animated: false)
            addedPickers[3] = true
        }
        if(shortSleeveShirtPickerData.count > 1 && addedPickers[4] == false) {
            scrollView.addSubview(shortSleeveShirtPicker)
            shortSleeveShirtPicker.selectRow(1, inComponent: 0, animated: false)
            addedPickers[4] = true
        }
        if(bottomsPickerData.count > 1 && addedPickers[5] == false) {
            scrollView.addSubview(bottomsPicker)
            bottomsPicker.selectRow(1, inComponent: 0, animated: false)
            addedPickers[5] = true
        }
        
        reloadAllPickers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func reloadAllPickers() {
        jacketPicker.reloadAllComponents()
        lightLayerPicker.reloadAllComponents()
        collaredShirtPicker.reloadAllComponents()
        longSleeveShirtPicker.reloadAllComponents()
        shortSleeveShirtPicker.reloadAllComponents()
        bottomsPicker.reloadAllComponents()
    }
    
    func setupGestureRecognizers() {
        let jacketSingleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewSingleTapGestureRecognized:")
        let lightLayerSingleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewSingleTapGestureRecognized:")
        let collaredShirtSingleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewSingleTapGestureRecognized:")
        let longSleeveShirtSingleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewSingleTapGestureRecognized:")
        let shortSleeveShirtSingleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewSingleTapGestureRecognized:")
        let pantsSingleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewSingleTapGestureRecognized:")
       
        let jacketDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewDoubleTapGestureRecognized:")
        let lightLayerDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewDoubleTapGestureRecognized:")
        let collaredShirtDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewDoubleTapGestureRecognized:")
        let longSleeveShirtDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewDoubleTapGestureRecognized:")
        let shortSleeveShirtDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewDoubleTapGestureRecognized:")
        let pantsDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: "pickerViewDoubleTapGestureRecognized:")
        
        jacketDoubleTapRecognizer.numberOfTapsRequired = 2
        lightLayerDoubleTapRecognizer.numberOfTapsRequired = 2
        collaredShirtDoubleTapRecognizer.numberOfTapsRequired = 2
        longSleeveShirtDoubleTapRecognizer.numberOfTapsRequired = 2
        shortSleeveShirtDoubleTapRecognizer.numberOfTapsRequired = 2
        pantsDoubleTapRecognizer.numberOfTapsRequired = 2
        
        jacketSingleTapRecognizer.requireGestureRecognizerToFail(jacketDoubleTapRecognizer)
        lightLayerSingleTapRecognizer.requireGestureRecognizerToFail(lightLayerDoubleTapRecognizer)
        collaredShirtSingleTapRecognizer.requireGestureRecognizerToFail(collaredShirtDoubleTapRecognizer)
        longSleeveShirtSingleTapRecognizer.requireGestureRecognizerToFail(longSleeveShirtDoubleTapRecognizer)
        shortSleeveShirtSingleTapRecognizer.requireGestureRecognizerToFail(shortSleeveShirtDoubleTapRecognizer)
        pantsSingleTapRecognizer.requireGestureRecognizerToFail(pantsDoubleTapRecognizer)
        
        jacketPicker.addGestureRecognizer(jacketSingleTapRecognizer)
        lightLayerPicker.addGestureRecognizer(lightLayerSingleTapRecognizer)
        collaredShirtPicker.addGestureRecognizer(collaredShirtSingleTapRecognizer)
        longSleeveShirtPicker.addGestureRecognizer(longSleeveShirtSingleTapRecognizer)
        shortSleeveShirtPicker.addGestureRecognizer(shortSleeveShirtSingleTapRecognizer)
        bottomsPicker.addGestureRecognizer(pantsSingleTapRecognizer)

        
        jacketPicker.addGestureRecognizer(jacketDoubleTapRecognizer)
        lightLayerPicker.addGestureRecognizer(lightLayerDoubleTapRecognizer)
        collaredShirtPicker.addGestureRecognizer(collaredShirtDoubleTapRecognizer)
        longSleeveShirtPicker.addGestureRecognizer(longSleeveShirtDoubleTapRecognizer)
        shortSleeveShirtPicker.addGestureRecognizer(shortSleeveShirtDoubleTapRecognizer)
        bottomsPicker.addGestureRecognizer(pantsDoubleTapRecognizer)
        
        jacketSingleTapRecognizer.delegate = self
        lightLayerSingleTapRecognizer.delegate = self
        collaredShirtSingleTapRecognizer.delegate = self
        longSleeveShirtSingleTapRecognizer.delegate = self
        shortSleeveShirtSingleTapRecognizer.delegate = self
        pantsSingleTapRecognizer.delegate = self
        
        jacketDoubleTapRecognizer.delegate = self
        lightLayerDoubleTapRecognizer.delegate = self
        collaredShirtDoubleTapRecognizer.delegate = self
        longSleeveShirtDoubleTapRecognizer.delegate = self
        shortSleeveShirtDoubleTapRecognizer.delegate = self
        pantsDoubleTapRecognizer.delegate = self
    }
    
    func setupPickerViewers() {
        jacketPicker.delegate = self
        lightLayerPicker.delegate = self
        collaredShirtPicker.delegate = self
        longSleeveShirtPicker.delegate = self
        shortSleeveShirtPicker.delegate = self
        bottomsPicker.delegate = self
        
        jacketPicker.dataSource = self
        lightLayerPicker.dataSource = self
        collaredShirtPicker.dataSource = self
        longSleeveShirtPicker.dataSource = self
        shortSleeveShirtPicker.dataSource = self
        bottomsPicker.dataSource = self
        
        jacketPicker.tag = 0
        lightLayerPicker.tag = 1
        collaredShirtPicker.tag = 2
        longSleeveShirtPicker.tag = 3
        shortSleeveShirtPicker.tag = 4
        bottomsPicker.tag = 5
        
        let pickerWidth = SCREENWIDTH*3/4
        shortSleeveShirtPicker.frame = CGRectMake(40, 0, pickerWidth, 180)
        longSleeveShirtPicker.frame = CGRectMake(40, 120, pickerWidth, 180)
        collaredShirtPicker.frame = CGRectMake(40, 240, pickerWidth, 180)
        lightLayerPicker.frame = CGRectMake(40, 360, pickerWidth, 180)
        jacketPicker.frame = CGRectMake(40, 480, pickerWidth, 180)
        bottomsPicker.frame = CGRectMake(40, 600, pickerWidth, 180)
        
        let rotate = CGAffineTransformScale(CGAffineTransformMakeRotation(-3.14/2), 0.25, 2.0)
        self.jacketPicker.transform = rotate
        self.lightLayerPicker.transform = rotate
        self.collaredShirtPicker.transform = rotate
        self.longSleeveShirtPicker.transform = rotate
        self.shortSleeveShirtPicker.transform = rotate
        self.bottomsPicker.transform = rotate
    }
    
    func setupView() {
        self.view.addSubview(scrollView)
        self.view.backgroundColor = UIColor.whiteColor()
        scrollView.contentSize = CGSize(width: 320, height: 758)
        scrollView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 44, right: 0)
        self.blurEffectView.frame = self.view.bounds
        setupToolBar()
    }
    
    func setupToolBar() {
        let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.mainScreen().bounds.size.height - 44, width: UIScreen.mainScreen().bounds.size.width, height: 44))
        var items: Array<UIBarButtonItem> =  []
        var addImage: UIImage = UIImage(named: "addButton")!
        addImage = RBResizeImage(addImage, targetSize: CGSize(width: 35, height: 35))
        items.append(UIBarButtonItem(image: addImage.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: "addOutfit"))
        toolBar.setItems(items, animated: false)
        self.view.addSubview(toolBar)
    }
    
    func removeBlurEffectView() {
        blurEffectView.removeFromSuperview()
    }
    
    func addOutfit() {
        print("addOutfit Button hit")
        let outfit: Outfit = Outfit()
        outfit.jacket = jacketPickerData[jacketPicker.selectedRowInComponent(0)].fileName
        outfit.lightLayer = lightLayerPickerData[lightLayerPicker.selectedRowInComponent(0)].fileName
        outfit.collaredShirt = collaredShirtPickerData[collaredShirtPicker.selectedRowInComponent(0)].fileName
        outfit.longSleeveShirt = longSleeveShirtPickerData[longSleeveShirtPicker.selectedRowInComponent(0)].fileName
        outfit.shortSleeveShirt = shortSleeveShirtPickerData[shortSleeveShirtPicker.selectedRowInComponent(0)].fileName
        outfit.bottoms = bottomsPickerData[bottomsPicker.selectedRowInComponent(0)].fileName
        self.addOutfitView = AddOutfitView(frame: CGRect(x: 20, y: 100, width: SCREENWIDTH-40, height: UIScreen.mainScreen().bounds.height - 150), outfit: outfit)
        addOutfitView?.delegate = self
        self.view.addSubview(blurEffectView)
        self.view.addSubview(self.addOutfitView!)
    }
    
    func pickerViewSingleTapGestureRecognized(sender: UITapGestureRecognizer) {
        let pickerView: UIPickerView = sender.view as! UIPickerView
        var image:UIImage?
        switch pickerView.tag {
        case jacketPicker.tag:
            image = UIImage(data: jacketPickerData[jacketPicker.selectedRowInComponent(0)].imageData!)!
        case lightLayerPicker.tag:
            image = UIImage(data: lightLayerPickerData[lightLayerPicker.selectedRowInComponent(0)].imageData!)!
        case collaredShirtPicker.tag:
            image = UIImage(data: collaredShirtPickerData[collaredShirtPicker.selectedRowInComponent(0)].imageData!)!
        case longSleeveShirtPicker.tag:
            image = UIImage(data: longSleeveShirtPickerData[longSleeveShirtPicker.selectedRowInComponent(0)].imageData!)
        case shortSleeveShirtPicker.tag:
            image = UIImage(data: shortSleeveShirtPickerData[shortSleeveShirtPicker.selectedRowInComponent(0)].imageData!)
        case bottomsPicker.tag:
            image = UIImage(data: bottomsPickerData[bottomsPicker.selectedRowInComponent(0)].imageData!)!
        default:
            image = UIImage()
        }
        self.view.addSubview(self.blurEffectView)
        outfitBuilderVCDelegate?.pickerViewWasTapped(image!)
    }
    
    func pickerViewDoubleTapGestureRecognized(sender: UITapGestureRecognizer ) {
        print("double tapped")
        var baseClothing: String?
        var baseCategory: String?
        let pickerView: UIPickerView = sender.view as! UIPickerView
        switch pickerView.tag {
        case jacketPicker.tag:
            baseClothing = jacketPickerData[jacketPicker.selectedRowInComponent(0)].fileName
            baseCategory = jacketPickerData[jacketPicker.selectedRowInComponent(0)].mainCategory
        case lightLayerPicker.tag:
            baseClothing = lightLayerPickerData[lightLayerPicker.selectedRowInComponent(0)].fileName
            baseCategory = lightLayerPickerData[lightLayerPicker.selectedRowInComponent(0)].mainCategory
        case collaredShirtPicker.tag:
            baseClothing = collaredShirtPickerData[collaredShirtPicker.selectedRowInComponent(0)].fileName
            baseCategory = collaredShirtPickerData[collaredShirtPicker.selectedRowInComponent(0)].mainCategory
        case longSleeveShirtPicker.tag:
            baseClothing = longSleeveShirtPickerData[longSleeveShirtPicker.selectedRowInComponent(0)].fileName
            baseCategory = longSleeveShirtPickerData[longSleeveShirtPicker.selectedRowInComponent(0)].mainCategory
        case shortSleeveShirtPicker.tag:
            baseClothing = shortSleeveShirtPickerData[shortSleeveShirtPicker.selectedRowInComponent(0)].fileName
            baseCategory = shortSleeveShirtPickerData[shortSleeveShirtPicker.selectedRowInComponent(0)].mainCategory
        case bottomsPicker.tag:
            baseClothing = bottomsPickerData[bottomsPicker.selectedRowInComponent(0)].fileName
            baseCategory = bottomsPickerData[bottomsPicker.selectedRowInComponent(0)].mainCategory
        default:
            print("")
        }

        if (self.curateAuthToken != nil && baseClothing != nil) {
            self.view.addSubview(blurEffectView)
            getMatches(self.curateAuthToken!, base_clothing: baseClothing!, completionHandler: {
                matchDict in
                // remove blur view
                dispatch_async(dispatch_get_main_queue(), {
                    self.blurEffectView.removeFromSuperview()
                })
                let message:String = matchDict.objectForKey("message") as! String
                print(message)
                if message == "Success" {
                    print(matchDict)
                    if let matches:[NSDictionary] = matchDict.objectForKey("matches") as? [NSDictionary] {
                        print(matches)
                        let currentMatch:NSDictionary = self.getNextMatch(matches)
                        self.assembleOutfitFromMatch(currentMatch,baseCategory: baseCategory!)
                    } else {
                        let alert = UIAlertController(title: "Alert", message: "No outfits could be matched", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                } else {
                    let alert = UIAlertController(title: "Alert", message: "No outfits, server error", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
        
    }
    
    func getNextMatch(matches:[NSDictionary]) -> NSDictionary {
        if (self.previousMatch != matches) {
            self.previousMatch = matches
            self.previousMatchIndex = 0
        }
        //account for wrapping around
        self.previousMatchIndex = (previousMatchIndex+1) % previousMatch.count
        return previousMatch[previousMatchIndex-0]
    }
    
    func assembleOutfitFromMatch(match: NSDictionary, baseCategory: String) {
        var buffer: [[String]] = match.objectForKey("outfits") as! [[String]]
        var outfit:[String] = buffer[0]
//        var ownedPants: [Bottom] = readCustomObjArrayFromUserDefaults("ownedPants") as! [Bottom]
        var changedPickers = [false, false, false, false, false, false]
        
        switch baseCategory {
        case "jacket":
            changedPickers[0] = true
        case "light_layer":
            changedPickers[1] = true
        case "collared_shirt":
            changedPickers[2] = true
        case "long_sleeve_shirt":
            changedPickers[3] = true
        case "short_sleeve_shirt":
            changedPickers[4] = true
        default:
            changedPickers[5] = true
        }
        
        print("outfit is \(outfit)")
        print("1 changedPickers =\(changedPickers)")
        
        changePickerWithOutfitName(outfit[0], isBottom: true, changedPickers: &changedPickers)
        print("2 changedPickers =\(changedPickers)")
        if outfit[1] != "NA" {
            changePickerWithOutfitName(outfit[1], isBottom: false, changedPickers: &changedPickers)
        }
        print("3 changedPickers =\(changedPickers)")
        if outfit[2] != "NA" {
            changePickerWithOutfitName(outfit[2], isBottom: false, changedPickers: &changedPickers)
        }
        
        print("4 changedPickers = \(changedPickers)")
        
        if changedPickers[0] == false { jacketPicker.selectRow(0, inComponent: 0, animated: true) }
        if changedPickers[1] == false {lightLayerPicker.selectRow(0, inComponent: 0, animated: true) }
        if changedPickers[2] == false {collaredShirtPicker.selectRow(0, inComponent: 0, animated: true) }
        if changedPickers[3] == false {longSleeveShirtPicker.selectRow(0, inComponent: 0, animated: true) }
        if changedPickers[4] == false {shortSleeveShirtPicker.selectRow(0, inComponent: 0, animated: true) }
        
        
    }
    
    func getMainCategory(fileName: String, isBottom: Bool) -> String{
        if(isBottom) {
            let ownedBottoms: [Bottom] = readCustomObjArrayFromUserDefaults("ownedBottoms") as! [Bottom]
            for bottom in ownedBottoms {
                if bottom.fileName == fileName {
                    return bottom.mainCategory!
                }
            }
        } else {
            let ownedTops: [Top] = readCustomObjArrayFromUserDefaults("ownedTops") as! [Top]
            for top in ownedTops {
                if top.fileName == fileName {
                    return top.mainCategory!
                }
            }
        }
        return "NA"
    }
    
    func changePickerWithOutfitName(outfitName: String, isBottom: Bool, inout changedPickers: [Bool]) {
        let mainCategory: String = getMainCategory(outfitName, isBottom: isBottom)
        print("main Category = \(mainCategory)")
        switch mainCategory {
        case "jacket":
            var ownedJackets = readCustomObjArrayFromUserDefaults("ownedJackets") as! [Top]
            for (var i = 1; i < ownedJackets.count; i++) {
                if(outfitName == ownedJackets[i].fileName!) {
                    jacketPicker.selectRow(i, inComponent: 0, animated: true)
                    changedPickers[0] = true
                    break
                }
            }
        case "light_layer":
            var ownedLightLayers = readCustomObjArrayFromUserDefaults("ownedLightLayers") as! [Top]
            for (var i = 1; i < ownedLightLayers.count; i++) {
                if(outfitName == ownedLightLayers[i].fileName!) {
                    lightLayerPicker.selectRow(i, inComponent: 0, animated: true)
                    changedPickers[1] = true
                    break
                }
            }
        case "long_sleeve_shirt":
            var ownedLongSleeveShirts = readCustomObjArrayFromUserDefaults("ownedLongSleeveShirts")as! [Top]
            for (var i = 1; i < ownedLongSleeveShirts.count; i++) {
                if(outfitName == ownedLongSleeveShirts[i].fileName!) {
                    longSleeveShirtPicker.selectRow(i, inComponent: 0, animated: true)
                    changedPickers[3] = true
                    break
                }
            }
        case "collared_shirt":
            var ownedCollaredShirts = readCustomObjArrayFromUserDefaults("ownedCollaredShirts") as! [Top]
            for (var i = 1; i < ownedCollaredShirts.count; i++) {
                if(outfitName == ownedCollaredShirts[i].fileName!) {
                    collaredShirtPicker.selectRow(i, inComponent: 0, animated: true)
                    changedPickers[2] = true
                    break
                }
            }
        case "short_sleeve_shirt":
            var ownedShortSleeveShirts = readCustomObjArrayFromUserDefaults("ownedShortSleeveShirts") as! [Top]
            for (var i = 1; i < ownedShortSleeveShirts.count; i++) {
                if(outfitName == ownedShortSleeveShirts[i].fileName!) {
                    shortSleeveShirtPicker.selectRow(i, inComponent: 0, animated: true)
                    changedPickers[4] = true
                    break
                }
            }
        default:
            var ownedBottoms = readCustomObjArrayFromUserDefaults("ownedBottoms") as! [Bottom]
            for (var i = 1; i < ownedBottoms.count; i++) {
                if outfitName == ownedBottoms[i].fileName {
                    bottomsPicker.selectRow(i, inComponent: 0, animated: true)
                    changedPickers[5] = true
                    break
                }
            }
        }
    }



    func blurEffectWasTapped(VC: UIViewController) {
        print("blur effect recognized")
        self.blurEffectView.removeFromSuperview()
    }

    func dismissOutfitView() {
        self.blurEffectView.removeFromSuperview()
        self.addOutfitView?.removeFromSuperview()
    }

}
    


extension OutfitBuilderVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
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
        case jacketPicker.tag:
            return jacketPickerData.count
        case lightLayerPicker.tag:
            return lightLayerPickerData.count
        case collaredShirtPicker.tag:
            return collaredShirtPickerData.count
        case longSleeveShirtPicker.tag:
            return longSleeveShirtPickerData.count
        case shortSleeveShirtPicker.tag:
            return shortSleeveShirtPickerData.count
        case bottomsPicker.tag:
            return bottomsPickerData.count
        default:
            return 0
        }
    }
}

//MARK: Delegates UIPickerView
extension OutfitBuilderVC: UIPickerViewDelegate {
    // several optional methods:
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case jacketPicker.tag:
            return "jackets"
        case lightLayerPicker.tag:
            return "light layers"
        case collaredShirtPicker.tag:
            return "collared shirts"
        case longSleeveShirtPicker.tag:
            return "long sleeve shirts"
        case shortSleeveShirtPicker.tag:
            return "short sleeve shirts"
        case bottomsPicker.tag:
            return "pants"
        default:
            return "nothing"
        }
    }
    
    //        func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
    //        }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat{
        return 80
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat{
        return 80
    }
    
    // func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String!
    
    // func pickerView(pickerView: UIPickerView!, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString!
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var img: UIImage?
        switch pickerView.tag {
        case jacketPicker.tag:
            img = UIImage(data:jacketPickerData[row].imageData!)
        case lightLayerPicker.tag:
            img = UIImage(data: lightLayerPickerData[row].imageData!)
        case collaredShirtPicker.tag:
            img = UIImage(data: collaredShirtPickerData[row].imageData!)
        case longSleeveShirtPicker.tag:
            img = UIImage(data: longSleeveShirtPickerData[row].imageData!)
        case shortSleeveShirtPicker.tag:
            img = UIImage(data: shortSleeveShirtPickerData[row].imageData!)
        case bottomsPicker.tag:
            img = UIImage(data: bottomsPickerData[row].imageData!)
        default:
            img = nil
        }
        let resizedImg = RBResizeImage(img!, targetSize: CGSize(width: 280, height: 120))
        let imageView = UIImageView(image: resizedImg)
        let tmpView = UIView(frame: CGRectMake(0, 0, 130, 130))
        let rotate = CGAffineTransformScale(CGAffineTransformMakeRotation(3.14/2), 0.25, 2.0)
        tmpView.transform = rotate
        tmpView.insertSubview(imageView, atIndex: 0)
        return tmpView
    }
}


