//
//  Const.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/6/12.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  定义一些宏  会变化的值不要设置为全局量，如：屏幕方向、

// kwindow  最后在viewDidAppear中获取，防止有时获取不到

import UIKit

let appNameKey = "CFBundleName"

let  appVersionKey = "CFBundleShortVersionString" // app版本 全部版本号
let appBundleVersionKey  = "CFBundleVersion" // app build版本 大的版本号

/** 不管横竖屏，kwidth   kheight  都是第一次屏幕的情况 */
let kwidth = UIScreen.mainScreen().bounds.width
let kheight =  UIScreen.mainScreen().bounds.height
let kwindow = UIApplication.sharedApplication().keyWindow




let kNotificationCenter = NSNotificationCenter.defaultCenter()
/** 当前正在makeKeyAndVisible的window，即当前正在显示且离用户最近的window；注意MyProgressHUD的第二种方式 */
let currentWindow = UIApplication.sharedApplication().windows.last
/** 当前正在makeKeyAndVisible的window的 上面的那个window；对比MyProgressHUD的第二种方式 */
let beforWindow = getWindowBeforeOfKeyWindow()

let kDevice = UIDevice.currentDevice()

/** 屏幕方向 */
//let kOrientation = UIDevice.currentDevice().orientation
/** 屏幕状态栏方向 */
let kStatusDirection = UIApplication.sharedApplication().statusBarOrientation


/** 全局的代理 */
let kApplication = UIApplication.sharedApplication()
let kAppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
let kcenter = CGPointMake(kwidth/2, kheight/2)
let kbounds = UIScreen.mainScreen().bounds

let hud = MyProgressHUD.init(superView: kwindow!)

//let hud = MyProgressHUD.sharedInstance

/** 图片数组保存路径 */
let totalImagesSavePath =  kBundleDocumentPath().stringByAppendingString("totalImages.plist")

/** 全局函数，获取 KeyWindow的上一个window，以解决 MyProgressHUD的第二种方式时的主窗口的就问题 */
func getWindowBeforeOfKeyWindow() -> UIWindow {
    let windows = UIApplication.sharedApplication().windows
    
    var beforWindowOfKeyWindow:UIWindow!
    
    for subW in windows {
        
        if subW.windowLevel == UIWindowLevelAlert {
            let index = windows.indexOf(subW)!
            if index >= 1 {
                beforWindowOfKeyWindow = windows[index - 1]
            }
            
        }
        
    }
    return beforWindowOfKeyWindow
}

/** 系统版本号 */
let kSystemVersion = (UIDevice.currentDevice().systemVersion as NSString).doubleValue

func kIS_IOS7() ->Bool { return (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 7.0 }
func kIS_IOS8() -> Bool { return (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8.0 }

func KIS_IOS9() -> Bool  { return (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8.0 }

// App沙盒路径
func kAppPath() -> String! {
    return NSHomeDirectory()
}
// Documents路径
func kBundleDocumentPath() -> String! {
    return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
}

//Cache
func kCachesPath() -> String! {
    return NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first!
}
