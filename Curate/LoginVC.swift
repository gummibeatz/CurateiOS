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
        let bgView = UIImageView(frame: self.view.frame)
        bgView.image = UIImage(named: "closet1")
        vc.view.addSubview(bgView)
        return vc
        }()
    
    lazy var viewController2: UIViewController = {
        let vc = UIViewController()
        let bgView = UIImageView(frame: self.view.frame)
        bgView.image = UIImage(named: "closet2")
        vc.view.addSubview(bgView)
        vc.view.tag = 1
        return vc
        }()
    
    lazy var viewController3: UIViewController = {
        let vc = UIViewController()
        let bgView = UIImageView(frame: self.view.frame)
        bgView.image = UIImage(named: "closet3")
        vc.view.tag = 2
        vc.view.addSubview(bgView)
        return vc
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupLoginButtons()
        setupPageViewController(loginOffset: fbLogin.bounds.height + curateLogin.bounds.height)
        setupIntroView()
    
        
        print("FBSDK accessToken = \(FBSDKAccessToken.currentAccessToken())")
        print("curate authtoken = ")
        
        let hasToken = readCustomObjArrayFromUserDefaults("curateAuthToken").count > 0
        
        if(hasToken) {
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
        let curateString = NSAttributedString(string: "Connect with email")
        curateLogin = UIButton(frame: CGRect(x: 0, y: UIScreen.mainScreen().bounds.height - buttonHeight * 2, width: UIScreen.mainScreen().bounds.width, height: buttonHeight))
        curateLogin.setAttributedTitle(curateString, forState: .Normal)
        curateLogin.addTarget(self, action: "curateLoginTouched", forControlEvents: .TouchUpInside)
        curateLogin.backgroundColor = UIColor(colorLiteralRed: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1.0)
        
        fbLogin = UIButton(frame: CGRect(x: 0, y: UIScreen.mainScreen().bounds.height - buttonHeight, width: UIScreen.mainScreen().bounds.width
            , height: buttonHeight))
        let fbAttributes =  [ NSForegroundColorAttributeName: UIColor.whiteColor() ]
        let fbString = NSAttributedString(string: "Connect with Facebook", attributes: fbAttributes)
        fbLogin.setAttributedTitle(fbString, forState: .Normal)
        fbLogin.addTarget(self, action: "fbLoginTouched", forControlEvents: .TouchUpInside)
        fbLogin.backgroundColor = UIColor(colorLiteralRed: 54/255.0, green: 107/255.0, blue: 166/255.0, alpha: 1.0)
        
        self.view.addSubview(curateLogin)
        self.view.addSubview(fbLogin)
    }
    
    func setupPageViewController(loginOffset loginOffset: CGFloat) {
        viewControllers = [viewController1,viewController2, viewController3]
        self.pageController.view.frame = self.view.frame
        
        self.pageController.setViewControllers([viewControllers[0]], direction: .Forward, animated: false, completion: nil)
        
        self.pageController.dataSource = self
        self.pageController.delegate = self
        self.addChildViewController(self.pageController)
        self.view.insertSubview(self.pageController.view, belowSubview: curateLogin)
        
        self.pageControl.numberOfPages = viewControllers.count
        self.pageControl.frame = CGRect(x: 0, y: UIScreen.mainScreen().bounds.height - loginOffset - 30, width: UIScreen.mainScreen().bounds.width, height: 10)
        self.pageControl.tintColor = UIColor.whiteColor()
        self.pageController.didMoveToParentViewController(self)
        self.view.addSubview(self.pageControl)
    }
    
    func curateLoginTouched() {
        print("curateLoginTapped")
        let curateSignInVC = CurateSignInVC()
        self.presentViewController(curateSignInVC, animated: true, completion: nil)
        self.didMoveToParentViewController(self)
    }
   
    func fbLoginTouched() {
        print("fbLoginTapped")
        
        FBSDKLoginManager().logInWithReadPermissions(["public_profile"], fromViewController: self, handler: {
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
                getCurateAuthToken(FBSDKAccessToken.currentAccessToken().tokenString, completionHandler: {
                    curateAuthToken in
                    writeCustomObjArraytoUserDefaults([curateAuthToken], fileName: "curateAuthToken")
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
