//
//  DraggableViewBackground.swift
//  WardrobeBuilder
//
//  Created by Kenneth Kuo on 12/10/14.
//  Copyright (c) 2014 Kenneth Kuo. All rights reserved.
//

import UIKit
import CoreData

class DraggableViewBackground: UIView, DraggableViewDelegate {
    
    //declare constants
    let MAX_BUFFER_SIZE = 2 //%%% max number of cards loaded at any given time, must be greater than 1
    let CARD_HEIGHT: CGFloat = 350 //%%% height of the draggable card
    let CARD_WIDTH: CGFloat = 290  //%%% width of the draggable card
    let RIGHT_SWIPE: Int = 0
    let LEFT_SWIPE: Int = 1
    
    var beingSwiped: Bool = false //%%% flag to restrict swiping too fast
    var clothingCardLabels: NSMutableArray = NSMutableArray()
    var allCards: NSMutableArray = NSMutableArray()
    var loadedCards: NSMutableArray = NSMutableArray()
    var cardsLoadedIndex: Int = Int() //keeps track of where loaded cards are
    var cardsIndex: Int = Int() // keeps track of where you are in cards Index for loading more swipebatches
    var previousActions: Stack<Int> = Stack<Int>()
    var currentBatchIndex: Int = Int()
    var swipeBatch: [[String]] = [[String]]()

    var ownedTops:[Top]?
    var ownedSweaters: [Sweater]?
    var ownedJackets: [Jacket]?
    var ownedBottoms: [Bottom]?
    var ownedShoes: [Shoes]?
    
    required init(coder aDecoder: (NSCoder!)) {
        super.init(coder: aDecoder)
        // ...
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
    }
    
    init(frame: CGRect, swipeBatch: [[String]], indexes: Indexes) {
        super.init(frame: frame)
        super.layoutSubviews()
        
        loadOwnedWardrobe()
        println("owned Tops.count = \(ownedTops!.count)")
        
        self.setupView()
        self.currentBatchIndex = indexes.batchIndex as Int
        self.swipeBatch = swipeBatch
        let currentBatch: [String] = swipeBatch[self.currentBatchIndex] as [String]
        
        //loading urls of pictures into clothingCardLabels
        for link in currentBatch {
            clothingCardLabels.addObject(link)
        }
        println(clothingCardLabels.count)
        
        // loading finished
        
        
        //fetch cardsIndex first 
        cardsIndex = indexes.cardsIndex as Int
        cardsLoadedIndex = cardsIndex
        self.loadCards()
    }
    
    func loadOwnedWardrobe() {
        ownedTops = readCustomObjArrayFromUserDefaults("ownedTops") as? [Top]
        ownedSweaters = readCustomObjArrayFromUserDefaults("ownedSweaters") as? [Sweater]
        ownedJackets = readCustomObjArrayFromUserDefaults("ownedJackets") as? [Jacket]
        ownedBottoms = readCustomObjArrayFromUserDefaults("ownedBottoms") as? [Bottom]
        ownedShoes = readCustomObjArrayFromUserDefaults("ownedShoes") as? [Shoes]
        
        if(ownedTops!.count == 0) {
            var emptyTop = Top()
            emptyTop.image =  UIImagePNGRepresentation(UIImage(named: "notAvailable"))
            ownedTops!.append(emptyTop)
            writeCustomObjArraytoUserDefaults(ownedTops!, "ownedTops")
        }
        if(ownedSweaters!.count == 0) {
            var emptySweater = Sweater()
            emptySweater.image =  UIImagePNGRepresentation(UIImage(named: "notAvailable"))
            ownedSweaters!.append(emptySweater)
            writeCustomObjArraytoUserDefaults(ownedSweaters!, "ownedSweaters")
        }
        if(ownedJackets!.count == 0) {
            var emptyJacket = Jacket()
            emptyJacket.image =  UIImagePNGRepresentation(UIImage(named: "notAvailable"))
            ownedJackets!.append(emptyJacket)
            writeCustomObjArraytoUserDefaults(ownedJackets!, "ownedJackets")
        }
        if(ownedBottoms!.count == 0) {
            var emptyBottom = Bottom()
            emptyBottom.image =  UIImagePNGRepresentation(UIImage(named: "notAvailable"))
            ownedBottoms!.append(emptyBottom)
            writeCustomObjArraytoUserDefaults(ownedBottoms!, "ownedBottoms")
        }
        if(ownedShoes!.count == 0) {
            var emptyShoes = Shoes()
            emptyShoes.image =  UIImagePNGRepresentation(UIImage(named: "notAvailable"))
            ownedShoes!.append(emptyShoes)
            writeCustomObjArraytoUserDefaults(ownedShoes!, "ownedShoes")
        }
        
    }
    
