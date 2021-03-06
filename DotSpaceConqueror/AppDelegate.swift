//
//  AppDelegate.swift
//  DotSpaceConqueror
//
//  Created by feialoh on 19/10/15.
//  Copyright © 2015 Cabot. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var mpcManager: MPCManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        presentViewController()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //Start the main screen
    func presentViewController() {
        
        // Override point for customization after application launch.
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "top_bar"), for: UIBarMetrics.default)
        
        UINavigationBar().titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "NotSoStoutDeco", size: 20)!,
                                                  NSAttributedString.Key.foregroundColor:UIColor.white];
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let containerViewController = ContainerViewController()
        
        window!.rootViewController = containerViewController
        window!.makeKeyAndVisible()
        
        mpcManager = MPCManager()
    }
    
    
    //Handle universal links here
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            
                presentViewController()
            
                return true
        }
        return false
    }


}

private var AssociatedObjectHandle: UInt8 = 0
extension UINavigationBar {
    
    var height: CGFloat {
        get {
            if let h = objc_getAssociatedObject(self, &AssociatedObjectHandle) as? CGFloat {
                return h
            }
            return 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        if self.height > 0 {
            return CGSize(width: self.superview!.bounds.size.width, height: self.height);
        }
        return super.sizeThatFits(size)
    }
    
}
