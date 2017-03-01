//
//  MyProgressHUD.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/7/14.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  1. 此弹出框， 可以在任何地方初始化，但第一种方式只能在viewDidAppaer后才能显示相应的信息，因为涉及到window的加载； 第二种方式，在didFinishLaunching时不要用、在launchVC的viewDidAppear可以用，之后再其余任何地方都可以用。
//  2. isShow, 控制消失动画完成后才可再次显示，避免不停地显示   3. 并行队列同步操作：和主线程同步执行且不会阻塞主线程   4. 只需要在执行的话时，判断是第几种方式即可，默认的是第二种



import UIKit

class MyProgressHUD: NSObject {

    private let view = UIView(), titleLab = UILabel(), imgV = UIImageView(), alertWindow = UIWindow.init(frame: kbounds), aniKey = "aniKey_rotation_forImageView"
    
    private let width:CGFloat = 100, fontSize:CGFloat = 15
    private var imgWH:CGFloat = 0, onceToken:Int = 0, isShow = false, ani:CAKeyframeAnimation!, isFirstMethod = false // 是否是第一种方式
    
    // 当其指向类对象时，并不会添加类对象的引用计数；
    // 当其指向的类对象不存在时，ARC会自动把weak reference设置为nil；
    // unowned 不会引起对象引用计数的变化, 不会将之置为nil
    weak var superView:UIView!
    
    /** 第一种方式. 外部传入view非window，只在当前view中显示谈出框 */
    // 重写父类方法
    private override init (){
        super.init()
    }
    
    // 外部的初始化方法
    convenience init(superView:UIView) {
        self.init()
        self.superView = superView
        
        doInit()
    }
  

   

     /**  第二种方式. 外部无须传参，此弹出框在当前window的所有页面都展示直至弹出框自己消失 */
//    class var sharedInstance: MyProgressHUD {
//        struct Static {
//            static var onceToken: dispatch_once_t = 0
//            static var instance: MyProgressHUD? = nil
//        }
//        dispatch_once(&Static.onceToken) {
//            Static.instance = MyProgressHUD()
//            Static.instance?.hudInit()
//        }
//        return Static.instance!
//    }
//
//    // 用于第二种方式的
//     private func  hudInit() {
//        
//        // 0.
//        isFirstMethod = false
//        
//        // 此时 此window在kwyWindow上，若要kwyWindow不能交互则必须设置kwyWindow不能交互
//        alertWindow.backgroundColor = UIColor.clearColor()
//        alertWindow.windowLevel = UIWindowLevelAlert // 最高级别
//        alertWindow.addSubview(view)
//        alertWindow.makeKeyAndVisible()
//        
//        
//        view.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2 - width/2, UIScreen.mainScreen().bounds.height/2 - width/2, width, width)
//        view.backgroundColor = UIColor.whiteColor()
//        view.layer.cornerRadius = 10
//        
//        // 2.
//        view.addSubview(imgV)
//        imgWH = width * 4 / 5
//        imgV.center = CGPointMake(width/2, imgWH/2)
//        imgV.bounds = CGRectMake(0, 0, imgWH, imgWH)
//        imgV.image = UIImage(named: "progress_circular")
//        
//        
//        // 3.
//        view.addSubview(titleLab)
//        titleLab.textAlignment = .Center
//        titleLab.textColor = UIColor.redColor()
//        titleLab.font = UIFont.systemFontOfSize(fontSize)
//        titleLab.numberOfLines = 0
//
//    }
    
