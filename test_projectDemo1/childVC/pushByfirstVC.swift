//
//  pushByfirstVC.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/5/30.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  >= 8.2 用KVC强制屏幕旋转才有效; 8.1 以下必须写最后的三个方法，但还是有问题的，即第一次点击屏幕时，不会响应，会提示“2016-08-22 15:09:04.845 test_projectDemo1[13617:948796] unexpected nil window in _UIApplicationHandleEventFromQueueEvent, _windowServerHitTestWindow: <UIWindow: 0x7fbefb597b70; frame = (0 0; 667 375); gestureRecognizers = <NSArray: 0x7fbefb598300>; layer = <UIWindowLayer: 0x7fbefb597db0>>”， 第二次才会响应。

import UIKit
import PullToRefreshKit


class pushByfirstVC: UIViewController {
    
    private var direction = UIInterfaceOrientationMask.init(rawValue: 0)
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var isShow = true
    
    convenience init(){
        self.init(nibName: "pushByfirstVC",bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "pushByFirstVC"
        
        
        //        self.tableView.setUpHeaderRefresh {
        //
        //        }
        //        self.tableView.beginHeaderRefreshing()
        
        // 1.
        //        btn.addTarget(self, action: #selector(btnAction), forControlEvents: .TouchUpInside)
        
        
        // 加通知
        //        kDevice.beginGeneratingDeviceOrientationNotifications()
        //        kNotificationCenter.addObserver(self, selector: #selector(orientationDidChange), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if UIDevice.currentDevice().orientation == .Portrait {
             //强制横屏
            kApplication.setStatusBarOrientation(.LandscapeRight, animated: true)
            
            if kSystemVersion >= 8.2 {
                kDevice.setValue(UIDeviceOrientation.LandscapeRight.rawValue, forKey: "orientation")
            }
            
            //iOS9 填坑方案
            if kSystemVersion >= 9.0 {
//                if self.mytext.isFirstResponder()  {
//                    self.mytext.resignFirstResponder()
//                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
//                    dispatch_after(time, dispatch_get_main_queue()) {
//                        self.mytext.becomeFirstResponder()
//                    }
                }

        }else{
            //强制竖屏
            kApplication.setStatusBarHidden(false, withAnimation: .None)
            kApplication.setStatusBarOrientation(.Portrait, animated: true)
            kDevice.setValue(UIDeviceOrientation.Portrait.rawValue, forKey: "orientation")

        }
        
        
        
    }
    
    
    
    @IBAction func back(btn: UIButton) {
        
        btn.selected = !btn.selected
        
        if btn.selected {
            //            rotateCurrentView(true)
            
        }else{
            //            rotateCurrentView(false)
        }
        
        // 恢复竖屏
        self.dismissViewControllerAnimated(true) {
            
            if UIDevice.currentDevice().orientation == .LandscapeRight || UIDevice.currentDevice().orientation == .LandscapeLeft{
                //强制竖屏
                kApplication.setStatusBarHidden(false, withAnimation: .None) // 主要是防止其他地方隐藏statusBar
                kApplication.setStatusBarOrientation(.Portrait, animated: true)
                kDevice.setValue(UIDeviceOrientation.Portrait.rawValue, forKey: "orientation")
            }
           
        }
        
    }
    
    
    // MARK: 旋转
    //    private func rotateCurrentView(isForLandscape:Bool)  {
    //        let nav = self.navigationController as! MyCustomNav
    //        var width:CGFloat = 0.0
    //        var height:CGFloat = 0.0
    //
    //        if isForLandscape {
    //            direction = .LandscapeRight
    //            width = kbounds.height
    //            height = kbounds.width
    //
    ////            UIView.animateWithDuration(0.2, animations: {
    ////                self.view.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
    ////                nav.view.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
    ////            })
    //
    ////            kwindow!.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
    //            kDevice.setValue(UIDeviceOrientation.LandscapeRight.rawValue, forKey: "orientation")
    //
    ////            kApplication.setStatusBarOrientation(.LandscapeRight, animated: false)
    //        }else{
    //            direction = .Portrait
    //            width = kbounds.width
    //            height = kbounds.height
    ////            kwindow!.transform = CGAffineTransformIdentity
    ////            UIView.animateWithDuration(0.2, animations: {
    ////                self.view.transform = CGAffineTransformIdentity
    ////                nav.view.transform = CGAffineTransformIdentity
    ////            })
    //
    //            kDevice.setValue(UIDeviceOrientation.Portrait.rawValue, forKey: "orientation")
    //
    ////            kApplication.setStatusBarOrientation(.Portrait, animated: true)
    //        }
    ////        nav.view.bounds = CGRectMake(0, 0, width, height)
    //
    ////        kwindow!.frame =  CGRectMake(0, 0, width, height)
    ////         kwindow!.bounds = CGRectMake(0, 0, width, height)
    //        let point = CGPointMake(width/2, height/2)
    ////        kwindow?.center = point
    ////        kwindow!.bounds = CGRectMake(0, 0, width, height)
    //        
    ////        self.view.bounds = CGRectMake(0, 0, width, height)
    //        debugPrint("\(point), ")
    //    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // -------------- private --------------- //
    
    // 8.1 的话必须写一下三个， >=8.2 则无需写了，直接看viewDidAppear里的即可
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return [.LandscapeLeft, .LandscapeRight]
    }
    
    // 写的话，此句必须要， 但是 是直接显示横屏的（瞬间横屏的）
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .LandscapeRight
    }

    
}
