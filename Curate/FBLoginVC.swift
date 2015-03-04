//
// FBLoginVC.swift
// Curate
//


import UIKit

class FBLoginVC: UIViewController, FBLoginViewDelegate {
    
    var authToken = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var loginView: FBLoginView = FBLoginView()
        loginView.center = self.view.center
        self.view.addSubview(loginView)
        
        var postToken = NSData()
        
        if (FBSession.activeSession().isOpen) {
            authToken = FBSession.activeSession().accessTokenData.accessToken
            
            
            println(authToken)
            //Maybe make a method for switching root viewcontrollers
            var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            appDelegate.window?.rootViewController = appDelegate.navigationController
            appDelegate.setupMeasurementsButton()
            
        }
        
    }
    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        println("User: \(user)")
        println("User ID: \(user.objectID)")
        println("User Name: \(user.name)")
        var userEmail = user.objectForKey("email") as String
        println("User Email: \(userEmail)")
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}