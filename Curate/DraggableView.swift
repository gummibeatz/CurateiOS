//
//  DraggableView.swift
//  WardrobeBuilder
//
//  Created by Kenneth Kuo on 12/11/14.
//  Copyright (c) 2014 Kenneth Kuo. All rights reserved.
//

import UIKit

protocol DraggableViewDelegate {
    func cardSwipedLeft(card:UIView)
    func cardSwipedRight(card:DraggableView)
//    func cardDoubleTapped(card:UIView)
//    func doubleTapped()
}

let ACTION_MARGIN: CGFloat = 120 //%%% distance from center where the action applies. Higher = swipe
//%%%further in order for theaction to be called
let SCALE_STRENGTH: CGFloat = 4 //%%% how quickly the card shrinks. Higher = slower shrinking
let SCALE_MAX: CGFloat = 0.93 //%%% upper bar for how much the card shrinks. Higher = shrinks less
let ROTATION_MAX: CGFloat = 1 //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
let ROTATION_STRENGTH: CGFloat = 320 //%%% strength of rotation. Higher = weaker rotation
let ROTATION_ANGLE: CGFloat = CGFloat(M_PI)/8 //%%% Higher = stronger rotation angle
let CARD_HEIGHT: CGFloat = 350 //%%% height of the draggable card
let CARD_WIDTH: CGFloat = 290  //%%% width of the draggable card

class DraggableView: UIView {
    
    var overlayView: OverlayView?
    var delegate: DraggableViewDelegate?
    var information: UIImageView = UIImageView()
    var xFromCenter: CGFloat = CGFloat()
    var yFromCenter: CGFloat = CGFloat()
    var originalPoint: CGPoint = CGPoint()
    
    required init(coder aDecoder: (NSCoder!)) {
        super.init(coder: aDecoder)
        // ...
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.backgroundColor = UIColor.whiteColor()
        information = UIImageView(frame: CGRectMake(0, 0, CGFloat(CARD_WIDTH-20), CGFloat(CARD_HEIGHT-20)))
        
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("beingDragged:"))
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("beingTapped:"))
//        tapGestureRecognizer.numberOfTapsRequired = 2
//        
        self.addGestureRecognizer(panGestureRecognizer)
//        self.addGestureRecognizer(tapGestureRecognizer)
        self.addSubview(information)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.overlayView = OverlayView(frame: CGRectMake(self.frame.size.width/2-50, 50, 100, 100))
            self.overlayView!.alpha = 0
            self.addSubview(self.overlayView!)
        })
        
    }
    
    func setupView(){
        self.layer.cornerRadius = 4
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSizeMake(1, 1)
    }
    
    //%%% called when you move your finger across the screen.
    // called many times a second
    
    func beingDragged(panGestureRecognizer: UIPanGestureRecognizer){
        xFromCenter = panGestureRecognizer.translationInView(self).x //%%% positive for right swipe, negative for left
        yFromCenter = panGestureRecognizer.translationInView(self).y //%%% positive for up, negative for down
        
        //%%% checks what state the gesture is in. (are you just starting, letting go, or in the middle of a swipe?)
        switch panGestureRecognizer.state {
        case UIGestureRecognizerState.Began:
            self.originalPoint = self.center
            break
            //in the middle of a swipe
        case UIGestureRecognizerState.Changed:
            // dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
            var rotationStrength: CGFloat =  min(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX)
            
            // degree change in radians
            var rotationAngel: CGFloat =  CGFloat(ROTATION_ANGLE * rotationStrength)
            
            // amount the height changes when you move the card up to a certain point
            var scale: CGFloat = max(1 - fabs(rotationStrength)/SCALE_STRENGTH, SCALE_MAX)
            
            // move the object's center by center + gesture coordinate
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter)
            
            // rotate by certain amount
            var transform: CGAffineTransform = CGAffineTransformMakeRotation(rotationAngel)
            
            // scale by certain amount
            var scaleTransform: CGAffineTransform = CGAffineTransformScale(transform, scale, scale)
            
            // apply transformations
            self.transform = scaleTransform
            self.updateOverlay(xFromCenter)
            break
            // let go of the card
        case UIGestureRecognizerState.Ended:
            self.afterDragAction()
            break
        case UIGestureRecognizerState.Possible:
            break
        case UIGestureRecognizerState.Cancelled:
            break
        case UIGestureRecognizerState.Failed:
            break
        }
    }
    
    
