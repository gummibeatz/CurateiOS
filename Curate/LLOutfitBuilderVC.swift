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
    
    var curateAuthToken:String?
    var previousMatch: [NSDictionary] = [NSDictionary]()
    var previousMatchIndex: Int = 0
    
    var isDropped = [
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
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return isDropped.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if !isDropped[indexPath.section] {
            cell = tableView.dequeueReusableCellWithIdentifier("carouselCellCompressed", forIndexPath: indexPath)
            (cell as! CarouselCompressedTableViewCell).delegate = self
            
        } else {
            cell = NSBundle.mainBundle().loadNibNamed("CarouselTableViewCell", owner: self, options: nil).first as? UITableViewCell
            var carouselCell = cell as! CarouselTableViewCell
            carouselCell.items = jacketPickerData
        }
        cell!.tag = indexPath.section
        return cell!
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
        return isDropped[indexPath.section] ? 150 : 40
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
}