    func setupView(){
        self.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1) //the gray background colors
        let menuButton = UIButton(frame: CGRect(x: 17, y: 34, width: 22, height: 15))
        let messageButton = UIButton(frame: CGRect(x: 284, y: 34, width: 18, height: 18))
        let xButton = UIButton(frame: CGRect(x: self.frame.width/4 - 70, y: self.frame.height - 120, width: 59, height: 59))
//        let haveButton = UIButton(frame:CGRect(x: self.frame.width/2 - 70, y: self.frame.height - 120, width: 59, height: 59))
        let undoButton = UIButton(frame: CGRect(x: self.frame.width/2 - 29.5, y: self.frame.height - 120, width: 59, height: 59))
        let checkButton = UIButton(frame: CGRect(x: self.frame.width - 70, y: self.frame.height - 120, width: 59, height: 59))
        
        
        menuButton.setImage(UIImage(named: "menuButton"), forState: .Normal)
        messageButton.setImage(UIImage(named: "messageButton"), forState: .Normal)
        xButton.setImage(UIImage(named: "xButton"), forState: .Normal)
//        haveButton.setImage(UIImage(named: "haveButton"), forState: .Normal)
        undoButton.setImage(UIImage(named: "undoButton"), forState: .Normal)
        checkButton.setImage(UIImage(named: "checkButton"), forState: .Normal)
        
        
        xButton.addTarget(self, action: "swipeLeft", forControlEvents: .TouchUpInside)
//        haveButton.addTarget(self, action: "doubleTapped", forControlEvents: .TouchUpInside)
        checkButton.addTarget(self, action: "swipeRight", forControlEvents: .TouchUpInside)
        undoButton.addTarget(self, action: "undoAction", forControlEvents: .TouchUpInside)
        
        
        self.addSubview(menuButton)
        self.addSubview(messageButton)
        self.addSubview(xButton)
//        self.addSubview(haveButton)
        self.addSubview(undoButton)
        self.addSubview(checkButton)
    }
    
    //%%% creates a card and returns it.  This should be customized to fit your needs.
    //    use "index" to indicate where the information should be pulled.  If this doesn't apply to you,
    //    feel free to get rid of it (eg: if you are building cards from data from the internet)
    
    func createDraggableViewWithDataAtIndex(index:Int) -> DraggableView{
        var draggableView: DraggableView = DraggableView(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH)/2, y: (self.frame.size.height - CARD_HEIGHT)/2 - 30, width: CARD_WIDTH, height: CARD_HEIGHT))
        let imageData: NSData = getImage(clothingCardLabels.objectAtIndex(index) as String)
        draggableView.information.image = UIImage(data: imageData)
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
                
                if ((i < (numLoadedCardsCap + cardsIndex)) && (i >= cardsIndex))  {
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
        
        println("allcards.count = \(allCards.count)")
        
        loadedCards.removeObjectAtIndex(0) //%%% card was swiped, so it's no longer a "loaded card"
        previousActions.push(LEFT_SWIPE) //%%% push previous action onto stack
        
        if (cardsLoadedIndex < allCards.count) {
            //%%% if we haven't reached the end of all cards, put another into the loaded cards
            loadedCards.addObject(allCards.objectAtIndex(cardsLoadedIndex))
            cardsLoadedIndex++ //%%% loaded a card, so have to increment count
            cardsIndex++
            self.insertSubview(loadedCards.objectAtIndex(MAX_BUFFER_SIZE-1) as UIView, belowSubview: loadedCards.objectAtIndex(MAX_BUFFER_SIZE-2) as UIView)
            
            //%%% keep track of previous action
            
            
        } else if(cardsIndex <= allCards.count) {
            cardsIndex++
        }
        
        println("CardSwipedLeft \(cardsLoadedIndex)")
        println("cardsIndex \(cardsIndex)")
        println("~~~~~~~~~~~~~~~")
        
        if(cardsIndex == allCards.count) {
            println("loading new cards")
            self.loadNextBatch()
        }
        saveCardsIndex()
        
    }
    
    /// OLD cardSwipedRight func
    //%%% action called when the card goes to the right.