    // 用于第一种方式的。
    private func doInit(){
       
      //   0.
        isFirstMethod = true
        // 1.
        superView.addSubview(view)
        
        // 这段没用
//        let frontToBackWindows = UIApplication.sharedApplication().windows.reverse()
//        
//        for window in frontToBackWindows {
//            if window.windowLevel == UIWindowLevelNormal {
//                window.addSubview(view)
//            }
//        }
        
        view.frame = CGRect(x: UIScreen.main.bounds.width/2 - width/2, y: UIScreen.main.bounds.height/2 - width/2, width: width, height: width)
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        
        // 2.
        view.addSubview(imgV)
        imgWH = width * 4 / 5
        imgV.center = CGPoint(x: width/2, y: 10 + imgWH/2)
        imgV.bounds = CGRect(x: 0, y: 0, width: imgWH, height: imgWH)
        imgV.image = UIImage(named: "progress_circular") // progress_circular 实际上是一个PDF，PDF竟然也可以这样用
        
        
       // 3.
        view.addSubview(titleLab)
        titleLab.textAlignment = .center
        titleLab.textColor = UIColor.red
        titleLab.font = UIFont.systemFont(ofSize: fontSize)
        titleLab.numberOfLines = 0
//        titleLab.text = "最终加载最终加载最终加载"
//        let bestSize = titleLab.sizeThatFits(CGSizeMake(width, width))
//        titleLab.frame = CGRectMake(0, imgV.frame.maxY + 10, width, bestSize.height)
        
//
//        // 4.
//        var  gap:CGFloat = 0
//        // 此时需增加view的高度
//        if titleLab.frame.maxY > width {
//            gap = titleLab.frame.maxY - width
//            
//        }
//       view.height += gap
        
        // 5.
//        doShowAnimate(true, isKeyWindowEnable: false)
    }
    
    
    // ------------------------ 外部调用 ------------------------ //
    /**
     只展示提示信息,  此时字体变大了、字居view的中间显示、隐藏了图片
     */
    func showPromptText(_ text:String) {
        
        // 全局并行队列(同步、异步都在主线程中，前者不会死锁)
        let que = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
        
        que.sync(execute: { // 同步操作\同步任务
            self.imgV.isHidden = true
            self.titleLab.isHidden = false
            
            self.titleLab.font = UIFont.systemFont(ofSize: self.fontSize + 10)
            self.titleLab.text = text
            let bestSize = self.titleLab.sizeThatFits(CGSize(width: kwidth - 20, height: CGFloat(MAXFLOAT)))
            
            self.view.height = bestSize.height + 20
            self.view.width = bestSize.width + 20
            self.titleLab.center = CGPoint(x: self.view.width / 2, y: self.view.height / 2)
            self.titleLab.bounds = CGRect(x: 0, y: 0, width: bestSize.width, height: bestSize.height)
            
//            self.imgV.setNeedsLayout()
//            self.view.setNeedsLayout()
//            self.titleLab.setNeedsLayout()
        })
        
        if !isShow {
            doShowAnimate(false, isKeyWindowEnable: true)
        }
        
    }
    
    /**
     只展示图片, 图片居中、隐藏了titleLab，
     */
    func showProgressImage(_ image:UIImage) {
        
        // 和主线程同步执行且不会阻塞主线程
        let que = DispatchQueue(label: "myque1", attributes: DispatchQueue.Attributes.concurrent) // 并行队列
        
        que.sync(execute: { // 同步操作\同步任务
            self.titleLab.isHidden = true
            self.imgV.isHidden = false
            
            self.imgV.image = image
            
            self.view.width = self.imgWH + 20
            self.view.height = self.imgWH + 20
            
            self.imgV.center = CGPoint(x: self.view.width/2, y: self.view.height/2)
        })
        
        if !isShow {
            doShowAnimate(true, isKeyWindowEnable: false)
        }
        
    }
    
    /**
     成功时的图片和文字,
     */
    func showSuccessText(_ text:String, successImage image:UIImage) {
      
        // 和主线程同步执行且不会阻塞主线程
        let que = DispatchQueue(label: "myque2", attributes: DispatchQueue.Attributes.concurrent) // 并行队列
        
        que.sync(execute: { // 同步操作\同步任务
            
            self.imgV.isHidden = false
            self.titleLab.isHidden = false
            
            self.imgV.image = image
            
            self.titleLab.text = text
            let bestSize = self.titleLab.sizeThatFits(CGSize(width: self.width, height: self.width))
            self.titleLab.frame = CGRect(x: 0, y: self.imgV.frame.maxY + 10, width: self.width, height: bestSize.height)
            
            var  gap:CGFloat = 20 // 确保顶部、底部都有间距 10
            // 此时需增加view的高度
            if self.titleLab.frame.maxY > self.width {
                gap = self.titleLab.frame.maxY - self.width + 10
                
            }
            self.view.height += gap
        })
        
        if !isShow {
            doShowAnimate(true, isKeyWindowEnable: false)
        }
        
    }
    
