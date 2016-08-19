//
//  AppDelegate.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/5/30.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
       
//        MyLog("在APPdelegate里测试打印")
        
        window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        
        
        
        // 1. 启动画面
        let name = "LaunchVC"
        let sb = UIStoryboard.init(name: name, bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier(name)
        window?.rootViewController = vc
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            // 2.是否时最新的
            let guideVC = GuideVC()
            if self.isFirstLatestUse() { // 先进入引导页, 再进首页
                self.window?.rootViewController = guideVC
                
            }else{ // 直接进入首页
                
                self.window?.rootViewController = guideVC
                
            }

        }
        
        // 横屏时，ios7上有电池状态栏，在iOS8就没有电池状态栏了，是因为iOS8默认横屏时将电池状态栏隐藏了，这是iOS8的新特性； 须做以下
        kApplication.setStatusBarHidden(true, withAnimation: .None)
        kApplication.setStatusBarHidden(false, withAnimation: .None)
        
        return true
    }

    /**
     是否是最新版本
     */
    private func isFirstLatestUse() -> Bool{
        
        let previousVersion = NSUserDefaults.standardUserDefaults().valueForKeyPath(appVersionKey)
        let currentVersion = NSBundle.mainBundle().infoDictionary![appVersionKey] as! String // appVersionKey, appBundleVersionKey
 
        if previousVersion == nil {
            NSUserDefaults.standardUserDefaults().setValue(currentVersion, forKey: appVersionKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            return true
        }
        return false
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

