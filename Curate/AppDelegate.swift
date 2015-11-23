//
//  AppDelegate.swift
//  Curate
//
//  Created by Curate on 12/20/14.
//  Copyright (c) 2014 Curate. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, OutfitsVCDelegate {
    
    var screenToCheck = PersonaVC()
    
    var window: UIWindow?
    var measurementsVC: MeasurementsVC?
    var personaController: PersonaVC?
    var fbLoginVC: LoginVC = LoginVC()
    var measurementsButton: UIButton = UIButton()
    
    let WARDROBEBUILDERINDEX = 0
    let OUTFITBUILDERINDEX = 1
    let OUTFITSINDEX = 2
    
    var location = CLLocation()
    let locationManager = CLLocationManager()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow()
        self.window!.makeKeyAndVisible()
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.frame = UIScreen.mainScreen().bounds
//        window?.rootViewController = screenToCheck
        window?.rootViewController = fbLoginVC
       
        // MARK: FB login setup
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //setting up locationmanager
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            print("Clauthorizationstatus not determined")
            locationManager.requestWhenInUseAuthorization()
        } else if CLLocationManager.locationServicesEnabled() {
            print("CLauthorizationstatus location services enabled")
            locationManager.startUpdatingLocation()
        }
        
        personaController = PersonaVC()
        measurementsVC = MeasurementsVC()
        
        return true
    }

    
    func segmentViewControllers() -> NSArray {
        let myVC1 = WardrobeBuilderVC()
        let myVC2 = OutfitBuilderContainerVC()
        let myVC3 = OutfitsContainerVC()
        
        myVC3.setOutfitsVCDelegate(self)
        
        let viewControllers: NSArray = NSArray(objects: myVC1, myVC2, myVC3)
        return viewControllers
    }

    func editButtonTapped() {
        print("editButtonTappedDelegated in AppDelegate")
//        self.segmentedControl.selectedSegmentIndex = OUTFITBUILDERINDEX
//        self.segmentsController.indexDidChangeForSegmentedControl(self.segmentedControl)
    }

    func setupMeasurementsButton() {
        measurementsButton = UIButton(frame: CGRect(x: 17, y: 30, width: 22, height: 22))
        measurementsButton.addTarget(self, action: "measurementsButtonTapped", forControlEvents: .TouchUpInside)
        measurementsButton.setImage(UIImage(named: "menuButton"), forState: .Normal)
        self.window?.addSubview(measurementsButton)
    }

    func measurementsButtonTapped() {
        print("measurementsButtonTapped")
        self.measurementsButton.removeFromSuperview()
        window?.rootViewController = self.measurementsVC
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // Logs 'install' and 'app activate' App Events.
        FBSDKAppEvents.activateApp()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        //         -- MARK FB stuff
        print("in application FB")
        self.window?.rootViewController = self.personaController
        self.fbLoginVC.resignFirstResponder()
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Curate.Curate" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Curate", withExtension: "momd")
        return NSManagedObjectModel(contentsOfURL: modelURL!)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Curate.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        print("inside creating managedObjectContext")
        
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        let managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }

}

//MARK: Delegates CLLocationManager
extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        locationManager.startUpdatingLocation()
        self.location = (locations.last! as CLLocation)
//                println("in did update location")
        //        println("(\(lat),\(long)")
        
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.AuthorizedAlways || status == CLAuthorizationStatus.AuthorizedWhenInUse) {
            manager.startUpdatingLocation()
        }
    }
    
}