    /**
     失败时的图片和文字,
     */
    func showFailedText(_ text:String, failedImage image:UIImage) {
        
        let que = DispatchQueue(label: "myque3", attributes: DispatchQueue.Attributes.concurrent) // 并行队列
        
        que.sync(execute: { // 同步操作\同步任务
            
            self.imgV.isHidden = false
            self.titleLab.isHidden = false
            
            self.imgV.image = image
            
            self.titleLab.text = text
            let bestSize = self.titleLab.sizeThatFits(CGSize(width: self.width, height: self.width))
            self.titleLab.frame = CGRect(x: 0, y: self.imgV.frame.maxY + 10, width: self.width, height: bestSize.height)
            
            var  gap:CGFloat = 20 // 确保顶部、底部都有间距 10
            // 此时需增加view的高度
            if self.titleLab.frame.maxY > self.width {
                gap = self.titleLab.frame.maxY - self.width + 10
                
            }
            self.view.height += gap
        })
        
        if !isShow {
            doShowAnimate(true, isKeyWindowEnable: false)
        }
    }
    
    /**
     消失 ;  用于哪种方式的消失
     */
    func dismiss(_ isForFirstMethod:Bool) {
        self.isFirstMethod = isForFirstMethod
        self.doDismissAnimate(isKeyWindowEnable: true)
    }
    
    // ------------------------ private ------------------------ //
    /** 显示动画
     - parameter isForTitleLab: 为图片 还是 文字执行动画
     - parameter enable:        主窗口是否可与用户交互
     */
    private func doShowAnimate(_ isForImageView:Bool, isKeyWindowEnable enable:Bool){
        
        isShow = true
        
        if isFirstMethod {
            // 重新添加view
            superView.addSubview(view)
            // 主窗口不可交互
            kwindow?.isUserInteractionEnabled = enable
        }else{
            // 设置它无用, 也不用设置
//            alertWindow.userInteractionEnabled = enable
            
            // 重新显示 alertWindow
            self.alertWindow.isHidden = false
            // 主窗口不可交互
            beforWindow.isUserInteractionEnabled = enable
        }
        
        view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform.identity
            
            }, completion: { (bl) in
                
                if isForImageView {
                    
                    // 给图片加旋转动画
                    if self.ani == nil {
                        self.ani = CAKeyframeAnimation.init(keyPath: "transform.rotation")
                        self.ani.duration = 1
//                        self.ani.rotationMode = kCAAnimationDiscrete // 此属性貌似无用
//                        self.ani.timingFunctions = [CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)] // 这个有用
//                        self.ani.calculationMode = kCAAnimationDiscrete
                        self.ani.values = [0, M_PI * 2]
                        self.ani.repeatCount = MAXFLOAT
                    }
                    
                    self.imgV.layer.add(self.ani, forKey: self.aniKey)
                    
                }else{
                    // 2s后消失提示label、 成功图片加label、失败图片加label
                    let time = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: time) {
                        self.doDismissAnimate(isKeyWindowEnable: true)
                    }
                }
                
                
        }) 
    }
    
    /** 消失动画
     - parameter isForTitleLab: 为图片 还是 文字执行动画
     - parameter enable:        主窗口是否可与用户交互
     
     */
    private func doDismissAnimate(isKeyWindowEnable enable:Bool){
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            
        }, completion: { (bl) in
            
            // 移除图片的旋转动画
            self.imgV.layer.removeAnimation(forKey: self.aniKey)
    
            if self.isFirstMethod {
                // 主窗口可交互
                kwindow?.isUserInteractionEnabled = enable
                
                // 移除、主窗口恢复
                self.view.removeFromSuperview()
            }else{
                
                beforWindow.isUserInteractionEnabled = enable
                // 上面此时只显示了提醒文字，故需要2s后自动消失；其他情况，都不消失的
                if self.imgV.isHidden {
                    self.alertWindow.isHidden = true
                }
            }
            
            // 消失动画完成后才可再次显示，避免不停地显示
            self.isShow = false
        }) 
    }
    
    deinit{
        
    }
}