//    func cardSwipedRight(card:UIView){
//        //do whatever you want with the card that was swiped
//        //    DraggableView *c = (DraggableView *)card;
//        
//        loadedCards.removeObjectAtIndex(0) //%%% card was swiped, so it's no longer a "loaded card"
//        
//        if (cardsLoadedIndex < allCards.count) {
//            //%%% if we haven't reached the end of all cards, put another into the loaded cards
//            loadedCards.addObject(allCards.objectAtIndex(cardsLoadedIndex))
//            cardsLoadedIndex++//%%% loaded a card, so have to increment count
//            cardsIndex++
//            
//            self.insertSubview(loadedCards.objectAtIndex(MAX_BUFFER_SIZE-1) as UIView, belowSubview: loadedCards.objectAtIndex(MAX_BUFFER_SIZE-2) as UIView)
//            
//            //%%% keep track of previous action
//            previousAction = RIGHT_SWIPE
//        } else if(cardsIndex <= allCards.count) {
//            cardsIndex++
//        }
//        
//        println("CardSwipedRight \(cardsLoadedIndex)")
//        println("cardsIndex \(cardsIndex)")
//        println("~~~~~~~~~~~~~~~")
//        
//        if(cardsIndex == allCards.count) {
//            println("loading new cards")
//            self.loadNextBatch()
//        }
//        saveCardsIndex()
//        
//    }
    
    //%%% action called when the card is double tapped.
    func cardSwipedRight(card:UIView){
        // Begin Edit ********
        // gonna add to the correct clothingCategory Array
        // MUST CHANGE LATER TO INCLUDE PROPERTIES!!!!!!
        var top: Top = Top()
        var topImageData: NSData = UIImageJPEGRepresentation(loadedCards.objectAtIndex(0).information.image!, 0.0)
        top.image = topImageData
        
        ownedTops!.append(top) //%%% add top to ownedTops if swiped right
        
        writeCustomObjArraytoUserDefaults(ownedTops!, "ownedTops")
        //End edit ********
        
        loadedCards.removeObjectAtIndex(0) //%%% card was swiped, so it's no longer a "loaded card"
        previousActions.push(RIGHT_SWIPE) //%%% push actions onto stack
        
        if (cardsLoadedIndex < allCards.count) {
            //%%% if we haven't reached the end of all cards, put another into the loaded cards
            loadedCards.addObject(allCards.objectAtIndex(cardsLoadedIndex))
            cardsLoadedIndex++ //%%% loaded a card, so have to increment count
            cardsIndex++
            
            self.insertSubview(loadedCards.objectAtIndex(MAX_BUFFER_SIZE-1) as UIView, belowSubview: loadedCards.objectAtIndex(MAX_BUFFER_SIZE-2) as UIView)
            
            //%%% keep track of previous action
        } else if(cardsIndex <= allCards.count) {
            cardsIndex++
        }
        
        println("CardSwipedRight \(cardsLoadedIndex)")
        println("cardsIndex \(cardsIndex)")
        println("~~~~~~~~~~~~~~~")
        
        if(cardsIndex == allCards.count) {
            println("loading new cards")
            self.loadNextBatch()
        }
        saveCardsIndex()
    }
    
    //%%% action to be called when undo button is clicked.
    //Gonna have to fix the indexing at some point to account for different buffer sizes
    //mostly just look for the allcards.count places
    func undoAction(){
        println("================")
        println("allCards.count: \(allCards.count)")
        println("cardsLoadedIndex: \(cardsLoadedIndex)")
        println("loadedCards.count: \(loadedCards.count)")
        var restoredCard:DraggableView?
        
        //%%% can't undo if you just started the app
        if (previousActions.items.count > 0 && !beingSwiped) {
            self.beingSwiped = true
            
            //%%% can't undo if you are on your first card
            if cardsLoadedIndex > MAX_BUFFER_SIZE {
                //%%% check Edge case when no more loaded Cards
                var lastBufferCard: DraggableView = DraggableView(frame: CGRect())
                var restoreLastBufferCard: DraggableView = DraggableView(frame: CGRect())
                if(loadedCards.count == MAX_BUFFER_SIZE) {
                    lastBufferCard = loadedCards[MAX_BUFFER_SIZE-1] as DraggableView
                    loadedCards.removeObjectAtIndex(MAX_BUFFER_SIZE-1)
                    //%%% fix the deletion by ARC from removeFromSuperview to add back
                    restoreLastBufferCard = self.createDraggableViewWithDataAtIndex(cardsLoadedIndex-1)
                    
                    
                    lastBufferCard.removeFromSuperview()
                    
                    allCards.replaceObjectAtIndex(cardsLoadedIndex-1, withObject: restoreLastBufferCard)
                    
                    //%%% create the card again, since ARC removed it
                    restoredCard = self.createDraggableViewWithDataAtIndex(cardsLoadedIndex - (MAX_BUFFER_SIZE+1))
                    cardsLoadedIndex--
                    // can't think might break fix this later!!!!
                    cardsIndex--
                    
                } else if (loadedCards.count == 1) {
                    restoreLastBufferCard = self.createDraggableViewWithDataAtIndex(allCards.count-1)
                    allCards.replaceObjectAtIndex(allCards.count-1, withObject: restoreLastBufferCard)
                    restoredCard = self.createDraggableViewWithDataAtIndex(allCards.count-2)
                    cardsIndex--
                    
                } else {
                    restoredCard = self.createDraggableViewWithDataAtIndex(allCards.count - 1)
                }
                
                //checks to see if Items need to be removed
                var previousAction = previousActions.pop()
                if(previousAction == RIGHT_SWIPE) {
                    ownedTops?.removeLast()
                    writeCustomObjArraytoUserDefaults(ownedTops!, "ownedTops")
                }
                
                
                // put restored card at front of array
                loadedCards.insertObject(restoredCard!, atIndex: 0)
                
                println("loadedCards.count now \(loadedCards.count)")
                //%%% undo animation
                restoredCard!.alpha = 0
                self.addSubview(restoredCard!)
                UIView.animateWithDuration(1.3, animations: {
                    restoredCard!.alpha = 1
                    }, completion: { animationFinished in
                        self.beingSwiped = false
                    }
                )
                println("cardUndone \(cardsLoadedIndex)")
                println("cardIndex = \(cardsIndex)")
            }
        }
        saveCardsIndex()
    }
    
    /// OLD SWIPE RIGHT FUNCTION
