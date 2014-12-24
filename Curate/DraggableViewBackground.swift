//
//  DraggableViewBackground.swift
//  WardrobeBuilder
//
//  Created by Kenneth Kuo on 12/10/14.
//  Copyright (c) 2014 Kenneth Kuo. All rights reserved.
//

import UIKit

class DraggableViewBackground: UIView, DraggableViewDelegate {
    //declare constants
    let MAX_BUFFER_SIZE = 2 //%%% max number of cards loaded at any given time, must be greater than 1
    let CARD_HEIGHT: CGFloat = 350 //%%% height of the draggable card
    let CARD_WIDTH: CGFloat = 290  //%%% width of the draggable card
    let RIGHT_SWIPE: Int = 0
    let LEFT_SWIPE: Int = 1
    let DOUBLE_TAP: Int = 2
    
    var clothingCardLabels: NSMutableArray = NSMutableArray()
    var allCards: NSMutableArray = NSMutableArray()
    var loadedCards: NSMutableArray = NSMutableArray()
    var cardsLoadedIndex: Int = Int()
    var previousAction: Int = Int()
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        // ...
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
        
        //loading pictures from file EDIT LATER FOR CORE DATA
        let resourcePath: NSString = NSBundle.mainBundle().resourcePath
        let filePath: NSString = resourcePath.stringByAppendingPathComponent("VNeck")
        let imagePaths: NSArray = NSFileManager.defaultManager().contentsOfDirectoryAtPath(filePath, error: nil)
        let enumerator: NSEnumerator = imagePaths.objectEnumerator()
        while let imagePath = enumerator.nextObject() as? NSString {
            //add in images
            clothingCardLabels.addObject(filePath.stringByAppendingPathComponent(imagePath))
            
            //checks to see if images are there
            //            println(imagePath)
            //            println(clothingCardLabels.count)
        }
        // loading finished
        cardsLoadedIndex = 0
        self.loadCards()
    }
    
    func setupView(){
        self.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1) //the gray background colors
        let menuButton = UIButton(frame: CGRect(x: 17, y: 34, width: 22, height: 15))
        let messageButton = UIButton(frame: CGRect(x: 284, y: 34, width: 18, height: 18))
        let xButton = UIButton(frame: CGRect(x: self.frame.width/4 - 70, y: self.frame.height - 120, width: 59, height: 59))
        let haveButton = UIButton(frame:CGRect(x: self.frame.width/2 - 70, y: self.frame.height - 120, width: 59, height: 59))
        let undoButton = UIButton(frame: CGRect(x: 3*self.frame.width/4 - 70, y: self.frame.height - 120, width: 59, height: 59))
        let checkButton = UIButton(frame: CGRect(x: self.frame.width - 70, y: self.frame.height - 120, width: 59, height: 59))
        
        
        menuButton.setImage(UIImage(named: "menuButton"), forState: .Normal)
        messageButton.setImage(UIImage(named: "messageButton"), forState: .Normal)
        xButton.setImage(UIImage(named: "xButton"), forState: .Normal)
        haveButton.setImage(UIImage(named: "haveButton"), forState: .Normal)
        undoButton.setImage(UIImage(named: "undoButton"), forState: .Normal)
        checkButton.setImage(UIImage(named: "checkButton"), forState: .Normal)
        
        
        xButton.addTarget(self, action: "swipeLeft", forControlEvents: .TouchUpInside)
        haveButton.addTarget(self, action: "doubleTapped", forControlEvents: .TouchUpInside)
        checkButton.addTarget(self, action: "swipeRight", forControlEvents: .TouchUpInside)
        undoButton.addTarget(self, action: "undoAction", forControlEvents: .TouchUpInside)
        
        
        self.addSubview(menuButton)
        self.addSubview(messageButton)
        self.addSubview(xButton)
        self.addSubview(haveButton)
        self.addSubview(undoButton)
        self.addSubview(checkButton)
    }
    
    //%%% creates a card and returns it.  This should be customized to fit your needs.
    //    use "index" to indicate where the information should be pulled.  If this doesn't apply to you,
    //    feel free to get rid of it (eg: if you are building cards from data from the internet)
    
    func createDraggableViewWithDataAtIndex(index:Int) -> DraggableView{
        var draggableView: DraggableView = DraggableView(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH)/2, y: (self.frame.size.height - CARD_HEIGHT)/2 - 30, width: CARD_WIDTH, height: CARD_HEIGHT))
        let imageName: String = clothingCardLabels.objectAtIndex(index) as String
        draggableView.information.image = UIImage(named: imageName)
        draggableView.delegate = self
        return draggableView
    }
    
    //%%% loads all the cards and puts the first x in the "loaded cards" array
    func loadCards(){
        //%%% if the buffer size is greater than the data size,
        //%%% there will be an array error, so this makes sure that doesn't happen
        if clothingCardLabels.count > 0 {
            var numLoadedCardsCap: Int = ((clothingCardLabels.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE: clothingCardLabels.count)
            
            
            //%%% loops through the exampleCardsLabels array to create a card for each label.
            //    This should be customized by removing "exampleCardLabels" with your own array of data
            for (var i = 0; i < clothingCardLabels.count; i++) {
                var newCard: DraggableView = self.createDraggableViewWithDataAtIndex(i)
                allCards.addObject(newCard)
                
                if i < numLoadedCardsCap {
                    //%%% adds a small number of cards to be loaded
                    loadedCards.addObject(newCard)
                }
            }
            
            
            //%%% displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that
            //    not all the cards are showing at once and clogging data
            for (var i = 0; i < loadedCards.count; i++ ){
                if i > 0 {
                    self.insertSubview(loadedCards.objectAtIndex(i) as UIView, belowSubview: loadedCards.objectAtIndex(i-1) as UIView)
                } else {
                    self.addSubview(loadedCards.objectAtIndex(i) as UIView)
                }
                cardsLoadedIndex++ //%%% increment to account for loading a card into loadedCards
            }
        }
    }
    
    //%%% action called when the card goes to the left.
    // This should be customized with your own action
    func cardSwipedLeft(card:UIView){
        //do whatever you want with the card that was swiped
        //    DraggableView *c = (DraggableView *)card;
        
        loadedCards.removeObjectAtIndex(0) //%%% card was swiped, so it's no longer a "loaded card"
        
        if (cardsLoadedIndex < allCards.count) {
            //%%% if we haven't reached the end of all cards, put another into the loaded cards
            loadedCards.addObject(allCards.objectAtIndex(cardsLoadedIndex))
            cardsLoadedIndex++ //%%% loaded a card, so have to increment count
            self.insertSubview(loadedCards.objectAtIndex(MAX_BUFFER_SIZE-1) as UIView, belowSubview: loadedCards.objectAtIndex(MAX_BUFFER_SIZE-2) as UIView)
            
            //%%% keep track of previous action
            previousAction = LEFT_SWIPE
            
        }
        
        println("CardSwipedLeft \(cardsLoadedIndex)")
        
    }
    
    //%%% action called when the card goes to the right.
    func cardSwipedRight(card:UIView){
        //do whatever you want with the card that was swiped
        //    DraggableView *c = (DraggableView *)card;
        
        loadedCards.removeObjectAtIndex(0) //%%% card was swiped, so it's no longer a "loaded card"
        
        if (cardsLoadedIndex < allCards.count) {
            //%%% if we haven't reached the end of all cards, put another into the loaded cards
            loadedCards.addObject(allCards.objectAtIndex(cardsLoadedIndex))
            cardsLoadedIndex++//%%% loaded a card, so have to increment count
            self.insertSubview(loadedCards.objectAtIndex(MAX_BUFFER_SIZE-1) as UIView, belowSubview: loadedCards.objectAtIndex(MAX_BUFFER_SIZE-2) as UIView)
            
            //%%% keep track of previous action
            previousAction = RIGHT_SWIPE
        }
        
        println("CardSwipedRight \(cardsLoadedIndex)")
    }
    
    //%%% action called when the card is double tapped.
    func cardDoubleTapped(card:UIView){
        loadedCards.removeObjectAtIndex(0) //%%% card was swiped, so it's no longer a "loaded card"
        
        if (cardsLoadedIndex < allCards.count) {
            //%%% if we haven't reached the end of all cards, put another into the loaded cards
            loadedCards.addObject(allCards.objectAtIndex(cardsLoadedIndex))
            cardsLoadedIndex++ //%%% loaded a card, so have to increment count
            self.insertSubview(loadedCards.objectAtIndex(MAX_BUFFER_SIZE-1) as UIView, belowSubview: loadedCards.objectAtIndex(MAX_BUFFER_SIZE-2) as UIView)
            
            //%%% keep track of previous action
            previousAction = DOUBLE_TAP
        }
        
        println("CardDoubleTapped \(cardsLoadedIndex)")
    }
    
    //%%% action to be called when undo button is clicked.
    func undoAction(){
        if cardsLoadedIndex > MAX_BUFFER_SIZE {
            var lastBufferCard: DraggableView = loadedCards[MAX_BUFFER_SIZE-1] as DraggableView
            lastBufferCard.removeFromSuperview()
            //%%% fix the deletion from ARC from removeFromeSuperview to add back
            var restoreLastBufferCard:DraggableView = self.createDraggableViewWithDataAtIndex(cardsLoadedIndex-1)
            allCards.replaceObjectAtIndex(cardsLoadedIndex-1, withObject: restoreLastBufferCard)
            
            loadedCards.removeObjectAtIndex(MAX_BUFFER_SIZE-1)
            
            //%%% create the card again, since ARC removed it
            var restoredCard: DraggableView = self.createDraggableViewWithDataAtIndex(cardsLoadedIndex - (MAX_BUFFER_SIZE+1))
            loadedCards.insertObject(restoredCard, atIndex: 0) // put restored card at front of array
            
            //%%% return animation
            restoredCard.alpha = 0
            self.addSubview(restoredCard)
            UIView.animateWithDuration(1.3, animations: {
                restoredCard.alpha = 1
                }, completion: { animationFinished in
                }
            )
            
            cardsLoadedIndex--
            println("cardUndone \(cardsLoadedIndex)")
        }
    }
    
    //%%% when you hit the right button, this is called and substitutes the swipe
    func swipeRight(){
        var dragView: DraggableView = loadedCards.firstObject as DraggableView
        dragView.overlayView?.mode = GGOverlayViewMode.Right
        UIView.animateWithDuration(0.2, animations: {
            dragView.overlayView?.alpha = 1
            var temp = 0 // may need to fix this
        })
        dragView.rightClickAction()
        println("swipedRight")
    }
    
    //%%% when you hit the left button, this is called and substitutes the swipe
    func swipeLeft(){
        var dragView: DraggableView = loadedCards.firstObject as DraggableView
        dragView.overlayView?.mode = GGOverlayViewMode.Left
        UIView.animateWithDuration(0.2, animations: {
            dragView.overlayView?.alpha = 1
            var temp = 0 // may need to fix this
        })
        dragView.leftClickAction()
        println("swipedLeft")
    }
    
    
    //%%% when you hit the have button, this is called and substitutes the double tap
    func doubleTapped(){
        var dragView: DraggableView = loadedCards.firstObject as DraggableView
        dragView.overlayView?.mode = GGOverlayViewMode.Tap
        UIView.animateWithDuration(0.2, animations: {
            dragView.overlayView?.alpha = 1
            var temp = 0 // may need to fix this
        })
        dragView.haveClickAction()
        println("doubleTapped")
    }
    
    
    
}
