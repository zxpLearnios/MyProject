//
//  MyCustomNav.swift
//  test_Colsure
//
//  Created by Jingnan Zhang on 16/5/11.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  自定义的NAV, 在类方法里不能使用self.，故此中不用initialize;
//  纯代码、xib使用都可以；可能因为swift自身的问题导致了问题（已经分别测试了oc、swift了）


import UIKit


class MyCustomNav: UINavigationController, UINavigationControllerDelegate {

    var rtvc:MyCustomTVC!
    
    let aniTime = 0.5
    
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.doInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // MARK: 初始化
    func doInit() {
        
//        self.navigationBar.barTintColor = UIColor.redColor()
        // 所有push出的控制器的title的属性设置
        let textAttibute = [NSFontAttributeName: UIFont.systemFontOfSize(10), NSForegroundColorAttributeName: UIColor.greenColor()]
        self.navigationBar.titleTextAttributes = textAttibute
        
        
        // 所有的push出的控制器左右item的 属性设置, 但item最好不要拖入，因为长按会变暗
        var  navBaritem = UIBarButtonItem()
        if #available(iOS 9.0, *) {
            navBaritem = UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([MyCustomNav.self])
        } else {
            navBaritem = UIBarButtonItem.appearance()
        }
       
        let itemAttribute = [NSFontAttributeName: UIFont.systemFontOfSize(10), NSForegroundColorAttributeName: UIColor.orangeColor()]
        navBaritem.setTitleTextAttributes(itemAttribute, forState: .Normal)
        navBaritem.setTitleTextAttributes(itemAttribute, forState: .Highlighted) //  Selected Focused Reserved Highlighted
        
//        navBaritem.setBackgroundImage(UIImage(named: "2"), forState: .Normal, barMetrics: .Default)
//        navBaritem.setBackgroundImage(UIImage(named: "2"), forState: .Highlighted, barMetrics: .CompactPrompt)
        
        //  与tabbar有关的， 第一批控制器的标题
        for subVC in self.viewControllers {
            if subVC.tabBarItem != nil {
                subVC.title = subVC.tabBarItem.title
                
            }
        }
        
        // 若滑动返回失效，则清空代理, 即可
        self.interactivePopGestureRecognizer?.delegate = nil
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.doInit()
        
        self.delegate = self
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: 重写此法以拦截所有push的控制器
    override func pushViewController(viewController: UIViewController, animated: Bool) {
       
        if self.childViewControllers.count > 0 { // 非第一批控制器时 的情况
            
            // 左边的按钮
            let leftBtn = UIButton.init(frame: CGRectMake(0, 0, 25, 25))
            leftBtn.setImage(UIImage(named: "navigationbar_back"), forState: .Normal)
            leftBtn.setImage(UIImage(named: "navigationbar_back"), forState: .Highlighted)
            leftBtn.addTarget(self, action: #selector(back), forControlEvents: .TouchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
            
            // 右边的按钮
            
//            viewController.hidesBottomBarWhenPushed = true // statusBra有阴影
            
            
        }
        
        
        // 拿到根控制器
        rtvc = (kwindow?.rootViewController as? MyCustomTVC)
        
        if rtvc != nil { // 说明rootViewController已经变为MyCustomTVC， 而非GuideVC
            // 隐藏tabbar ,需在tabbarVC将要显示时再次显示之
            UIView.animateWithDuration(aniTime) {
                self.rtvc.tabBar.transform = CGAffineTransformMakeTranslation(0, -50)
            }
        }
        
//
            super.pushViewController(viewController, animated: animated)
    }
    
    
    // MARK: 返回
    func back() {
        self.popToRootViewControllerAnimated(true)
        
        // 点击返回按钮返回时有效，但滑动返回时无效, 因为滑动返回时不进入此法，故直接写到nav的didShowViewController里即可
//        if self.rtvc != nil {
//            UIView.animateWithDuration(aniTime) {
//                self.rtvc!.tabBar.transform = CGAffineTransformIdentity
//            }
//        }
    }
    
    
    
    // MARK: 右边按钮的方法
    func rightItemAction() {
        
    }
    
    // MARK:  ---------------------   UINavigationControllerDelegate    -------------- //
    // 将要显示某控制器时， 此时此控制器虽然还没显示但已经是它的topViewController了
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
    
    }
    
    // 将要显示某控制器时， 此时此控制器已经显示，它更是此nav的topViewController了
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        
        // 即此时只有一个（根）控制器, 第一次进入时rVc==nil，故不能用!
        if self.viewControllers.count == 1 {
            UIView.animateWithDuration(aniTime) {
                self.rtvc?.tabBar.transform = CGAffineTransformIdentity
            }
         
        }
//        
//        if self.rtvc != nil {
//            
//            for item in self.rtvc!.tabBar.subviews {
//                if item is MyPlusButton {
//                    
//                    let width = kwidth / 4
//                    item.frame = CGRectMake(width, 0, width, 50)
//                    self.rtvc!.tabBar.addSubview(item)
//                }
//            }
//        }
        

    }
    
    
    // ----------------- private ---------------------- //

    
    
    
    
    
}
