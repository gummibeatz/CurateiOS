//
//  WardrobeTableViewController.swift
//  TestingCarouselView
//
//  Created by Linus Liang on 1/24/16.
//  Copyright © 2016 Linus Liang. All rights reserved.
//

import UIKit

class LLOutfitViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: UIScreen.mainScreen().bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.whiteColor()
        return tableView
    }()
    
    var addedPickers:[Bool] = [Bool](count: 7, repeatedValue: false)
    
    lazy var jacketPickerData:[Top] = {
        return readCustomObjArrayFromUserDefaults("ownedJackets") as! [Top]
    }()
    
    lazy var lightLayerPickerData:[Top] = {
        readCustomObjArrayFromUserDefaults("ownedLightLayers") as! [Top]
    }()
    
    lazy var collaredShirtPickerData:[Top] = {
        readCustomObjArrayFromUserDefaults("ownedCollaredShirts") as! [Top]
    }()
    
    lazy var longSleeveShirtPickerData:[Top] = {
        readCustomObjArrayFromUserDefaults("ownedLongSleeveShirts") as! [Top]
    }()
    
    lazy var shortSleeveShirtPickerData:[Top] = {
        readCustomObjArrayFromUserDefaults("ownedShortSleeveShirts") as! [Top]
    }()
    
    lazy var bottomsPickerData:[Bottom] = {
        readCustomObjArrayFromUserDefaults("ownedBottoms") as! [Bottom]
    }()
    
    var blurEffectView: UIVisualEffectView =  UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
    
    
    var curateAuthToken:String?
    var previousMatch: [NSDictionary] = [NSDictionary]()
    var previousMatchIndex: Int = 0
    
    var isDropped = [
        true,
        true,
        true,
        true,
        true,
        true,
        true
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        self.view.backgroundColor = UIColor.whiteColor()
        
        let fbAuthToken = "change later"
        getCurateAuthToken(fbAuthToken, completionHandler: {
            curateAuthtoken in
            self.curateAuthToken = curateAuthtoken
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        jacketPickerData = readCustomObjArrayFromUserDefaults("ownedJackets") as! [Top]
        lightLayerPickerData = readCustomObjArrayFromUserDefaults("ownedLightLayers") as! [Top]
        collaredShirtPickerData = readCustomObjArrayFromUserDefaults("ownedCollaredShirts") as! [Top]
        longSleeveShirtPickerData = readCustomObjArrayFromUserDefaults("ownedLongSleeveShirts") as! [Top]
        shortSleeveShirtPickerData = readCustomObjArrayFromUserDefaults("ownedShortSleeveShirts") as! [Top]
        bottomsPickerData = readCustomObjArrayFromUserDefaults("ownedBottoms") as! [Bottom]
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if !isDropped[indexPath.section] {
            cell = NSBundle.mainBundle().loadNibNamed("CarouselCompressedTableViewCell", owner: self, options: nil).first as? UITableViewCell
            let compressedCell = cell as! CarouselCompressedTableViewCell
            compressedCell.delegate = self
        } else {
            cell = NSBundle.mainBundle().loadNibNamed("CarouselTableViewCell", owner: self, options: nil).first as? UITableViewCell
            let carouselCell = cell as! CarouselTableViewCell
            carouselCell.delegate = self
            setCarouselItems(carouselCell, index: indexPath.section)
            carouselCell.carousel.reloadData()
        }
        cell!.tag = indexPath.section
        return cell!
    }
    
    func setCarouselItems(cell: CarouselTableViewCell, index: Int) {
        switch index {
        case 0:
            cell.items = jacketPickerData
        case 1:
            cell.items = lightLayerPickerData
        case 2:
            cell.items = collaredShirtPickerData
        case 3:
            cell.items = longSleeveShirtPickerData
        case 4:
            cell.items = shortSleeveShirtPickerData
        case 5:
            cell.items = bottomsPickerData
        default:
            print("no case matched")
        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - Table view delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return isDropped[indexPath.section] ? 150 : 20
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        view.backgroundColor = UIColor.whiteColor()
        return view
    }
}

extension LLOutfitViewController: CarouselCompressedTableViewCellDelegate, CarouselTableViewCellDelegate {
    // MARK: - tablecell delegates
    func toggleDropdown(idx: Int) {
        isDropped[idx] = !isDropped[idx]
        self.tableView.reloadSections(NSIndexSet(index: idx), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func cellTapped(clothing: Clothing) {
        let baseCategory = clothing.mainCategory
        let baseClothing = clothing.fileName
        
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
        
        for i in (0..<changedPickers.count) {
            if !changedPickers[i] {
                isDropped[i] = false
            }
        }
    }
    
    func changePickerWithOutfitName(outfitName: String, isBottom: Bool, inout changedPickers: [Bool]) {
        let mainCategory: String = getMainCategory(outfitName, isBottom: isBottom)
        print("main Category = \(mainCategory)")
        switch mainCategory {
        case "jacket":
            var ownedJackets = readCustomObjArrayFromUserDefaults("ownedJackets") as! [Top]
            for (idx,jacket) in ownedJackets.enumerate() {
                if(outfitName == jacket.fileName!) {
                    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    let cell = tableView.cellForRowAtIndexPath(indexPath) as? CarouselTableViewCell
                    cell?.carousel.scrollToItemAtIndex(idx, animated: true)
                    changedPickers[0] = true
                    break
                }
            }
        case "light_layer":
            var ownedLightLayers = readCustomObjArrayFromUserDefaults("ownedLightLayers") as! [Top]
            for (idx,jacket) in ownedLightLayers.enumerate() {
                if(outfitName == ownedLightLayers[idx].fileName!) {
                    let indexPath = NSIndexPath(forRow: 0, inSection: 1)
                    let cell = tableView.cellForRowAtIndexPath(indexPath) as? CarouselTableViewCell
                    cell?.carousel.scrollToItemAtIndex(idx, animated: true)
                    changedPickers[0] = true
                    break
                }
            }
        case "long_sleeve_shirt":
            var ownedLongSleeveShirts = readCustomObjArrayFromUserDefaults("ownedLongSleeveShirts")as! [Top]
            for (idx,jacket) in ownedLongSleeveShirts.enumerate() {
                if(outfitName == ownedLongSleeveShirts[idx].fileName!) {
                    let indexPath = NSIndexPath(forRow: 0, inSection: 2)
                    let cell = tableView.cellForRowAtIndexPath(indexPath) as? CarouselTableViewCell
                    cell?.carousel.scrollToItemAtIndex(idx, animated: true)
                    changedPickers[0] = true
                    break
                }
            }
        case "collared_shirt":
            var ownedCollaredShirts = readCustomObjArrayFromUserDefaults("ownedCollaredShirts") as! [Top]
            for (idx,jacket) in ownedCollaredShirts.enumerate() {
                if(outfitName == ownedCollaredShirts[idx].fileName!) {
                    let indexPath = NSIndexPath(forRow: 0, inSection: 3)
                    let cell = tableView.cellForRowAtIndexPath(indexPath) as? CarouselTableViewCell
                    cell?.carousel.scrollToItemAtIndex(idx, animated: true)
                    changedPickers[0] = true
                    break
                }
            }
        case "short_sleeve_shirt":
            var ownedShortSleeveShirts = readCustomObjArrayFromUserDefaults("ownedShortSleeveShirts") as! [Top]
            for (idx,jacket) in ownedShortSleeveShirts.enumerate() {
                if(outfitName == ownedShortSleeveShirts[idx].fileName!) {
                    let indexPath = NSIndexPath(forRow: 0, inSection: 4)
                    let cell = tableView.cellForRowAtIndexPath(indexPath) as? CarouselTableViewCell
                    cell?.carousel.scrollToItemAtIndex(idx, animated: true)
                    changedPickers[0] = true
                    break
                }
            }
        default:
            var ownedBottoms = readCustomObjArrayFromUserDefaults("ownedBottoms") as! [Bottom]
            for (idx,bottoms) in ownedBottoms.enumerate() {
                if outfitName == bottoms.fileName {
                    let indexPath = NSIndexPath(forRow: 0, inSection: 5)
                    let cell = tableView.cellForRowAtIndexPath(indexPath) as? CarouselTableViewCell
                    cell?.carousel.scrollToItemAtIndex(idx, animated: true)
                    changedPickers[5] = true
                    break
                }
            }
        }
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
}
