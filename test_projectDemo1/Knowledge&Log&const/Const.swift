//
//  Const.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/6/12.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  定义一些宏  会变化的值不要设置为全局量，如：屏幕方向、

// kwindow  最后在viewDidAppear中获取，防止有时获取不到

import UIKit
import CoreText

let appNameKey = "CFBundleName"
let  appVersionKey = "CFBundleShortVersionString" // app版本 全部版本号
let appBundleVersionKey  = "CFBundleVersion" // app build版本 大的版本号


/*
 1.  Documents：保存应用运行时生成的需要持久化的数据，iTunes同步设备时会备份该目录。例如，游戏应用可将游戏存档保存在该目录
 2.  tmp：保存应用运行时所需的临时数据，使用完毕后    再将相应的文件从该目录删除。应用没有运行时，系统也可能会清除该目录下的文件。iTunes同步设备时不会备份该目录
 3.1  Library/Caches：保存应用运行时生成的需要持久化的数据，iTunes同步设备时不会备份该目录。一般存储体积大、不需要备份的非重要数据
 3.2  Library/Preference：保存应用的所有偏好设置，iOS的Settings(设置)应用会在该目录中查找应用的设置信息。iTunes同步设备时会备份该目录
 */
/** 外层temp目录 */
 let temp = NSTemporaryDirectory() // NSHomeDirectory + "/tmp"
/** 外层documents目录 */
let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) // NSHomeDirectory() + "/Documents"
/** 外层library下的caches目录 */
let caches = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) // NSHomeDirectory() + "/Library/Caches"
/** 外层library下的preference目录 */
let preferences = "" // 通过 NSUserDefaults 存储直接到此目录下 ; NSHomeDirectory() + "/Library/Preferences"


/** 不管横竖屏，kwidth   kheight  都是第一次屏幕的情况 */
let kwidth = UIScreen.main.bounds.width
let kheight =  UIScreen.main.bounds.height
let kwindow = UIApplication.shared.keyWindow


let kFileManager =  FileManager.default
let kUserDefaults = UserDefaults.standard
let kNotificationCenter = NotificationCenter.default
/** 当前正在makeKeyAndVisible的window，即当前正在显示且离用户最近的window；注意MyProgressHUD的第二种方式 */
let currentWindow = UIApplication.shared.windows.last
/** 当前正在makeKeyAndVisible的window的 上面的那个window；对比MyProgressHUD的第二种方式 */
let beforWindow = getWindowBeforeOfKeyWindow()
let kDevice = UIDevice.current
/** 屏幕方向 */
//let kOrientation = UIDevice.currentDevice().orientation
/** 屏幕状态栏方向 */
let kStatusDirection = UIApplication.shared.statusBarOrientation

/** 旋转角度， 0--360 */
func rotateRadius(_ radius:Double) -> Double {
    return radius * M_PI / 180
}
//private var _kRotation = 0.0
//var  kRotation:Double {
//    get{
//        return _kRotation * M_PI / 180
//    }
//    set{
//        _kRotation = newValue
//    }
//}


/** 全局的代理 */
let kApplication = UIApplication.shared
let kAppDelegate = (UIApplication.shared.delegate as! AppDelegate)
let kcenter = CGPoint(x: kwidth/2, y: kheight/2)
let kbounds = UIScreen.main.bounds


let hud = MyProgressHUD.init(superView: kwindow!)
//let hud = MyProgressHUD.sharedInstance

/** 图片数组保存路径 */
let totalImagesSavePath =  kBundleDocumentPath() + "totalImages.plist"

/** 全局函数，获取 KeyWindow的上一个window，以解决 MyProgressHUD的第二种方式时的主窗口的就问题 */
func getWindowBeforeOfKeyWindow() -> UIWindow {
    let windows = UIApplication.shared.windows
    
    var beforWindowOfKeyWindow:UIWindow!
    
    for subW in windows {
        
        if subW.windowLevel == UIWindowLevelAlert {
            let index = windows.index(of: subW)!
            if index >= 1 {
                beforWindowOfKeyWindow = windows[index - 1]
            }
            
            
        }
        
    }
    return beforWindowOfKeyWindow
}


/** 系统版本号 */
let kSystemVersion = (UIDevice.current.systemVersion as NSString).doubleValue
let kios7 = ((UIDevice.current.systemVersion as NSString).doubleValue >= 7.0) ? true : false
let kios8:Bool = {
    return (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0
}()
//let kiosx = {return (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8.0} // 相当于定义了一个函数， kiosx就是那个函数，且只是定义了并未执行

let kios9 = ((UIDevice.current.systemVersion as NSString).doubleValue >= 9.0) ? true : false
func kIS_IOS7() ->Bool { return (UIDevice.current.systemVersion as NSString).doubleValue >= 7.0 }
func kIS_IOS8() -> Bool { return (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0 }
func KIS_IOS9() -> Bool  { return (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0 }

// App沙盒路径
func kAppPath() -> String! {
    return NSHomeDirectory()
}
// Documents路径
func kBundleDocumentPath() -> String! {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
}

//Cache
func kCachesPath() -> String! {
    return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
}


/** 打印 */
func MyLog<T>(_ message: T, file: NSString = #file, method: String = #function, line: Int = #line)
{
    #if DEBUG
        print("\(method)[\(line)]: \(message)")
    #endif
}
