//
//  SingleOutfitVC.swift
//  Curate
//
//  Created by Kenneth Kuo on 7/20/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation
import UIKit

protocol SingleOutfitVCDelegate {
    func dismissSingleOutfitVC()
}

class SingleOutfitVC: UIViewController {
    
    var outfit: Outfit?
    var delegate: SingleOutfitVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        setupReturnButtons()
        setupClothingPieces()
    }
    
    func setupReturnButtons() {
        var backButton: UIButton = UIButton(frame: CGRectMake(10, 30, 50, 20))
        backButton.setTitle("Back", forState: UIControlState.Normal)
        backButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        var backButtonGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "backButtonTapped")
        backButton.addGestureRecognizer(backButtonGesture)
        
        var doneButton: UIButton = UIButton(frame: CGRectMake(self.view.frame.width - 55, 30, 50, 20))
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        var doneButtonGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "doneButtonTapped")
        doneButton.addGestureRecognizer(doneButtonGesture)
        
        self.view.addSubview(backButton)
        self.view.addSubview(doneButton)
    }
    
    func backButtonTapped() {
        println("backbuttonTapped")
        delegate!.dismissSingleOutfitVC()
    }
    
    func doneButtonTapped() {
        println("doneButtonTapped")
        delegate?.dismissSingleOutfitVC()
    }
    
    func setupClothingPieces() {
        var toBeDisplayed: [Clothing] = []
        if outfit?.jacket != nil {
            toBeDisplayed.append(getClothing(outfit!.jacket!,isBottom: false))
        }
        if outfit?.lightLayer != nil {
            toBeDisplayed.append(getClothing(outfit!.lightLayer!,isBottom: false))
        }
        if outfit?.collaredShirt != nil {
            toBeDisplayed.append(getClothing(outfit!.collaredShirt!,isBottom: false))
        }
        if outfit?.longSleeveShirt != nil {
            toBeDisplayed.append(getClothing(outfit!.longSleeveShirt!,isBottom: false))
        }
        if outfit?.shortSleeveShirt != nil {
            toBeDisplayed.append(getClothing(outfit!.shortSleeveShirt!,isBottom: false))
        }
        if outfit?.bottoms != nil {
            toBeDisplayed.append(getClothing(outfit!.bottoms!,isBottom: true))
        }
        
        for (var i = 0; i<toBeDisplayed.count; i++) {
            var yCoord: Int = i*90 + 100
            var imageView: UIImageView = UIImageView(frame: CGRect(x: 20, y: yCoord, width: 80, height: 80))
            imageView.image = UIImage(data: toBeDisplayed[i].imageData!)
            self.view.addSubview(imageView)
        }
    }
    
    func getClothing(fileName: String, isBottom: Bool) -> Clothing {
        var clothing: Clothing = Clothing()
        if(isBottom) {
            var ownedBottoms: [Bottom] = readCustomObjArrayFromUserDefaults("ownedBottoms") as! [Bottom]
            for bottom in ownedBottoms {
                if bottom.fileName == fileName {
                    clothing = bottom
                }
            }
        } else {
            var ownedTops: [Top] = readCustomObjArrayFromUserDefaults("ownedTops") as! [Top]
            for top in ownedTops {
                if top.fileName == fileName {
                    clothing = top
                }
            }
        }
        return clothing
    }
    
}