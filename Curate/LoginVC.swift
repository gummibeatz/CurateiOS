//
// FBLoginVC.swift
// Curate
//


import UIKit
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit

class LoginVC: UIViewController {
    
    var authToken = String()
    var introView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
    
    var viewControllers:[UIViewController] = []
    var fbLogin: UIButton!
    var curateLogin: UIButton!
    var pageControl: UIPageControl = UIPageControl()
    
    lazy var pageController: UIPageViewController = {
        let pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: .Horizontal , options: nil)
        return pageController
    }()
    
    lazy var viewController1: UIViewController = {
        let vc = UIViewController()
        vc.view.tag = 0
        
        let bgView = UIImageView(frame: CGRect(x: 40, y: 50, width: SCREENWIDTH-80, height: SCREENHEIGHT - 200))
        print(UIDevice().modelName)
        
        bgView.frame = CGRect(x: 75, y: 50, width: SCREENWIDTH-150, height: SCREENHEIGHT-200)
        if UIDevice().modelName.containsString("iPad") && !UIDevice().modelName.containsString("Pro") {
            bgView.frame = CGRect(x: 75, y: 50, width: SCREENWIDTH-150, height: SCREENHEIGHT-200)
        }
        bgView.image = UIImage(named: "Tutorial Swipe")
        vc.view.addSubview(bgView)
        return vc
        }()
    
    lazy var viewController2: UIViewController = {
        let vc = UIViewController()
        let bgView = UIImageView(frame: CGRect(x: 40, y: 50, width: SCREENWIDTH-80, height: SCREENHEIGHT - 200))
        print(UIDevice().modelName)
        
        bgView.frame = CGRect(x: 75, y: 50, width: SCREENWIDTH-150, height: SCREENHEIGHT-200)
        if UIDevice().modelName.containsString("iPad") && !UIDevice().modelName.containsString("Pro") {
            bgView.frame = CGRect(x: 75, y: 50, width: SCREENWIDTH-150, height: SCREENHEIGHT-200)
        }
        bgView.image = UIImage(named: "Tutorial Wardrobe")
        vc.view.addSubview(bgView)
        vc.view.tag = 1
        return vc
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        //figure out where to put this later
        User.createInManagedObjectContext(managedObjectContext!, preferences: NSDictionary())
        
        setupLoginButtons()
        setupPageViewController(loginOffset: fbLogin.bounds.height + curateLogin.bounds.height)
        setupIntroView()
    
        
        print("FBSDK accessToken = \(FBSDKAccessToken.currentAccessToken())")
        print("curate authtoken = ")
        
        let hasToken = readCustomObjArrayFromUserDefaults("curateAuthToken").count > 0
        
        if(hasToken) {
            let fbAccessToken = readCustomObjArrayFromUserDefaults("fbAccessToken").first as? String
            let curateAuthToken = readCustomObjArrayFromUserDefaults("curateAuthToken").first as? String
            if(fbAccessToken != nil && curateAuthToken != nil) {
                postUserFBToken(curateAuthToken!, fbAccessToken: fbAccessToken!)
            }
            let bufferView = DraggableViewBackground(frame: self.view.frame)
            self.view.insertSubview(bufferView, belowSubview: self.introView)
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
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
            self.view.insertSubview(fbLogin, belowSubview: self.introView)
            UIView.animateWithDuration(2, delay: 1, options: [], animations: {
                self.introView.alpha = 0
                }, completion: {
                    animationFinished in
                    self.introView.removeFromSuperview()
            })
        }
    }
    func setupLoginButtons() {
        let buttonHeight: CGFloat = 50
        let buttonCornerRadius: CGFloat = 5.0
        let buttonBorderWidth: CGFloat = 3.0
        
        
        curateLogin = UIButton(frame: CGRect(x: 0, y: UIScreen.mainScreen().bounds.height - 2 * buttonHeight, width: UIScreen.mainScreen().bounds.width, height: buttonHeight))
        curateLogin.addTarget(self, action: "curateLoginTouched", forControlEvents: .TouchUpInside)
        curateLogin.setTitle("Connect with Email", forState: .Normal)
        curateLogin.setTitleColor(UIColor.blackColor(), forState: .Normal)
        curateLogin.layer.borderWidth = buttonBorderWidth
        curateLogin.layer.borderColor = UIColor.blackColor().CGColor
        curateLogin.layer.cornerRadius = buttonCornerRadius
        
        fbLogin = UIButton(frame: CGRect(x: 0, y: UIScreen.mainScreen().bounds.height - buttonHeight, width: UIScreen.mainScreen().bounds.width
            , height: buttonHeight))
        fbLogin.addTarget(self, action: "fbLoginTouched", forControlEvents: .TouchUpInside)
        fbLogin.setTitle("Connect with Facebook", forState: .Normal)
        fbLogin.setTitleColor(UIColor.curateBlueColor(), forState: .Normal)
        fbLogin.layer.borderWidth = buttonBorderWidth
        fbLogin.layer.borderColor = UIColor.curateBlueColor().CGColor
        fbLogin.layer.cornerRadius = buttonCornerRadius
        
        self.view.addSubview(curateLogin)
        self.view.addSubview(fbLogin)
    }
    
    func setupPageViewController(loginOffset loginOffset: CGFloat) {
        viewControllers = [viewController1,viewController2]
        self.pageController.view.frame = self.view.frame
        
        self.pageController.setViewControllers([viewControllers[0]], direction: .Forward, animated: false, completion: nil)
        
        self.pageController.dataSource = self
        self.pageController.delegate = self
        self.addChildViewController(self.pageController)
        self.view.insertSubview(self.pageController.view, belowSubview: curateLogin)
        
        self.pageControl.numberOfPages = viewControllers.count
        self.pageControl.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.height - loginOffset - 30, width: UIScreen.mainScreen().bounds.width, height: 10)
        self.pageControl.currentPageIndicatorTintColor = UIColor.curateBlueColor()
        self.pageControl.pageIndicatorTintColor = UIColor.darkGrayColor()
        self.pageController.didMoveToParentViewController(self)
        self.view.addSubview(self.pageControl)
    }
    
    func curateLoginTouched() {
        print("curateLoginTapped")
        let curateLoginTabBarController = CurateLoginTabBarController()
        self.presentViewController(curateLoginTabBarController, animated: true, completion: nil)
        self.didMoveToParentViewController(self)
    }
   
    func fbLoginTouched() {
        print("fbLoginTapped")
        
        FBSDKLoginManager().logInWithReadPermissions(["public_profile", "user_posts"], fromViewController: self, handler: {
            (result:FBSDKLoginManagerLoginResult!, error: NSError?) in
            print(result)
            if (error != nil) {
                print("error")
            }
            if (result.isCancelled) {
                print("Fblogin canceled")
            } else {
                print("FBLogin success")
                print("FBSDK Login token = \(FBSDKAccessToken.currentAccessToken().tokenString)")
                writeCustomObjArraytoUserDefaults([FBSDKAccessToken.currentAccessToken().tokenString], fileName: "fbAccessToken")
                getCurateAuthToken(FBSDKAccessToken.currentAccessToken().tokenString, completionHandler: {
                    curateAuthToken in
                    writeCustomObjArraytoUserDefaults([curateAuthToken], fileName: "curateAuthToken")
                    postUserFBToken(curateAuthToken, fbAccessToken: FBSDKAccessToken.currentAccessToken().tokenString)
                })
            }
        })
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
        if  FBSDKAccessToken.currentAccessToken() != nil {
            authToken = FBSDKAccessToken.currentAccessToken().tokenString
        } else {
            print("in set FBAuthToken and cannot login")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension LoginVC: UIPageViewControllerDelegate {
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.viewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {return}
        self.pageControl.currentPage = viewControllers.indexOf(pageViewController.viewControllers!.last!)!
    }
}

extension LoginVC: UIPageViewControllerDataSource {
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
