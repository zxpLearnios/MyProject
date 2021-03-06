//
//  MyCustomTVC.swift
//  test_Colsure
//
//  Created by Jingnan Zhang on 16/5/10.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  1. 自定义TVC, 使用提醒按钮  2. 有判断类型; 3. plusBtn 做动画，从某处到tabbar的指定位置，动画结束后，主动刷新tabbar的子控件，在tabbar里加了判断，移除plusBtn，将此处加自定义的只有图片的tabbarItem即可；实现切屏时的位移问题的处理。 即只要是通过addSubView上到tabbar的估计在横竖屏切换时都会出错，必须是tabbar自带的东西才不会出错的。

import UIKit


class MyCustomTVC: UITabBarController, UITabBarControllerDelegate, CAAnimationDelegate {
    
    
    var childVCs = [UIViewController]()
    var customTabBar = MyTabBar()
    var plusBtn = MyPlusButton() // 真正的和其他item平均分占了tabbar，如在自定义的tabbar里加plusBtn，则最左边的item的有效范围始终会挡住plusBtn的左半部
    var toPoint = CGPoint.zero
    var isCompleteAnimate = false
    
    // MARK: xib\代码  都会调之，但此类型只会调一次
    override class func initialize() {
        self.doInit()
    }
    
    // MARK: 做一些事
    class  func doInit() {
        
        // 所有的字控制器的tabbarItem的 字体属性
        let tabbarItem = UITabBarItem.appearance() // 不能用UIBarButtonItem
        let itemAttributeNormal = [NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.red]
        let itemAttributeHighlight = [NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName: UIColor.green]
        
        tabbarItem.setTitleTextAttributes(itemAttributeNormal, for: UIControlState())
        tabbarItem.setTitleTextAttributes(itemAttributeHighlight, for: .selected) // 用highlight无效
        
        //   此处设置tabbarItem的图片无效(估计纯代码情况下也是无效)
        //        tabBarItem.image = UIImage(named: "Customer_select")
        //        tabBarItem.selectedImage = UIImage(named: "Customer_unselect")
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -1
        self.delegate = self
        
        // 0. 以便子控制器的view做转场动画时看到白色
        self.view.backgroundColor = UIColor.white
       
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
        
        let time = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.addPlusButton()
        }
       
        
        self.addChildViewControllers(UIViewController(), title: "", itemImage: UIImage(named: "tabBar_publish_icon"), itemSelectedImage: UIImage(named: "tabBar_publish_icon"))
        
        // 5. 屏幕旋转通知
        kDevice.beginGeneratingDeviceOrientationNotifications()
        kNotificationCenter.addObserver(self, selector: #selector(orientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        
    }

   override func viewWillAppear(_ animated: Bool) {
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    
        // 3.添加加号按钮, 必须在视图显示完毕后添加
//        addPlusButton()
       
    }
    
    
    // MARK: 屏幕旋转了
    @objc fileprivate func orientationDidChange(){
        
         if kDevice.orientation == .portrait {
            
         }
        
        if kDevice.orientation == .landscapeRight || kDevice.orientation == .landscapeLeft {
            
        }
        
        
    }
    
    // MARK: 添加加号按钮
     func addPlusButton(){
        
        // 设置加号按钮
        self.tabBar.addSubview(plusBtn)
//
        let width = self.view.width / 4 // customTabBar.buttonW
        plusBtn.bounds = CGRect(x: 0, y: 0, width: width, height: 50)
        plusBtn.setImage(UIImage(named: "tabBar_publish_icon"), for: UIControlState())
//        plusBtn.setTitle("加号", forState: .Normal)
        plusBtn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
        
        // 动画
        let tabbarCenter = self.view.convert(self.tabBar.center, to: self.tabBar)
        let ani = CABasicAnimation.init(keyPath: "position")
        ani.duration = 0.5
        ani.fromValue = NSValue.init(cgPoint: CGPoint(x: kwidth * 0.2, y: -kheight * 0.7))
        
        toPoint = CGPoint(x: width * 1.5, y: tabbarCenter.y)
        ani.toValue = NSValue.init(cgPoint: toPoint)
        ani.delegate = self
        
        let time = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.plusBtn.isHidden = false
            self.plusBtn.layer.add(ani, forKey: "")
        }
        
        
    }
    
    
    func btnAction(_ plusBtn:MyPlusButton) {
        plusBtn.isSelected = !plusBtn.isSelected
        print("点击了加号按钮")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: 添加子控制器
    fileprivate func addChildViewControllers(_ viewController:UIViewController, title:String, itemImage:UIImage?, itemSelectedImage:UIImage?){
       
        let newItemSelectdImg = itemSelectedImage?.withRenderingMode(.alwaysOriginal)
        
        if self.viewControllers?.count == 3 {
            // 只有图片的tabbaritem
            let item = MyCustomTabBarItem.init(image: itemImage, selectedImage: itemSelectedImage)
            viewController.tabBarItem = item
        }else{
            // 当navigationItem.title ！= tabBarItem.title 时，必须如此设置：先设置title，在设置navigationItem.title，设置tabBarItem.title已经无用了
//            viewController.title = title
//            viewController.navigationItem.title = "我的账户"
            
            viewController.title = title
            viewController.tabBarItem.image = itemImage
            viewController.tabBarItem.selectedImage = newItemSelectdImg
        }
        
        
        let nav = MyCustomNav.init(rootViewController: viewController)
        self.addChildViewController(nav)
    }
    
    // MARK: UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = self.viewControllers?.index(of: viewController)
        
        if index != nil {
            if index == 3 {
                self.perform(#selector(btnAction), with: plusBtn, afterDelay: 0)
//                viewController.tabBarItem.selectedImage = nil // 可以在此处设置点击item时的选中图片，因为点击item选中控制器被禁止了
//                self.selectedIndex = 3  // 因为这样会选中并显示控制器
                
                return false
            }else{
                return true
            }
        }else{
            return false
        }
        
    }
    

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if flag {
            plusBtn.center = toPoint
            isCompleteAnimate = true
            self.tabBar.layoutSubviews() // 主动刷新
        }
    }
    
   
}


