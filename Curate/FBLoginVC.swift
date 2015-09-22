//
// FBLoginVC.swift
// Curate
//


import UIKit
import CoreData

class FBLoginVC: UIViewController, FBLoginViewDelegate {
    
    var authToken = String()
    var introView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        let loginView: FBLoginView = FBLoginView()
        loginView.center = self.view.center
        
        
        setupIntroView()
    
        
        if(FBSession.activeSession().isOpen) {
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            self.authToken = FBSession.activeSession().accessTokenData.accessToken
            print(self.authToken)
            
            UIView.animateWithDuration(2, delay: 1, options: [], animations: {
                self.introView.alpha = 0
                }, completion: {
                    animationFinished in
                    self.introView.removeFromSuperview()
                    self.view.removeFromSuperview()
                    appDelegate.window!.rootViewController = appDelegate.navigationController
//                    appDelegate.setupMeasurementsButton()
            })
//            let delay = 1 * Double(NSEC_PER_SEC)
//            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//            dispatch_after(time, dispatch_get_main_queue()) {
//                UIView.transitionWithView(appDelegate.window!, duration: 2,
//                    options: UIViewAnimationOptions.TransitionCrossDissolve,
//                    animations: {
//                        self.introView.alpha = 0
//                        println("animating")
//                        
//                    }, completion: {
//                        animationFinished in
//                        appDelegate.window!.rootViewController = appDelegate.navigationController
//                        appDelegate.setupMeasurementsButton()
//                })
//            }
        } else {
            self.view.insertSubview(loginView, belowSubview: self.introView)
            UIView.animateWithDuration(2, delay: 1, options: [], animations: {
                self.introView.alpha = 0
                }, completion: {
                    animationFinished in
                    self.introView.removeFromSuperview()
            })
        }
    }
    
    func setupIntroView() {
        let title = UILabel(frame: CGRect(x: UIScreen.mainScreen().bounds.midX - 200, y: 125, width: 400, height: 50))
        title.text = "C U R A T E"
        title.textAlignment = NSTextAlignment.Center
        title.textColor = UIColor.whiteColor()
        title.font = UIFont.systemFontOfSize(40)
        
        let imageView: UIImageView = UIImageView(frame: CGRect(x: UIScreen.mainScreen().bounds.midX - 75, y: 250, width: 150, height: 150))
        imageView.image = UIImage(named: "CurateBowtieBlack")
        
        introView.addSubview(imageView)
        introView.addSubview(title)
        introView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(introView)
        print("introview setup")
    }

    
    func setFBAuthToken() {
        if FBSession.activeSession().isOpen {
            authToken = FBSession.activeSession().accessTokenData.accessToken
        } else {
            print("FBSession state = \(FBSession.activeSession().state)")
        }
        
    }
    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        print("User Logged In")
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        print("User: \(user)")
        print("User ID: \(user.objectID)")
        print("User Name: \(user.name)")
        let userEmail = user.objectForKey("email") as! String
        print("User Email: \(userEmail)")
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        print("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        print("Error: \(handleError.localizedDescription)")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}