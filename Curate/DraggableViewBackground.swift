//
//  DraggableViewBackground.swift
//  WardrobeBuilder
//
//  Created by Curate on 12/10/14.
//  Copyright (c) 2014 Curate. All rights reserved.
//

import UIKit
import CoreData

class DraggableViewBackground: UIView, DraggableViewDelegate {
    
    //declare constants
    let MAX_BUFFER_SIZE = 2 //%%% max number of cards loaded at any given time, must be greater than 1
    var CARD_HEIGHT: CGFloat = {
        if UIDevice().modelName.containsString("iPad") &&
            !UIDevice().modelName.containsString("Pro") ||
            UIDevice().modelName.containsString("iPhone 4") {
            return 350/1.3
        }
        return (SCREENWIDTH - SCREENWIDTH / 20 )  * 350 / 290 //%%% height of the draggable card
    }()
    
    let CARD_WIDTH: CGFloat = {
        if UIDevice().modelName.containsString("iPad") &&
            !UIDevice().modelName.containsString("Pro") ||
            UIDevice().modelName.containsString(("iPhone 4")) {
            return 290/1.3
        }
       return SCREENWIDTH - SCREENWIDTH/20  //%%% width of the draggable card
    }()
    let RIGHT_SWIPE: Int = 0
    let LEFT_SWIPE: Int = 1
    
    var maxBatches: Int? // number of batches we can swipe to
    var beingSwiped: Bool = false //%%% flag to restrict swiping too fast
    var batchIsLoading: Bool = false // %%% flag to restrict clicking during loadNextBatch()
    var clothingCardLabels: NSMutableArray = NSMutableArray()
    var allCards: NSMutableArray = NSMutableArray()
    var loadedCards: NSMutableArray = NSMutableArray()
    var cardsLoadedIndex: Int = Int() //keeps track of where loaded cards are
    var cardsIndex: Int = Int() // keeps track of where you are in cards Index for loading more swipebatches
    var previousActions: Stack<Int> = Stack<Int>()
    var currentBatchIndex: Int = Int()
    var swipeBatch: Array<Array<Clothing>> = Array<Array<Clothing>>()
    var currentUser: User?
    var blurEffectView: UIVisualEffectView =  UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))

    var ownedTops:[Top]?
    var ownedBottoms: [Bottom]?
    var ownedJackets: [Top]?
    var ownedLightLayers: [Top]?
    var ownedCollaredShirts: [Top]?
    var ownedLongSleeveShirts: [Top]?
    var ownedShortSleeveShirts: [Top]?
    
    required init?(coder aDecoder: (NSCoder!)) {
        super.init(coder: aDecoder)
        // ...
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
    }
    
    init(frame: CGRect, swipeBatch: Array<Array<Clothing>>, indexes: Indexes, currentUser: User) {
        super.init(frame: frame)
        super.layoutSubviews()
        
        loadOwnedWardrobe()
        print("owned Tops.count = \(ownedTops!.count)")
        
        dispatch_async(dispatch_get_main_queue(), {
            self.setupView()
        })
        
        self.currentBatchIndex = indexes.batchIndex as Int
        self.swipeBatch = swipeBatch
        maxBatches = swipeBatch.count
        self.currentUser = currentUser
        
        //take this out later when batches are fixed
        if self.currentBatchIndex < maxBatches {
            while(swipeBatch[currentBatchIndex].count == 0) {
                self.currentBatchIndex++
            }
            
            //loading urls of pictures into clothingCardLabels
            for clothes in swipeBatch[self.currentBatchIndex] {
                clothingCardLabels.addObject(clothes)
            }

    //        println(swipeBatch[8].count)
            print("batchindex = \(currentBatchIndex)")
            print("loading finished")
            print(clothingCardLabels.count)
            
            // loading finished
            
            
            //fetch cardsIndex first 
            cardsIndex = indexes.cardsIndex as Int
            cardsLoadedIndex = cardsIndex
            
            self.loadCards()
        } else {
            print("out of batches")
        }

    }
    
    func loadOwnedWardrobe() {
        ownedTops = readCustomObjArrayFromUserDefaults("ownedTops") as? [Top]
        ownedBottoms = readCustomObjArrayFromUserDefaults("ownedBottoms") as? [Bottom]
        ownedJackets = readCustomObjArrayFromUserDefaults("ownedJackets") as? [Top]
        ownedLightLayers = readCustomObjArrayFromUserDefaults("ownedLightLayers") as? [Top]
        ownedCollaredShirts = readCustomObjArrayFromUserDefaults("ownedCollaredShirts") as? [Top]
        ownedLongSleeveShirts = readCustomObjArrayFromUserDefaults("ownedLongSleeveShirts") as? [Top]
        ownedShortSleeveShirts = readCustomObjArrayFromUserDefaults("ownedShortSleeveShirts") as? [Top]
    }
    
    func setupView(){
        self.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1) //the gray background colors
        
        let TAB_BAR_HEIGHT: CGFloat = 49
        
        let buttonYPosition:CGFloat = self.frame.height - TAB_BAR_HEIGHT - 80
        
        let bigButtonWidth: CGFloat = 59
        let smallButtonWidth: CGFloat = 49
        
        let undoButton = UIButton(frame: CGRect(x: self.frame.width/2 - bigButtonWidth-smallButtonWidth - 20
            , y: buttonYPosition, width: smallButtonWidth, height: smallButtonWidth))
        let xButton = UIButton(frame: CGRect(x: self.frame.width/2 - 59 - 10, y: buttonYPosition, width: bigButtonWidth, height: bigButtonWidth))
        let checkButton = UIButton(frame: CGRect(x: self.frame.width/2 + 10, y: buttonYPosition, width: bigButtonWidth, height: bigButtonWidth))
        let likeButton = UIButton(frame: CGRect(x: self.frame.width/2 + bigButtonWidth + 20, y: buttonYPosition, width: smallButtonWidth, height: smallButtonWidth))



        xButton.setImage(UIImage(named: "xButton"), forState: .Normal)
