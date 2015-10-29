//
// FBLoginVC.swift
// Curate
//


import UIKit
import CoreData

class FBLoginVC: UIViewController, FBLoginViewDelegate {
    
    var authToken = String()
    var introView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
    
    var viewControllers:[UIViewController] = []
    
    lazy var pageController: UIPageViewController = {
        let pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: .Horizontal , options: nil)
        return pageController
    }()
    
    lazy var viewController1: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.blueColor()
        vc.view.tag = 0
        return vc
        }()
    
    lazy var viewController2: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.redColor()
        vc.view.tag = 1
        return vc
        }()
    
    lazy var viewController3: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.greenColor()
        vc.view.tag = 2
        return vc
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginView: FBLoginView = FBLoginView()
        loginView.center = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height - loginView.frame.height/2)
        
        let pageControllerFrame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - loginView.frame.height)
        
        viewControllers = [viewController1,viewController2, viewController3]
        self.pageController.view.frame = pageControllerFrame
        
        self.pageController.setViewControllers([viewControllers[0]], direction: .Forward, animated: false, completion: nil)
        
        self.pageController.dataSource = self
        self.pageController.delegate = self
        
        self.addChildViewController(self.pageController)
        self.view.addSubview(self.pageController.view)
        
        self.view.backgroundColor = UIColor.darkGrayColor()
        
        self.pageController.didMoveToParentViewController(self)
        
        
        
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
                    let mainTabBarController = MainTabBarController()
                    appDelegate.window!.rootViewController = mainTabBarController
            })

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

    func viewControllerAtIndex(index: Int) -> UIViewController {
        let childViewController: UIViewController = viewControllers[index]
        return childViewController
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

extension FBLoginVC: UIPageViewControllerDelegate {
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.viewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension FBLoginVC: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        index--
        print("beforeviewcontroller")
        print(index)
        if(index < 0) {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        index++
        print("after viewcontrolller")
        print(index)
        if(index >= viewControllers.count) {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
}