//    func beingTapped(tapGestureRecognizer: UITapGestureRecognizer){
//        //checks if gesture is finished
//        if(tapGestureRecognizer.state == UIGestureRecognizerState.Ended) {
//            delegate?.doubleTapped()
//        }
//    }
    
    func updateOverlay(distance: CGFloat){
        if (distance > 0){
            overlayView!.setMode(GGOverlayViewMode.Right)
        }
        else if (distance < 0) {
            overlayView!.setMode(GGOverlayViewMode.Left)
        } else {
            overlayView!.setMode(GGOverlayViewMode.Tap)
        }
        
        overlayView!.alpha = min(fabs(distance)/100, 0.4)
    }
    
    //called when card is let go
    func afterDragAction(){
        if (xFromCenter > ACTION_MARGIN) {
            self.rightAction()
        } else if (xFromCenter < -ACTION_MARGIN) {
            self.leftAction()
        } else {
            //resets the card
            UIView.animateWithDuration(0.3, animations: {
                self.center = self.originalPoint
                self.transform = CGAffineTransformMakeRotation(0)
                self.overlayView!.alpha = 0
            })
        }
    }
    
    //called when swipe exceeds the ACTION_MARGIN to the right
    func rightAction(){
        var finishPoint: CGPoint = CGPoint(x: 500, y: (2 * yFromCenter + self.originalPoint.y))
        UIView.animateWithDuration(0.5, animations: {
            self.center = finishPoint
            }, completion: { animationFinished in
                self.removeFromSuperview()
                self.delegate?.cardSwipedRight(self)
        })
        
    }
    
    //called when swipe exceeds the ACTION_MARGIN to the left
    func leftAction(){
        var finishPoint: CGPoint = CGPoint(x: -500, y: (2 * yFromCenter + self.originalPoint.y))
        UIView.animateWithDuration(0.5, animations: {
            self.center = finishPoint
            }, completion: { animationFinished in
                self.removeFromSuperview()
        })
        delegate?.cardSwipedLeft(self)
    }
    
    
    func rightClickAction(completion: (actionCompleted: Bool) -> Void ) {
        
        overlayView!.setMode(GGOverlayViewMode.Right)
        overlayView!.alpha = 0
        var finishPoint: CGPoint = CGPointMake(600, self.center.y);
        UIView.animateWithDuration(0.7, animations: {
            self.center = finishPoint
            self.transform = CGAffineTransformMakeRotation(1)
            self.overlayView!.alpha = 1
            }, completion: { animationFinished in
                self.removeFromSuperview()
                self.delegate?.cardSwipedRight(self)
                completion(actionCompleted: true)
        })
    }
    
    func leftClickAction(completion: (actionCompleted: Bool) -> Void) {
        overlayView!.setMode(GGOverlayViewMode.Left)
        overlayView!.alpha = 0
        var finishPoint: CGPoint = CGPointMake(-600, self.center.y);
        UIView.animateWithDuration(0.7, animations: {
            self.center = finishPoint
            self.transform = CGAffineTransformMakeRotation(-1)
            self.overlayView!.alpha = 1
            }, completion: { animationFinished in
                self.removeFromSuperview()
                self.delegate?.cardSwipedLeft(self)
                completion(actionCompleted: true)
        })
        
    }
    
//    func haveClickAction(){
//        overlayView!.setMode(GGOverlayViewMode.Tap)
//        overlayView!.alpha = 0
//        var finishPoint: CGPoint = CGPointMake(self.center.x,-100);
//        UIView.animateWithDuration(0.7, animations: {
//            self.center = finishPoint
//            self.overlayView!.alpha = 1
//            }, completion: { animationFinished in
//                self.removeFromSuperview()
//        })
//        delegate?.cardDoubleTapped(self)
//    }
    
}
