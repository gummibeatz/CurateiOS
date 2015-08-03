//
//  File.swift
//  Curate
//
//  Created by Kenneth Kuo on 7/21/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation

protocol EditClothingViewDelegate{
    func dismissEditClothingView()
    func savePickerChangeWithFileName(clothing: Clothing)
}

class EditClothingView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let clothingPicker = UIPickerView()
    var clothingPickerData = [Clothing]()
    var delegate:EditClothingViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // ...
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, clothing: Clothing) {
        super.init(frame: frame)
        setupPickerView()
        populatePickerData(clothing)
        setupLayout()
        setupReturnButtons()
    }
    
    func setupLayout() {
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 4
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSizeMake(1, 1)
    }
    
    func setupPickerView() {
        clothingPicker.delegate = self
        clothingPicker.dataSource = self
        clothingPicker.frame = CGRectMake(0, 0, self.frame.width, self.frame.height - 20)
        let rotate = CGAffineTransformScale(CGAffineTransformMakeRotation(-3.14/2), 0.25, 2.0)
        self.clothingPicker.transform = rotate
        self.addSubview(clothingPicker)
    }
    
    func setupReturnButtons() {
        var cancelButton: UIButton = UIButton(frame: CGRectMake(10, 10, 50, 20))
        cancelButton.setTitle("Back", forState: UIControlState.Normal)
        cancelButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        var cancelButtonGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "cancelButtonTapped")
        cancelButton.addGestureRecognizer(cancelButtonGesture)
        
        var saveButton: UIButton = UIButton(frame: CGRectMake(self.frame.width - 55, 10, 50, 20))
        saveButton.setTitle("Save", forState: .Normal)
        saveButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        var saveButtonGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "saveButtonTapped")
        saveButton.addGestureRecognizer(saveButtonGesture)
        
        self.addSubview(cancelButton)
        self.addSubview(saveButton)
    }
    
    func cancelButtonTapped() {
        println("cancelbuttonTapped")
        delegate?.dismissEditClothingView()
    }
    
    func saveButtonTapped() {
        println("saveButtonTapped")
        delegate?.dismissEditClothingView()
        delegate?.savePickerChangeWithFileName(clothingPickerData[clothingPicker.selectedRowInComponent(0)])
    }
    
    func populatePickerData(clothing: Clothing) {
        switch clothing.mainCategory! {
        case "Collared Shirt":
            clothingPickerData = readCustomObjArrayFromUserDefaults("ownedCollaredShirts") as! [Top]
        case "Jacket":
            clothingPickerData = readCustomObjArrayFromUserDefaults("ownedJackets") as! [Top]
        case "Light Layer":
            clothingPickerData = readCustomObjArrayFromUserDefaults("ownedLightLayers") as! [Top]
        case "Long Sleeve Shirt":
            clothingPickerData = readCustomObjArrayFromUserDefaults("ownedLongSleeveShirts") as! [Top]
        case "Short Sleeve Shirt":
            clothingPickerData = readCustomObjArrayFromUserDefaults("ownedShortSleeveShirts") as! [Top]
        case "Casual", "Chinos", "Shorts", "Suit Pants":
            clothingPickerData = readCustomObjArrayFromUserDefaults("ownedBottoms") as! [Bottom]
        default:
            println("couldn't populate picker")
        }
        let rowIdx:Int = getIndexWithFileName(clothingPickerData, fileName: clothing.fileName!)
        clothingPicker.selectRow(rowIdx, inComponent: 0, animated: false)
    }
    
    func getIndexWithFileName(arr:[Clothing], fileName:String) -> Int {
        for(var i = 0; i < arr.count; i++) {
            if(arr[i].fileName! == fileName) {
                return i
            }
        }
        return 0
    }
}

//MARK: Data Sources UIPickerView
extension EditClothingView: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return clothingPickerData.count
    }
}

//MARK: Delegates UIPickerView
extension EditClothingView: UIPickerViewDelegate {
    // several optional methods:
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "clothing"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat{
        return 80
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat{
        return 80
    }
    
    // func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String!
    
    // func pickerView(pickerView: UIPickerView!, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString!
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var img: UIImage = UIImage(data: clothingPickerData[row].imageData!)!
        let resizedImg = RBResizeImage(img, CGSize(width: 280, height: 120))
        let imageView = UIImageView(image: resizedImg)
        let tmpView = UIView(frame: CGRectMake(0, 0, 130, 130))
        let rotate = CGAffineTransformScale(CGAffineTransformMakeRotation(3.14/2), 0.25, 2.0)
        tmpView.transform = rotate
        tmpView.insertSubview(imageView, atIndex: 0)
        return tmpView
    }
}