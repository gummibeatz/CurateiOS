//
//  ViewController.swift
//  Outfits
//
//  Created by Curate on 1/5/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import UIKit

protocol OutfitsVCDelegate {
    func editButtonTapped()
}

class OutfitsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, SingleOutfitVCDelegate {
    
    let cellIdentifier = "cellIdentfier"
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var tableData:[Outfit] = []
    let cellRowHeight: CGFloat = 50
    var outfitsDelegate:OutfitsVCDelegate?
    var outfitsTableView: UITableView = UITableView(frame: UIScreen.mainScreen().bounds)
    var ownedOutfits: [Outfit]?
    
    override func loadView() {
        super.loadView()
        let bufferData: [Outfit] = readCustomObjArrayFromUserDefaults("ownedOutfits") as! [Outfit]
        for outfit in bufferData {
            tableData.append(outfit)
        }
        
        outfitsTableView.rowHeight = cellRowHeight
        outfitsTableView.delegate = self
        outfitsTableView.dataSource = self
        outfitsTableView.tableFooterView = UIView(frame: CGRectZero)
        
        
        outfitsTableView.registerClass(OutfitCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        self.view.addSubview(outfitsTableView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.ownedOutfits = readCustomObjArrayFromUserDefaults("ownedOutfits") as? [Outfit]
        
        //gotta change eventually
        print("tableData.count = \(tableData.count)")
        print("ownedOutfits.count = \(ownedOutfits!.count)")
        
        if(ownedOutfits!.count != tableData.count) {
            tableData.append(ownedOutfits!.last!)
            outfitsTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createTableDataFromOutfits(outfits: [Outfit]) -> [String] {
        let temp: [String] = []
        for outfit in outfits {
            print(outfit)
//            temp.append(outfit.title!)
        }
        return temp
    }
    
    func deleteOutfitWithTitle(title: String) {
        var outfitIndex: Int?
        for var i = 0; i < ownedOutfits!.count; i++ {
            if ownedOutfits![i].title == title {
                outfitIndex = i
                break
            }
        }
        ownedOutfits!.removeAtIndex(outfitIndex!)
        writeCustomObjArraytoUserDefaults(ownedOutfits!, fileName: "ownedOutfits")
    }
    
}

//MARK: Data Source TableView
extension OutfitsVC {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as! OutfitCell
        cell.outfitName.text = self.tableData[indexPath.row].title
        cell.outfit = self.tableData[indexPath.row]
        //modify for actual outfit image
        let img = UIImage(named: "tshirt1.jpg")
        cell.outfitImage.image = img
        return cell
    }
    
    
    
}

//MARK: Delegates TableView
extension OutfitsVC {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("didslelectRow at \(indexPath.row)")
        let singleOutfitVC: SingleOutfitVC = SingleOutfitVC()
        singleOutfitVC.delegate = self
        singleOutfitVC.outfit = self.tableData[indexPath.row]
        self.navigationController?.presentViewController(singleOutfitVC, animated: true, completion: nil)
        self.appDelegate.measurementsButton.removeFromSuperview()
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            print("Delete closure called")
            
            let alert = UIAlertController(title: "Warning", message: "Sure you want to delete?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: {
                action in
                self.deleteOutfitWithTitle(self.tableData[indexPath.row].title!)
                self.tableData.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        let editClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            //add in delegate to send info of the current outfit
            self.outfitsDelegate?.editButtonTapped()
            print("edit closure called")
        }
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: deleteClosure)
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit", handler: editClosure)
        deleteAction.backgroundColor = UIColor.blueColor()
        
        return [deleteAction, editAction]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
    //        return true
    //    }
    
    
    
}

//MARK: Delegates SingleOutfitVC
extension OutfitsVC {
    
    func dismissSingleOutfitVC() {
        print("dismissSingleOutfitVC delegated")
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
//        self.appDelegate.setupMeasurementsButton()
        
    }
    
    // takes in the original outfit as an Outfit object and the newOutfit as an array of
    // Clothing. Should be the updated toBeDisplayed array from SingleOutfitVC
    func saveNewOutfit(originalOutfit: Outfit, newOutfit: [Clothing]) {
        for (var i = 0; i < self.ownedOutfits!.count; i++) {
            if (self.ownedOutfits![i].title! == originalOutfit.title!) {
                // update outfit with what was on singleoutfitVC
                for clothing in newOutfit {
                        switch clothing.mainCategory! {
                        case "Collared Shirt":
                            originalOutfit.collaredShirt = clothing.fileName!
                        case "Jacket":
                            originalOutfit.jacket = clothing.fileName!
                        case "Light Layer":
                            originalOutfit.lightLayer = clothing.fileName!
                        case "Long Sleeve Shirt":
                            originalOutfit.longSleeveShirt = clothing.fileName!
                        case "Short Sleeve Shirt":
                            originalOutfit.shortSleeveShirt = clothing.fileName!
                        case "Casual", "Chinos", "Shorts", "Suit Pants":
                            originalOutfit.bottoms = clothing.fileName!
                        default:
                            print("error outfit was not changed")
                        }
                }
                self.ownedOutfits![i] = originalOutfit
                writeCustomObjArraytoUserDefaults(ownedOutfits!, fileName: "ownedOutfits")
                break
            }
        }
    }
}
