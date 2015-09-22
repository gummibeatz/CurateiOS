//
//  SingleOutfitVC.swift
//  Curate
//
//  Created by Curate on 7/20/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

// ************MUST UP DATE LASTEDITED and IMAGEVIEW TAGS WHEN INSERTING NEW LAYER!!!!!!!!***************
import Foundation
import UIKit

protocol SingleOutfitVCDelegate {
    func dismissSingleOutfitVC()
    func saveNewOutfit(originalOutfit: Outfit, newOutfit: [Clothing])
}

class SingleOutfitVC: UIViewController, EditClothingViewDelegate {
    
    var outfit: Outfit?
    var delegate: SingleOutfitVCDelegate?
    var toBeDisplayed: [Clothing] = []
    var imageViewArray: [UIImageView] = []
    var blurEffectView: UIVisualEffectView =  UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
    var editClothingView: EditClothingView?
    var lastEdited: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        blurEffectView.frame = UIScreen.mainScreen().bounds
        setupReturnButtons()
        setupClothingPieces()
    }
    
    func setupReturnButtons() {
        let backButton: UIButton = UIButton(frame: CGRectMake(10, 30, 50, 20))
        backButton.setTitle("Back", forState: UIControlState.Normal)
        backButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        let backButtonGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "backButtonTapped")
        backButton.addGestureRecognizer(backButtonGesture)
        
        let saveButton: UIButton = UIButton(frame: CGRectMake(self.view.frame.width - 55, 30, 50, 20))
        saveButton.setTitle("Save", forState: .Normal)
        saveButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        let saveButtonGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "saveButtonTapped")
        saveButton.addGestureRecognizer(saveButtonGesture)
        
        self.view.addSubview(backButton)
        self.view.addSubview(saveButton)
    }
    
    func backButtonTapped() {
        print("backbuttonTapped")
        delegate!.dismissSingleOutfitVC()
    }
    
    func saveButtonTapped() {
        print("saveButtonTapped")
        delegate?.dismissSingleOutfitVC()
        delegate?.saveNewOutfit(outfit!, newOutfit: toBeDisplayed)
    }
    
    func setupClothingPieces() {
        print("outfit?.jacket = \(outfit?.jacket)")
        if outfit?.jacket != "NA" {
            toBeDisplayed.append(getClothing(outfit!.jacket!,isBottom: false))
        }
        if outfit?.lightLayer != "NA" {
            toBeDisplayed.append(getClothing(outfit!.lightLayer!,isBottom: false))
        }
        if outfit?.collaredShirt != "NA" {
            toBeDisplayed.append(getClothing(outfit!.collaredShirt!,isBottom: false))
        }
        if outfit?.longSleeveShirt != "NA" {
            toBeDisplayed.append(getClothing(outfit!.longSleeveShirt!,isBottom: false))
        }
        if outfit?.shortSleeveShirt != "NA" {
            toBeDisplayed.append(getClothing(outfit!.shortSleeveShirt!,isBottom: false))
        }
        if outfit?.bottoms != "NA" {
            toBeDisplayed.append(getClothing(outfit!.bottoms!,isBottom: true))
        }
        
        for (var i = 0; i<toBeDisplayed.count; i++) {
            let yCoord: Int = i*90 + 100
            let imageView: UIImageView = UIImageView(frame: CGRect(x: 20, y: yCoord, width: 80, height: 80))
            imageView.userInteractionEnabled = true
            let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "createEditClothingView:")
            imageView.image = UIImage(data: toBeDisplayed[i].imageData!)
            imageView.tag = i+1000
            imageView.addGestureRecognizer(gestureRecognizer)
            self.imageViewArray.append(imageView)
            self.view.addSubview(imageView)
        }
    }
    
    func createEditClothingView(sender: UITapGestureRecognizer) {
        print("clothing tapped")
        lastEdited = sender.view!.tag
        let clothing = toBeDisplayed[sender.view!.tag-1000]
        editClothingView = EditClothingView(frame: CGRect(x: 10, y: UIScreen.mainScreen().bounds.height/2, width: UIScreen.mainScreen().bounds.width-20, height: 200), clothing: clothing)
        editClothingView?.delegate = self
        self.view.addSubview(blurEffectView)
        self.view.addSubview(editClothingView!)
        
    }
    
    
    func getClothing(fileName: String, isBottom: Bool) -> Clothing {
        var clothing: Clothing = Clothing()
        if(isBottom) {
            let ownedBottoms: [Bottom] = readCustomObjArrayFromUserDefaults("ownedBottoms") as! [Bottom]
            for bottom in ownedBottoms {
                if bottom.fileName == fileName {
                    clothing = bottom
                }
            }
        } else {
            let ownedTops: [Top] = readCustomObjArrayFromUserDefaults("ownedTops") as! [Top]
            for top in ownedTops {
                if top.fileName == fileName {
                    clothing = top
                }
            }
        }
        return clothing
    }
    
}

// MARK EditClothingViewDelegate functions
extension SingleOutfitVC {
    
    func dismissEditClothingView() {
        editClothingView?.removeFromSuperview()
        blurEffectView.removeFromSuperview()
    }
    
    // updates UIImageView and replaces the new clothes in toBeDisplayed
    func savePickerChangeWithFileName(clothing: Clothing) {
        print("new choice is \(clothing.fileName!)")
        for (var i = 0; i < self.imageViewArray.count; i++) {
            if self.imageViewArray[i].tag == self.lastEdited {
                self.imageViewArray[i].image = UIImage(data: clothing.imageData!)
                self.toBeDisplayed[i] = clothing
                break
            }
        }
    }
}