//        haveButton.setImage(UIImage(named: "haveButton"), forState: .Normal)
        undoButton.setImage(UIImage(named: "undoButton"), forState: .Normal)
        checkButton.setImage(UIImage(named: "checkButton"), forState: .Normal)
        likeButton.setImage(UIImage(named: "HeartButton"), forState: .Normal)
        
        
        xButton.addTarget(self, action: "swipeLeft", forControlEvents: .TouchUpInside)
//        haveButton.addTarget(self, action: "doubleTapped", forControlEvents: .TouchUpInside)
        checkButton.addTarget(self, action: "swipeRight", forControlEvents: .TouchUpInside)
        undoButton.addTarget(self, action: "undoAction", forControlEvents: .TouchUpInside)
//        likeButton.addTarget(self, action: "doubleTapped", forControlEvents: .TouchUpInside)
        
        
        self.addSubview(xButton)
        self.addSubview(likeButton)
        self.addSubview(undoButton)
        self.addSubview(checkButton)
    }
    
    //%%% creates a card and returns it.  This should be customized to fit your needs.
    //    use "index" to indicate where the information should be pulled.  If this doesn't apply to you,
    //    feel free to get rid of it (eg: if you are building cards from data from the internet)
    
    func createDraggableViewWithDataAtIndex(index:Int) -> DraggableView{
        let imageData: NSData? = getImageData((clothingCardLabels.objectAtIndex(index) as! Clothing).url!)
        
        let draggableView: DraggableView = DraggableView(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH)/2, y: (self.frame.size.height - CARD_HEIGHT)/2 - 30, width: CARD_WIDTH, height: CARD_HEIGHT))
        print(clothingCardLabels.objectAtIndex(index))
        
        
        dispatch_async(dispatch_get_main_queue(), {
            if imageData != nil {
                draggableView.information.image = UIImage(data: imageData!)
            } else {
                draggableView.information.image = UIImage(named: "stockPerson")!
            }
            })
        
        draggableView.delegate = self
        return draggableView
    }
    
    //%%% loads all the cards and puts the first x in the "loaded cards" array
    func loadCards(){
        //%%% if the buffer size is greater than the data size,
        //%%% there will be an array error, so this makes sure that doesn't happen
        if clothingCardLabels.count > 0 {
            let numLoadedCardsCap: Int = ((clothingCardLabels.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE: clothingCardLabels.count)
            
            
            //%%% loops through the exampleCardsLabels array to create a card for each label.
            //    This should be customized by removing "exampleCardLabels" with your own array of data
            for (var i = 0; i < clothingCardLabels.count; i++) {
                let newCard: DraggableView = self.createDraggableViewWithDataAtIndex(i)
                allCards.addObject(newCard)
                
                if ((i < (numLoadedCardsCap + cardsIndex)) && (i >= cardsIndex))  {
                    //%%% adds a small number of cards to be loaded
                    loadedCards.addObject(newCard)
                }
            }
            
            
            //%%% displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that
            //    not all the cards are showing at once and clogging data
            dispatch_async(dispatch_get_main_queue(), {
                for (var i = 0; i < self.loadedCards.count; i++ ){
                    if i > 0 {
                        self.insertSubview(self.loadedCards.objectAtIndex(i) as! UIView, belowSubview: self.loadedCards.objectAtIndex(i-1) as! UIView)
                    } else {
                        self.addSubview(self.loadedCards.objectAtIndex(i) as! UIView)
                    }
                    self.cardsLoadedIndex++ //%%% increment to account for loading a card into loadedCards
                }
            })
        }
    }
    
    //%%% action called when the card goes to the left.
    // This should be customized with your own action
    func cardSwipedLeft(card:UIView){
        
        print("allcards.count = \(allCards.count)")
        
        loadedCards.removeObjectAtIndex(0) //%%% card was swiped, so it's no longer a "loaded card"
        previousActions.push(LEFT_SWIPE) //%%% push previous action onto stack
        
        if (cardsLoadedIndex < allCards.count) {
            //%%% if we haven't reached the end of all cards, put another into the loaded cards
            loadedCards.addObject(allCards.objectAtIndex(cardsLoadedIndex))
            cardsLoadedIndex++ //%%% loaded a card, so have to increment count
            cardsIndex++
            self.insertSubview(self.loadedCards.objectAtIndex(self.MAX_BUFFER_SIZE-1) as! UIView, belowSubview: self.loadedCards.objectAtIndex(self.MAX_BUFFER_SIZE-2) as! UIView)
            //%%% keep track of previous action
            
            
        } else if(cardsIndex <= allCards.count) {
            cardsIndex++
        }
        
        print("CardSwipedLeft \(cardsLoadedIndex)")
        print("cardsIndex \(cardsIndex)")
        print("~~~~~~~~~~~~~~~")
        
        if(cardsIndex == allCards.count) {
            print("loading new cards")
            //send to run in background thread
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                self.loadNextBatch({
                    loadingFinished in
                    self.blurEffectView.removeFromSuperview()
                    self.batchIsLoading = false
                })
            }
        }
        saveCardsIndex()
        
    }
    
    
    //%%% action called when the card is swipedRight
    func cardSwipedRight(card: DraggableView){
        let clothingArticle: Clothing = swipeBatch[self.currentBatchIndex][cardsIndex]
        saveClothingArticle(clothingArticle, imageData: UIImageJPEGRepresentation(card.information.image!, 0.5)!)
        
        //gonna start formating dict to pass to postwardrobe
        let fbAuthToken = "change later"
//        let fbAuthToken = getFbAuthToken()
        let wardrobeDict: NSMutableDictionary = NSMutableDictionary()
        var ownedTops:[Top] = readCustomObjArrayFromUserDefaults("ownedTops") as! [Top]
        var ownedBottoms:[Bottom] = readCustomObjArrayFromUserDefaults("ownedBottoms") as! [Bottom]
        var topsArr = [NSDictionary]()
        var bottomsArr = [NSDictionary]()
        
        if(ownedTops.count>1) {
            for index in 1...ownedTops.count-1 {
                print(ownedTops[index].fileName)
                print(ownedTops[index].url)
                print(ownedTops[index].properties)
                topsArr.append(ownedTops[index].convertToDict())
            }
        }
        if(ownedBottoms.count>1) {
            for i in 1...ownedBottoms.count-1 {
                bottomsArr.append(ownedBottoms[i].convertToDict())
            }
        }
        print(topsArr)
        print(bottomsArr)
        
        wardrobeDict.setObject(topsArr , forKey: "tops")
        wardrobeDict.setObject(bottomsArr , forKey: "bottoms")
        wardrobeDict.setObject(clothingArticle.convertToDict(), forKey: "clothing")
        getCurateAuthToken(fbAuthToken, completionHandler: {
            curateAuthToken in
            postWardrobe(curateAuthToken, wardrobeDict: wardrobeDict)
        })
        
        
        //formatting and posting wardrove finished
        
        loadedCards.removeObjectAtIndex(0) //%%% card was swiped, so it's no longer a "loaded card"
        previousActions.push(RIGHT_SWIPE) //%%% push actions onto stack
        
        if (cardsLoadedIndex < allCards.count) {
            //%%% if we haven't reached the end of all cards, put another into the loaded cards
            loadedCards.addObject(allCards.objectAtIndex(cardsLoadedIndex))
            cardsLoadedIndex++ //%%% loaded a card, so have to increment count
            cardsIndex++
            
            self.insertSubview(loadedCards.objectAtIndex(MAX_BUFFER_SIZE-1) as! UIView, belowSubview: loadedCards.objectAtIndex(MAX_BUFFER_SIZE-2) as! UIView)
            
            //%%% keep track of previous action
        } else if(cardsIndex <= allCards.count) {
            cardsIndex++
        }
        
        print("CardSwipedRight \(cardsLoadedIndex)")
        print("cardsIndex \(cardsIndex)")
        print("~~~~~~~~~~~~~~~")

        if(cardsIndex == allCards.count) {
            print("loading new cards")
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                self.loadNextBatch({
                    loadingFinished in
                    self.blurEffectView.removeFromSuperview()
                    self.batchIsLoading = false
                })
            }
        }
        saveCardsIndex()
    }
    
    //%%% action to be called when undo button is clicked.
    //Gonna have to fix the indexing at some point to account for different buffer sizes
    //mostly just look for the allcards.count places
    func undoAction(){
        var restoredCard:DraggableView?
        print("batchIsLoading = \(batchIsLoading)")
        print("beingSwiped = \(beingSwiped)")
        //%%% can't undo if you just started the app
        if (previousActions.items.count > 0 && !beingSwiped && !batchIsLoading && cardsIndex > 0) {
            print("================")
            print("allCards.count: \(allCards.count)")
            print("cardsLoadedIndex: \(cardsLoadedIndex)")
            print("loadedCards.count: \(loadedCards.count)")
            self.beingSwiped = true
            
            //%%% can't undo if you are on your first card
            if cardsLoadedIndex > MAX_BUFFER_SIZE {
                //%%% check Edge case when no more loaded Cards
                var lastBufferCard: DraggableView = DraggableView(frame: CGRect())
                var restoreLastBufferCard: DraggableView = DraggableView(frame: CGRect())
                if(loadedCards.count == MAX_BUFFER_SIZE) {
                    lastBufferCard = loadedCards[MAX_BUFFER_SIZE-1] as! DraggableView
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
                
                // put restored card at front of array
                loadedCards.insertObject(restoredCard!, atIndex: 0)
                
                // checks to see if Items need to be removed
                // and sets up for animation
                let finishPoint:CGPoint = restoredCard!.center
                let previousAction = previousActions.pop()
                
                if(previousAction == RIGHT_SWIPE) {
                    ownedTops?.removeLast()
                    writeCustomObjArraytoUserDefaults(ownedTops!, fileName: "ownedTops")
                    restoredCard?.center = CGPointMake(600, self.center.y)
                    restoredCard?.overlayView?.setMode(GGOverlayViewMode.Right)
                    restoredCard?.overlayView?.alpha = 1
                    dispatch_async(dispatch_get_main_queue(), {
                        self.addSubview(restoredCard!)
                        UIView.animateWithDuration(0.7, animations: {
                            restoredCard?.center = finishPoint
                            restoredCard?.overlayView?.alpha = 0
                            }, completion: { animationFinished in
                                self.beingSwiped = false
                        })
                    })
                } else if(previousAction == LEFT_SWIPE) {
                    restoredCard?.center = CGPointMake(-600, self.center.y)
                    restoredCard?.overlayView?.setMode(GGOverlayViewMode.Left)
                    restoredCard?.overlayView?.alpha = 1
                    dispatch_async(dispatch_get_main_queue(), {
                        self.addSubview(restoredCard!)
                        UIView.animateWithDuration(0.7, animations: {
                            restoredCard?.center = finishPoint
                            restoredCard?.overlayView?.alpha = 0
                            }, completion: { animationFinished in
                                self.beingSwiped = false
                        })
                    })
                }
                
                print("loadedCards.count now \(loadedCards.count)")
                print("cardUndone \(cardsLoadedIndex)")
                print("cardIndex = \(cardsIndex)")
            }
        }
        saveCardsIndex()
    }
    
    func swipeRight(){
        if (loadedCards.count > 0 && !beingSwiped && !batchIsLoading) {
            self.beingSwiped = true
            let dragView: DraggableView = loadedCards.firstObject as! DraggableView
            dragView.rightClickAction({actionCompleted in
                print("swipedFinished")
                self.beingSwiped = false
            })
            print("swipedRight")
        }
    }
    
    //%%% when you hit the left button, this is called and substitutes the swipe
    func swipeLeft(){
        if (loadedCards.count > 0 && !beingSwiped && !batchIsLoading) {
            self.beingSwiped = true
            let dragView: DraggableView = loadedCards.firstObject as! DraggableView
            dragView.leftClickAction({ actionCompleted in
                print("swipedFinished")
                self.beingSwiped = false
            })
            print("swipedLeft")
        }
    }
    
    //%% loads next batch by adding in links from the next batch and deleting the previous cards
    func loadNextBatch(completionHandler:(loadingFinished:Bool)->()) {
        print("=====in loadnextBatch=====")
        
        //%%buffer for loadings
        let loadingText = UILabel(frame: CGRect(x: SCREENWIDTH/2-40, y: SCREENHEIGHT/2 - 20, width: 80, height: 20))
        loadingText.text = "Loading dopeness"
        loadingText.textColor = UIColor.whiteColor()
        blurEffectView.addSubview(loadingText)
        self.addSubview(blurEffectView)
        
        self.batchIsLoading = true
        self.currentBatchIndex++
        saveBatchIndex()
        //Will need to change when the batches stop later on
        if self.currentBatchIndex < maxBatches {
            self.clothingCardLabels.removeAllObjects()
            self.allCards.removeAllObjects()
            
            //take this out later when batches are fixed
            while(swipeBatch[currentBatchIndex].count == 0) {
                self.currentBatchIndex++
            }
            
            //loading tops into clothingCardLabels
            for clothes in swipeBatch[currentBatchIndex] {
                self.clothingCardLabels.addObject(clothes)
            }
            print("clothingCard Label count = \(self.clothingCardLabels.count)")
            
            // loading finished
            self.cardsLoadedIndex = 0
            self.cardsIndex = 0
            self.loadCards()
            completionHandler(loadingFinished: true)
        } else {
            print("no more batches")
            print("currentBatchIndex = \(self.currentBatchIndex)")
        }
    }
    
    func saveBatchIndex() {
        let fetchRequest = NSFetchRequest(entityName: "Indexes")
        // Execute the fetch request, and cast the results to an array of Tokens objects
        let fetchResults = (try! managedObjectContext!.executeFetchRequest(fetchRequest)) as! [Indexes]
        let indexes = fetchResults[0]
        indexes.batchIndex = self.currentBatchIndex
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
    }
    
    func saveCardsIndex() {
        let fetchRequest = NSFetchRequest(entityName: "Indexes")
        // Execute the fetch request, and cast the results to an array of Tokens objects
        let fetchResults = (try! managedObjectContext!.executeFetchRequest(fetchRequest)) as! [Indexes]
        let indexes = fetchResults[0]
        indexes.cardsIndex = self.cardsIndex
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
    }
    
    func saveClothingArticle(clothingArticle: Clothing, imageData: NSData) {
        clothingArticle.imageData = UIImageJPEGRepresentation(loadedCards.objectAtIndex(0).information.image!, 0.0)
        print(clothingArticle.mainCategory!)
        switch clothingArticle.mainCategory! as String {
        case "collared_shirt", "jacket", "light_layer", "long_sleeve_shirt", "short_sleeve_shirt":
            let top: Top = Top(top: clothingArticle.properties!, url: clothingArticle.url!, imageData: imageData)
            ownedTops!.append(top) //%%% add top to ownedTops if swiped right
            writeCustomObjArraytoUserDefaults(ownedTops!, fileName: "ownedTops")
            switch clothingArticle.mainCategory! as String {
            case "jacket":
                ownedJackets!.append(top)
                writeCustomObjArraytoUserDefaults(ownedJackets!, fileName: "ownedJackets")
            case "light_layer":
                ownedLightLayers!.append(top)
                writeCustomObjArraytoUserDefaults(ownedLightLayers!, fileName: "ownedLightLayers")
            case "collared_shirt":
                ownedCollaredShirts!.append(top)
                writeCustomObjArraytoUserDefaults(ownedCollaredShirts!, fileName: "ownedCollaredShirts")
            case "long_sleeve_shirt":
                ownedLongSleeveShirts!.append(top)
                writeCustomObjArraytoUserDefaults(ownedLongSleeveShirts!, fileName: "ownedLongSleeveShirts")
            case "short_sleeve_shirt":
                ownedShortSleeveShirts!.append(top)
                writeCustomObjArraytoUserDefaults(ownedShortSleeveShirts!, fileName: "ownedShortSleeveShirts")
            default:
                print("save clothing article tops impossible")
            }
        case "casual", "chinos", "shorts", "suit_pants", "pants":
            let bottom: Bottom = Bottom(bottom: clothingArticle.properties!, url: clothingArticle.url!, imageData: imageData)
            ownedBottoms!.append(bottom) //%%% add bottom to ownedBottoms if swiped right
            writeCustomObjArraytoUserDefaults(ownedBottoms!, fileName: "ownedBottoms")
        default:
            print("not anything")
        }
    }
    
    
    
    
}