//    //%%% when you hit the right button, this is called and substitutes the swipe
//    func swipeRight(){
//        if (loadedCards.count > 0) {
//            var dragView: DraggableView = loadedCards.firstObject as DraggableView
//            dragView.overlayView?.mode = GGOverlayViewMode.Right
//            UIView.animateWithDuration(0.2, animations: {
//                dragView.overlayView?.alpha = 1
//                var temp = 0 // may need to fix this
//            })
//            dragView.rightClickAction()
//            println("swipedRight")
//        }
//    }
    
    func swipeRight(){
        if (loadedCards.count > 0 && !beingSwiped) {
            self.beingSwiped = true
            var dragView: DraggableView = loadedCards.firstObject as DraggableView
            dragView.rightClickAction({actionCompleted in
                println("swipedFinished")
                self.beingSwiped = false
            })
            println("swipedRight")
        }
    }
    
    //%%% when you hit the left button, this is called and substitutes the swipe
    func swipeLeft(){
        if (loadedCards.count > 0 && !beingSwiped) {
            self.beingSwiped = true
            var dragView: DraggableView = loadedCards.firstObject as DraggableView
            dragView.leftClickAction({ actionCompleted in
                println("swipedFinished")
                self.beingSwiped = false
            })
            println("swipedLeft")
        }
    }
    
    
    //%%% when you hit the have button, this is called and substitutes the double tap
//    func doubleTapped(){
//        if (loadedCards.count > 0) {
//            var dragView: DraggableView = loadedCards.firstObject as DraggableView
//            dragView.overlayView?.mode = GGOverlayViewMode.Tap
//            UIView.animateWithDuration(0.2, animations: {
//                dragView.overlayView?.alpha = 1
//                var temp = 0 // may need to fix this
//            })
//            dragView.rightClickAction()
//            println("doubleTapped")
//        }
//    }
    
    //%% loads next batch by adding in links from the next batch and deleting the previous cards
    func loadNextBatch() {
        println("=====in loadnextBatch=====")
        self.currentBatchIndex++
        saveBatchIndex()
        
        let currentBatch: [String] = self.swipeBatch[self.currentBatchIndex] as [String]
        
        clothingCardLabels.removeAllObjects()
        allCards.removeAllObjects()
        
        //loading urls of pictures into clothingCardLabels
        for link in currentBatch {
            clothingCardLabels.addObject(link)
        }
        println("clothingCard Label count = \(clothingCardLabels.count)")
        
        // loading finished
        cardsLoadedIndex = 0
        cardsIndex = 0
        self.loadCards()
        
    }
    
    func saveBatchIndex() {
        let fetchRequest = NSFetchRequest(entityName: "Indexes")
        // Execute the fetch request, and cast the results to an array of Tokens objects
        let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as [Indexes]
        var indexes = fetchResults[0]
        indexes.batchIndex = self.currentBatchIndex
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    }
    
    func saveCardsIndex() {
        let fetchRequest = NSFetchRequest(entityName: "Indexes")
        // Execute the fetch request, and cast the results to an array of Tokens objects
        let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as [Indexes]
        var indexes = fetchResults[0]
        indexes.cardsIndex = self.cardsIndex
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    }
    
    
    
    
}
