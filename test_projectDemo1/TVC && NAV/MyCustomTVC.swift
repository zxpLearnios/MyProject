//
//  MyCustomTVC.swift
//  test_Colsure
//
//  Created by Jingnan Zhang on 16/5/10.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  1. 自定义TVC, 使用提醒按钮  2. 有判断类型

import UIKit



class MyCustomTVC: UITabBarController {
    

    var childVCs = [UIViewController]()
    var customTabBar = MyTabBar()
    var plusBtn = MyPlusButton() // 真正的和其他item平均分占了tabbar，如在自定义的tabbar里加plusBtn，则最左边的item的有效范围始终会挡住plusBtn的左半部
    var toPoint = CGPointZero
//    var isFirstComeIn = true
    
    // MARK: xib\代码  都会调之，但此类型只会调一次
    override class func initialize() {
        self.doInit()
    }
    
    // MARK: 做一些事
    class  func doInit() {
        
        // 所有的字控制器的tabbarItem的 字体属性
        let tabbarItem = UITabBarItem.appearance() // 不能用UIBarButtonItem
        let itemAttributeNormal = [NSFontAttributeName: UIFont.systemFontOfSize(10), NSForegroundColorAttributeName: UIColor.redColor()]
        let itemAttributeHighlight = [NSFontAttributeName: UIFont.systemFontOfSize(10), NSForegroundColorAttributeName: UIColor.greenColor()]
        
        tabbarItem.setTitleTextAttributes(itemAttributeNormal, forState: .Normal)
        tabbarItem.setTitleTextAttributes(itemAttributeHighlight, forState: .Selected) // 用highlight无效
        
        //   此处设置tabbarItem的图片无效(估计纯代码情况下也是无效)
        //        tabBarItem.image = UIImage(named: "Customer_select")
        //        tabBarItem.selectedImage = UIImage(named: "Customer_unselect")
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 0. 以便子控制器的view做转场动画时看到白色
        self.view.backgroundColor = UIColor.whiteColor()
       
        // 1， 加子控制器
        let fistVC = firstChildVC()
        self.addChildViewControllers(fistVC, title: "第一个", itemImage: UIImage(named: "tabBar_me_icon"), itemSelectedImage: UIImage(named: "tabBar_me_click_icon"))
        
        let secondVC = secondChildVC()
        self.addChildViewControllers(secondVC, title: "第二个", itemImage: UIImage(named: "tabBar_essence_icon"), itemSelectedImage: UIImage(named: "tabBar_essence_click_icon"))
        
        let thirdVC = ThirdChildVC()
        self.addChildViewControllers(thirdVC, title: "第三个", itemImage: UIImage(named: "tabBar_friendTrends_icon"), itemSelectedImage: UIImage(named: "tabBar_friendTrends_click_icon"))
        
        
        // 2。 KVO替换原tabbar
        self.setValue(customTabBar, forKey: "tabBar")
        
        // 4.设置tabbaralpha
        self.tabBar.alpha = 0.8
        
//        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
//        dispatch_after(time, dispatch_get_main_queue()) {
//            self.addPlusButton()
//        }
       
        
        // 5. 屏幕旋转通知
//        kDevice.beginGeneratingDeviceOrientationNotifications()
//        kNotificationCenter.addObserver(self, selector: #selector(orientationDidChange), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        
    }

   override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        for item in self.tabBar.subviews {
//            if item.isKindOfClass(UIControl) {
//                item.removeFromSuperview() // 此时不要
//            }
            
//        }
    // MARK: 判断类型
//    is  和 item.isKindOfClass 都是判断一个实例是否是某种类型
    
//        print(self.childViewControllers)
    
    
    }
    
    // 横屏变竖屏后，会再次调用之，故须做处理, 即不能在此处加加号按钮了，因为横屏变竖屏显示testVC后，就会进入此法，此时加号按钮会显示在testVC底部，且进入TabbarVC后plusBtn的位置也不对, 故在viewDidLoad里加plusBtn但需要延迟等viewDidAppear后才可以加，确保只会执行一次; 此时屏幕还是横着的
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    
        // 3.添加加号按钮, 必须在视图显示完毕后添加
//        addPlusButton()
       
    }
    
    
    // MARK: 屏幕旋转了
    @objc private func orientationDidChange(){
        
         if kDevice.orientation == .Portrait {
            
         }
        
        
    }
    // MARK: 添加加号按钮
     func addPlusButton(){
        
        // 设置加号按钮
        self.tabBar.addSubview(plusBtn)
//
        let width = self.view.width / 4 // customTabBar.buttonW
        plusBtn.bounds = CGRectMake(0, 0, width, 50)
        plusBtn.setImage(UIImage(named: "tabBar_publish_icon"), forState: .Normal)
//        plusBtn.setTitle("加号", forState: .Normal)
        plusBtn.addTarget(self, action: #selector(btnAction), forControlEvents: .TouchUpInside)
        
        
        // 动画
        let tabbarCenter = self.view.convertPoint(self.tabBar.center, toView: self.tabBar)
        let ani = CABasicAnimation.init(keyPath: "position")
        ani.duration = 0.5
        ani.fromValue = NSValue.init(CGPoint: CGPointMake(kwidth * 0.2, -kheight * 0.7))
        
        toPoint = CGPointMake(width * 1.5, tabbarCenter.y)
        ani.toValue = NSValue.init(CGPoint: toPoint)
        ani.delegate = self
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.plusBtn.hidden = false
            self.plusBtn.layer.addAnimation(ani, forKey: "")
        }
        
        
    }
    
    
    func btnAction(plusBtn:MyPlusButton) {
        plusBtn.selected = !plusBtn.selected
        print("点击了加号按钮")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: 添加子控制器
    private func addChildViewControllers(viewController:UIViewController, title:String, itemImage:UIImage?, itemSelectedImage:UIImage?){
       
        let newItemSelectdImg = itemSelectedImage?.imageWithRenderingMode(.AlwaysOriginal)
        
        viewController.title = title
        viewController.tabBarItem.image = itemImage
        viewController.tabBarItem.selectedImage = newItemSelectdImg
        
        let nav = MyCustomNav.init(rootViewController: viewController)
        self.addChildViewController(nav)
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        if flag {
            plusBtn.center = toPoint
        }
    }
    
   
}


