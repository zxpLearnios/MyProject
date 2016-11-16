//
//  AppDelegate.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/5/30.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  performSelectorInBackground   self.performSelectorOnMainThread

import UIKit
import CoreLocation

import AddressBook // ios8
import AddressBookUI

import Contacts // ios9
import ContactsUI


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
       
//        MyLog("在APPdelegate里测试打印")
        
        window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        
//        let xx = "1234567.230"
//        
//        let  str = 1234567.980
//        let newStr = str.formateObjToString(str)
        
        // 1. 启动画面
        let name = "LaunchVC"
        let sb = UIStoryboard.init(name: name, bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier(name)
        window?.rootViewController = vc
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            // 2.是否时最新的
            let guideVC = UINavigationController.init(rootViewController: GuideVC())
            if self.isFirstLatestUse() { // 先进入引导页, 再进首页
                self.window?.rootViewController = guideVC
                
            }else{ // 直接进入首页
                
                self.window?.rootViewController = guideVC
                
            }

        }

        // 横屏时，ios7上有电池状态栏，在iOS8就没有电池状态栏了，是因为iOS8默认横屏时将电池状态栏隐藏了，这是iOS8的新特性； 须做以下
        kApplication.setStatusBarHidden(true, withAnimation: .None)
        kApplication.setStatusBarHidden(false, withAnimation: .None)
        
        
        // 测试多线程
        testTreads()
        
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
   
    
    // MARK: 测试 多线程
    private func testTreads(){
        
        // 0. 队列 里任务的执行顺序由他们之间的依赖决定
        // 1. 操作队列 -- 主队列，（即相当于串行队列，每次最多执行一个任务；操作都在主线程执行，不会新建线程）
//        let mainqueue = NSOperationQueue.mainQueue()
//        
//        // 创建任务
//        let operate = NSBlockOperation.init {
//            debugPrint("operate 执行， 当前线程为\(NSThread.currentThread())")
//        }
//        
//        let operate1 = NSBlockOperation.init {
//            debugPrint("operate1 执行， 当前线程为\(NSThread.currentThread())")
//        }
//        
//        // 任务之间的依赖，（注意不要循环依赖；可以是不同队列的任务之间的依赖）
//        operate.addDependency(operate1)
//        
//        // 添加任务到队列, 即会立即执行
//        mainqueue.addOperation(operate)
//        mainqueue.addOperation(operate1)
//        
//        // 2. 操作队列 -- 自定义队列，（会新建线程，但不确定到底会创建几个新的线程）
//        let customequeue = NSOperationQueue()
////        customequeue.op
//        // 创建任务
//        let coperate = NSBlockOperation.init {
//            debugPrint("coperate 执行， 当前线程为\(NSThread.currentThread())")
//        }
//
//        let coperate1 = NSBlockOperation.init {
//            debugPrint("coperate1 执行， 当前线程为\(NSThread.currentThread())")
//        }
//        
//        let coperate2 = NSBlockOperation.init {
//            debugPrint("coperate2 执行， 当前线程为\(NSThread.currentThread())")
//        }
//        
//        // 任务之间的依赖，（注意不要循环依赖；可以是不同队列的任务之间的依赖）
//        
//        coperate1.addDependency(operate1)
//        coperate1.addDependency(coperate)
//        coperate2.addDependency(coperate1)
//        
//        // 添加任务到队列, 即会立即执行
//        customequeue.addOperation(coperate)
//        customequeue.addOperation(coperate1)
//        customequeue.addOperation(coperate2)
        
        // 3. GCD
        // 3.1 主队列，也就是UI队列, 即为串行队列，同步操作或异步操作都在主线程进行（都是顺序执行的，每次最多执行一个）但同步操作会阻塞主线程，故无用；异步操作有用
//        let mainQueue = dispatch_get_main_queue()
//        dispatch_async(mainQueue) {
//            debugPrint("moperate1 执行， 当前线程为\(NSThread.currentThread())")
//            
//            debugPrint("moperate2 执行， 当前线程为\(NSThread.currentThread())")
//        }
        
        // 3.2 全局队列  即为并行队列，同步操作在主线程上且顺序执行；异步操作，会新建n个线程，不易管理，故基本不用
        
//        let concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0) // 我们用LOW指定队列的优先级，而flag作为保留字段备用，一般为0
//        dispatch_async(concurrentQueue) {
//            
//            debugPrint("globaloperate1 执行， 当前线程为\(NSThread.currentThread())")
//            
//            debugPrint("globaloperate2 执行， 当前线程为\(NSThread.currentThread())")
//        }
        
        
        // 3.3 自定义串行 并行队列
        
        
        // 4. 其他多线程知识
       // 4.1   performSelector 和 GCD中的dispatch_after实现的延时的区别：
        // 1 区别：若在主线程，即不是在多线程的情况下，用performSelector可以，因为主线程默认运行了个runloop，并且有timer，普通的子线程是没有这些的；这个方法在调用的时候会设置当前runloop中timer；若在子线程里，由于子线程里没有自带的runloop和timer，故里面的selector永远不会被调用。此时需要用GCD中的dispatch_after
        // 2 联系： 这两种方式都一个共同的前提，就是当前线程里面需要有一个运行的runloop并且这个runloop里面有一个timer
        
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
//        dispatch_after(time, dispatch_get_main_queue()) {
//            self.test() // 此法里的selector会被调用
//        }
        
//        self.performSelector(#selector(test), withObject: nil, afterDelay: 2) // 此法里的selector会被调用
        
        let ccQueue = dispatch_queue_create("quue_name", DISPATCH_QUEUE_CONCURRENT) // 并行队列
        let csQueue =  dispatch_queue_create("", DISPATCH_QUEUE_SERIAL) // 串行队列
        
        
//        dispatch_sync(ccQueue) {
//             self.performSelector(#selector(self.test), withObject: nil, afterDelay: 2)  // 此法里的selector会被调用, 因为并行队列的同步操作在主线程进行(单线程)，主线程默认自带runloop和timer
//        }
        
//        dispatch_async(ccQueue) {
//            self.performSelector(#selector(self.test), withObject: nil, afterDelay: 2)  // 此法里的selector不会被调用, 因为并行队列的异步操作在其他线程进行（此时是多线程, 开辟了新的线程）
//        }
        
//        dispatch_async(ccQueue) {
//            dispatch_after(time, dispatch_get_main_queue()) {
//                    self.test()
//            } // 此法里的selector会被调用，因为此时仍在主线程里
//        }
        
        
        // 4.2 以下两个方法均是多线程方法
        // 1. performSelectorOnMainThread 不论哪种队列哪种操作，都在主线程执行；参数waitUntilDone 很多说这个参数在主线程无效，这样的说法是错误的，当这个参数为YES时表示当前runloop循环中的时间马上响应这个事件，如果为NO则runloop会将这个事件加入runloop队列在合适的时间执行这个事件
//        dispatch_sync(ccQueue) {
////             self.performSelectorInBackground(#selector(self.test), withObject: nil) // 会开启新的线程，selector会被调用
////            self.performSelectorOnMainThread(#selector(self.test), withObject: nil, waitUntilDone: false) //此法里的selector会被调用
//        }
//        
//        dispatch_async(ccQueue) {
//            
//            self.performSelectorInBackground(#selector(self.test), withObject: nil) // 会开启新的线程，selector会被调用
////            self.performSelectorOnMainThread(#selector(self.test), withObject: nil, waitUntilDone: false) // waitUntilDone 好
//            //此法里的selector会被调用, 仍会在主线程
//        }
//        
        
//        dispatch_sync(csQueue) {
//             self.performSelectorInBackground(#selector(self.test), withObject: nil) // 会开启新的线程，selector会被调用
//            self.performSelectorOnMainThread(#selector(self.test), withObject: nil, waitUntilDone: false) //此法里的selector会被调用。主线程
            
//        }
        
        dispatch_async(ccQueue) {
            
//            self.performSelectorInBackground(#selector(self.test), withObject: nil) // 会开启新的线程，selector会被调用
                self.performSelectorOnMainThread(#selector(self.test), withObject: nil, waitUntilDone: false) //此法里的selector会被调用, 仍会在主线程
        }
        
        
        let c = "" // c.characters.count == 0
        let c1 = " " //c1.characters.count == 1
        
        let c2:String? // 不能这样，因为nil的都不能直接被访问 （c2.characters.count）
        
        // 比较是否相等
        let a = "123asd"
        let b = "123asd"
          // a的内存地址为 \unsafeAddressOf(a)
        debugPrint("a == b \(a==b)")
     
        
        
        // 3. 简单的2种延迟：
        // 定时器延迟加载
        
        // 线程延迟加载
//        NSThread.sleepForTimeInterval(0.4)
//        sleep(1)
        
    }
    
    
    // MARK: 获取位置和通讯录
    //    func isHaveAccessForLocationAndContacts() {
    //        // 注意bundle display name 在ios9时需设置和自己的实际名字一样才可以访问通讯录，不然会一直失败，在setting里设置app名字无用，还是一直失败的。 总之，不好找！
    //
    //        dispatch_async(dispatch_get_main_queue(), {
    //
    //
    //        })
    //
    //
    //        if #available(iOS 9.0, *) {
    //            let status = CNContactStore.authorizationStatusForEntityType(.Contacts)
    //
    //            if  status == .Denied {
    //
    //            }else if status == .Restricted {
    //
    //            }else if status == .NotDetermined {
    //                let  store = CNContactStore.init()
    //                store.requestAccessForEntityType(.Contacts, completionHandler: {    (granted, error) in
    //                    if granted {
    //                        debugPrint("ios9通讯录授权成功！")
    //                    }else{
    //                        debugPrint("ios9通讯录授权失败！\(error)")
    //                    }
    //                })
    //
    //            }else{
    //                debugPrint("ios9已对通讯录授权")
    //            }
    //
    //
    //        }
    //        else { // 非 ios9
    //            // 1. 通讯录
    //            let status = ABAddressBookGetAuthorizationStatus()
    //
    //            if  status == .Denied { // 拒绝访问
    //
    //            }else if status == .Restricted{
    //
    //            }else if status == .NotDetermined{ // 不确定 首次访问相应内容会提
    //                // 创建通讯录
    //                let  addressBook = ABAddressBookCreateWithOptions(nil, nil) as? ABAddressBookRef
    //                //                if addressBook == nil {
    //                //                    return
    //                //                }
    //
    //                // 访问通讯录
    //                ABAddressBookRequestAccessWithCompletion(addressBook, { (granted, error) in
    //                    if granted {
    //                        debugPrint("ios8通讯录授权成功！")
    //                    }else{
    //                        debugPrint("ios8通讯录授权失败！\(error)")
    //                    }
    //
    //                })
    //            }else{ // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
    //                debugPrint("ios8已对通讯录授权")
    //            }
    //
    //
    //        }
    //
    //        // 2. gps
    //        /* 为适配iOS8需要配置info.plist文件
    //         添加以下行：
    //         NSLocationAlwaysUsageDescription 设为Boolean类型 = YES
    //         NSLocationWhenInUseUsageDescription 设为Boolean类型 = YES   */
    //        let gpsStatus = CLLocationManager.authorizationStatus() // 应用gps状态
    //        // status : 0没有操作 1.无法改变 2拒绝 3允许一直 4 允许打开时
    //        let flag = CLLocationManager.locationServicesEnabled()// gps功能是否可用
    //
    //        if flag == true{
    //            if gpsStatus == .AuthorizedAlways || gpsStatus == .AuthorizedWhenInUse { // 已经对app授权
    //
    //            }else{
    //                if gpsStatus == .Restricted { // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
    //
    //
    //                }else if gpsStatus == .Denied{ // 禁止访问
    //
    //                    //                Config.showAlert(withMessage: "请到设置>隐私>定位打开本应用的权限！")
    //                    debugPrint("请到设置>隐私>定位打开本应用的权限！")
    //                }else{ // 刚开始时  不确定
    //
    //                }
    //
    //            }
    //        }else{
    //            Config.showAlert(withMessage: "定位服务不可用！")
    //            return
    //        }
    //
    //        // 3. 定位
    //        locationManager = CLLocationManager()
    //        locationManager.distanceFilter = kCLDistanceFilterNone
    //        // metersself.manger.delegate = self;
    //        //申请后台定位权限 必须在info里面配置
    //        //        locationManager.requestAlwaysAuthorization()
    //        //=======================================
    //        //下面这个是iOS9中新增的方法 开启后台定位
    //        //        locationManager.allowsBackgroundLocationUpdates = true
    //        
    //        // 最高质量
    //        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer //kCLLocationAccuracyBestForNavigation
    //        locationManager.requestWhenInUseAuthorization() // 只在前台开启定位
    //        locationManager.startUpdatingLocation() // 不开启就会访问权限了
    //    
    //    }
    
// ----------------------- private -----------------//
    func test() {
        debugPrint("调用了test方法----------------, 当前线程\(NSThread.currentThread())")
    }

}

