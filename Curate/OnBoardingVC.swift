//
//  onBoardingVC.swift
//  Curate
//
//  Created by Curate on 8/5/15.
//  Copyright (c) 2015 Curate. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class OnBoardingVC: UIViewController {
    
    var personaTag:Int?
    var activeLayer: CALayer?
    var activeViewIdx: Int?
    
    var user: User!
    
    let hipsterTag = 0
    let techTag = 1
    let stylishTag = 2
    let financeTag = 3
    
    let scrollViewImages: [UIImage] = [UIImage(named: "HeightRulerFull")!,
                                       UIImage(named: "FeetSizeRulerFull")!,
                                       UIImage(named: "ShirtFitRulerFull")!,
                                       UIImage(named: "ShirtSizeRulerFull")!,
                                       UIImage(named: "InseamRulerFull")!,
                                       UIImage(named: "InseamRulerFull")!,
                                       UIImage(named: "PantsFitRulerFull")!,
                                        ]
    let viewLabelTitles: [String] = ["What's your vertical?",
                                     "How big are your feet?",
                                     "What's your shirt fit?",
                                     "What's your shirt size?",
                                     "What's your waist size?",
                                     "How do you fit in them jeans?",
                                     "How do you like your fit?",
    
                                    ]
    let viewImages: [UIImage] = [UIImage(named: "Little Man")!,
                                 UIImage(named: "Shoe Thing")!,
                                 UIImage(named: "Shirt")!,
                                 UIImage(named: "Shirt")!,
                                 UIImage(named: "Pant Fit")!,
                                 UIImage(named: "Pant Fit")!,
                                 UIImage(named: "Pant Fit")!,
                                ]
    
    let heightOffset: CGFloat = SCREENHEIGHT/7
    
    let viewFrame: CGRect = CGRect(x: 0, y: SCREENHEIGHT/8, width: SCREENWIDTH, height: 7*SCREENHEIGHT/8)
    
    lazy var onBoardingViews: [UIView] = {
        var views = [UIView]()
        views.append(NSBundle.mainBundle().loadNibNamed("PersonaView", owner: self, options: nil).last as! PersonaView)
        views.append(NSBundle.mainBundle().loadNibNamed("OnBoardingView", owner: self, options: nil).last as! OnBoardingView)
        views.append(NSBundle.mainBundle().loadNibNamed("OnBoardingView", owner: self, options: nil).last as! OnBoardingView)
        views.append(NSBundle.mainBundle().loadNibNamed("OnBoardingView", owner: self, options: nil).last as! OnBoardingView)
        views.append(NSBundle.mainBundle().loadNibNamed("OnBoardingView", owner: self, options: nil).last as! OnBoardingView)
        views.append(NSBundle.mainBundle().loadNibNamed("OnBoardingView", owner: self, options: nil).last as! OnBoardingView)
        views.append(NSBundle.mainBundle().loadNibNamed("OnBoardingView", owner: self, options: nil).last as! OnBoardingView)
        views.append(NSBundle.mainBundle().loadNibNamed("OnBoardingView", owner: self, options: nil).last as! OnBoardingView)
        views.append(self.createWeightScaleView())
        return views
    }()
    
    lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .Default)
        progressBar.trackTintColor = UIColor.blackColor()
        progressBar.progressTintColor = curateBlue
        progressBar.frame = CGRect(x: SCREENWIDTH/4, y: SCREENHEIGHT/14, width: SCREENWIDTH/2, height: 20)
        return progressBar
    }()
    
    lazy var backLabel: UILabel = {
        let backLabel = UILabel(frame: CGRect(x: 10, y: SCREENHEIGHT/16, width: 50, height: 15))
        backLabel.text = "Back"
        backLabel.textColor = UIColor.lightTextColor()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "backButtonTapped")
        backLabel.addGestureRecognizer(gestureRecognizer)
        backLabel.userInteractionEnabled = true
        backLabel.alpha = 0
        return backLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        user = User.createInManagedObjectContext(managedObjectContext!, preferences: NSDictionary())
        
        setupBackground()
        setupPersonaView()
    }
    
    func setupBackground() {
        //adding background picture
        let backgroundView = UIImageView(frame: self.view.bounds)
        backgroundView.image = UIImage(named: "personaViewBG")
        
        self.view.addSubview(backgroundView)
        self.view.addSubview(progressBar)
        self.view.addSubview(backLabel)
    }
    
    func setupPersonaView() {
        let personaView = onBoardingViews.first!
        personaView.frame = viewFrame
        activeViewIdx = 0
        setupPersonaTargets(personaView as! PersonaView)
        self.view.addSubview(personaView)
    }
    
    func backButtonTapped() {
        if activeViewIdx! == 0 {
            print("at first index")
            return
        } else {
            activeViewIdx! -= 1
            let nextView = onBoardingViews[activeViewIdx!]
            nextView.frame = viewFrame
            self.removeActiveLayer()
            UIView.transitionFromView( onBoardingViews[activeViewIdx! + 1], toView: nextView, duration: 0.5, options: .TransitionCrossDissolve, completion: {
                completionHandler in
                print("animation transitioned")
                self.progressBar.setProgress(Float(self.activeViewIdx!) / Float(self.onBoardingViews.count), animated: true)
            })
            if activeViewIdx == 0 {
                setupPersonaView()
                backLabel.alpha = 0
            } else {
                setupMeasurementView(nextView as! OnBoardingView)
            }
        }
    }
    
    func setupPersonaTargets(personaView: PersonaView) {
        personaView.hipsterPersona.addTarget(self, action: "personaTouched:", forControlEvents: .TouchDown)
        personaView.techPersona.addTarget(self, action: "personaTouched:", forControlEvents: .TouchDown )
        personaView.financePersona.addTarget(self, action: "personaTouched:", forControlEvents: .TouchDown)
        personaView.stylishPersona.addTarget(self, action: "personaTouched:", forControlEvents: .TouchDown)
        
        personaView.hipsterPersona.addTarget(self, action: "personaSelected:", forControlEvents: .TouchUpInside)
        personaView.techPersona.addTarget(self, action: "personaSelected:", forControlEvents: .TouchUpInside)
        personaView.financePersona.addTarget(self, action: "personaSelected:", forControlEvents: .TouchUpInside)
        personaView.stylishPersona.addTarget(self, action: "personaSelected:", forControlEvents: .TouchUpInside)
    }
    
    func personaTouched(sender: UIButton) {
        print("persona touched")
        removeActiveLayer()
        activeLayer = createDashedBorderAroundView(sender, heightOffset: heightOffset, borderColor: curateBlue)
        self.view.layer.addSublayer(activeLayer!)
    }
    
    func personaSelected(sender: UIButton) {
        personaTag = sender.tag
        loadNextView()
    }
    
    func loadNextView() {
        if activeViewIdx! > 0 {
            let labelText = (onBoardingViews[activeViewIdx!] as! OnBoardingView).tickView.measurementLabel.text!
            switch activeViewIdx! {
            case 1:
                //height
                user.height = labelText
            case 2:
                //feet
                user.shoeSize = labelText
            case 3:
                //shirt fit
                user.preferredShirtFit = labelText
            case 4:
                //shirt sizes
                user.shirtSize = labelText
            case 5:
                //waist sizes
                user.waistSize = labelText
            case 6:
                //inseam sizes
                user.inseam = labelText
            case 7:
                //pant sizes
                user.preferredPantsFit = labelText
            case 8:
                //weight
                user.weight = labelText
            default:
                print("no cases were matched")
            }
        }
        activeViewIdx! += 1
        backLabel.alpha = 1
        if activeViewIdx! == onBoardingViews.count {
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = MainTabBarController()
            return
        } else {
            let nextView = onBoardingViews[activeViewIdx!]
            nextView.frame = viewFrame
            self.removeActiveLayer()
            UIView.transitionFromView( onBoardingViews[activeViewIdx! - 1], toView: nextView, duration: 0.5, options: .TransitionCrossDissolve, completion: {
                completionHandler in
                print("animation transitioned")
                self.progressBar.setProgress(Float(self.activeViewIdx!) / Float(self.onBoardingViews.count), animated: true)
            })
            if activeViewIdx < onBoardingViews.count - 1 {
                setupMeasurementView(nextView as! OnBoardingView)
            } else {
                setupWeightScaleView(nextView as! WeightScaleView)
            }
            
        }
    }
    
    func createWeightScaleView() -> WeightScaleView {
        let weightView = WeightScaleView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH * 1.5, height: SCREENWIDTH * 1.5))
        let tapGesture = UITapGestureRecognizer(target: self, action: "wheelLabelTapped")
        weightView.label.addGestureRecognizer(tapGesture)
        weightView.label.userInteractionEnabled = true
        return weightView
    }
    
    func setupWeightScaleView(weightScaleView: WeightScaleView) {
        weightScaleView.layer.masksToBounds = false
        weightScaleView.frame = CGRect(x: (SCREENWIDTH - SCREENWIDTH*1.5)/2, y: SCREENHEIGHT - 100, width: SCREENWIDTH*1.5, height: SCREENWIDTH*1.5)
        weightScaleView.center = CGPoint(x: SCREENWIDTH/2, y: SCREENHEIGHT - 100)
    }
    
    func wheelLabelTapped() {
        print("wheelLabelTapped")
        let userPreferences = createUserPreferencesDictionary()
        let curateAuthToken = readCustomObjArrayFromUserDefaults("curateAuthToken").first! as! String
        postUser(curateAuthToken, preferencesDict: userPreferences)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = MainTabBarController()
    }
    
    func createUserPreferencesDictionary() -> NSDictionary {
        let userPreferences = NSMutableDictionary()
        userPreferences.setObject(user.height, forKey: "height")
        userPreferences.setObject(user.shoeSize, forKey: "shoe_size")
        userPreferences.setObject(user.preferredShirtFit, forKey: "preferred_shirt_fit")
        userPreferences.setObject(user.shirtSize, forKey: "preferred_shirt_size")
        userPreferences.setObject(user.waistSize, forKey: "waist_size")
        userPreferences.setObject(user.inseam, forKey: "inseam")
        userPreferences.setObject(user.preferredPantsFit, forKey: "preferred_pants_fit")
        userPreferences.setObject(user.weight, forKey: "weight")
        return userPreferences
    }
    
    func setupMeasurementView(onBoardingView: OnBoardingView) {
        //setting up for individual onboarding
        onBoardingView.tag = activeViewIdx!
        switch activeViewIdx! {
        case 1:
            // height
            onBoardingView.flexiblePagingScrollView.setupFrameWith(pagesPerFrame: 47, totalPages: 47)
        case 2:
            // feet size
            onBoardingView.flexiblePagingScrollView.setupFrameWith(pagesPerFrame: 9, totalPages: 18)
        case 3:
            // shirt fit
            onBoardingView.flexiblePagingScrollView.setupFrameWith(pagesPerFrame: 4, totalPages: 4)
        case 4:
            // shirt size
            onBoardingView.flexiblePagingScrollView.setupFrameWith(pagesPerFrame: 4, totalPages: 6)
        case 5:
            // waist size
            onBoardingView.flexiblePagingScrollView.setupFrameWith(pagesPerFrame: 6, totalPages: 9)
        case 6:
            // inseam
            onBoardingView.flexiblePagingScrollView.setupFrameWith(pagesPerFrame: 6, totalPages: 9)
        case 7:
            // pants fit
            onBoardingView.flexiblePagingScrollView.setupFrameWith(pagesPerFrame: 3, totalPages: 4)
        default:
            break
        }
        
        onBoardingView.setScrollViewImage(scrollViewImages[activeViewIdx! - 1])
        onBoardingView.labelTitle.text = viewLabelTitles[activeViewIdx! - 1]
        onBoardingView.centerImageView.image = viewImages[activeViewIdx! - 1]
        let tapGesture = UITapGestureRecognizer(target: self, action: "loadNextView")
        onBoardingView.centerImageView.addGestureRecognizer(tapGesture)
        onBoardingView.centerImageView.userInteractionEnabled = true
        onBoardingView.setInitialTickViewText()
    }
    
    func removeActiveLayer() {
        if activeLayer != nil {
            activeLayer!.removeFromSuperlayer()
        }
    }
    
}