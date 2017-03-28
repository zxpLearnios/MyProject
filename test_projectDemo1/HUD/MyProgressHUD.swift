//
//  MyProgressHUD.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/7/14.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.

//  1. 此弹出框， 可以在任何地方初始化，可以在任何地方使用，包括didFinishLaunching里。但在didFinishLaunching使用第一方式且调用的是showProgressImage方法，则当lanunchImage加载完毕后，虽然进度图片消失了但主窗口仍不能与用户交互，故须在合适的时候主动调用dismiss方法， 调用的是其他展示方法时，没有任何问题，因为它们都会自动消失，但是总共需要2s，之后窗口才可与用户交互。外部无须在主动调用dismiss了；故第一种方式不如第二种好。
//  2. isShow, 控制消失动画完成后才可再次显示，避免不停地显示  
//  3. 并行队列同步操作：和主线程同步执行且不会阻塞主线程  
//  4.  默认的是第一种方式
//  5. swift已经不远onceToken来创建单例了，直接使用全局let量即可
//  6. 只有展示进度图片即showProgressImage时不会自动消失，其余展示情况全都自动消失. 即showProgressImage后，需要用户自行调用dismiss，并看好使用的是第一还是第二种方式. 外部若无使用show....，则不要调用dismiss，不会出错但是会展示缩放过程了，不好。
//  7. 在展示过程中，window皆不可与用户交互，展示结束后，window才可以与用户交互


import UIKit

class MyProgressHUD: NSObject {

    private let view = UIView(), titleLab = UILabel(), imgV = UIImageView(), alertWindow = UIWindow.init(frame: kbounds)
    private let width:CGFloat = 100, fontSize:CGFloat = 15, animateTime = 0.25,  aniKey = "aniKey_rotation_forImageView"

    private var imgWH:CGFloat = 0,   ani:CAKeyframeAnimation!
    
    private var isFirstMethod = false // 是否是第一种方式
    private var  isShow = false // 在 doShowAnimate 和 doDismissAnimate里使用
    private var isImgVHidden = false // 用此量来使展示成功的图片文字、失败时的图片文字也自动消失, 在doDismissAnimate里使用
    
    // 当其指向类对象时，并不会添加类对象的引用计数；
    // 当其指向的类对象不存在时，ARC会自动把weak reference设置为nil；
    // unowned 不会引起对象引用计数的变化, 不会将之置为nil
    weak var superView:UIView!
    
    /** 第一种方式. 外部传入view非window，只在当前view中显示谈出框 */
    // 重写父类方法
    private override init (){
        super.init()
    }
    
    /** -1. 外部的初始化方法，用于第一种方式 */
    convenience init(superView:UIView) {
        self.init()
        self.superView = superView
        
        doInit()
    }
  

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
    
    

     /** 0. 第二种方式. 外部无须传参，此弹出框加在alertWindow上，此弹出框在当前window的所有页面都展示直至弹出框自己消失 */
    private static var obj = MyProgressHUD()
    class var sharedInstance: MyProgressHUD {
        return MyProgressHUD.obj
    }
    
    // 用于第二种方式的，外部必须调用此法，然后才可以使用此弹出框
    func  hudInit() {
        
        // 0.
        isFirstMethod = false
        
        // 此时 此window在kwyWindow上，若要kwyWindow不能交互则必须设置kwyWindow不能交互
        alertWindow.backgroundColor = UIColor.clear
        alertWindow.windowLevel = UIWindowLevelAlert // 最高级别
        alertWindow.addSubview(view)
        alertWindow.makeKeyAndVisible()
        
        
        view.frame = CGRect(x: UIScreen.main.bounds.width/2 - width/2, y: UIScreen.main.bounds.height/2 - width/2, width: width, height: width)
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        
        // 2.
        view.addSubview(imgV)
        imgWH = width * 4 / 5
        imgV.center = CGPoint(x: width/2, y: imgWH/2)
        imgV.bounds = CGRect(x:0, y:0, width:imgWH, height:imgWH)
        imgV.image = UIImage(named: "progress_circular")
        
        
        // 3.
        view.addSubview(titleLab)
        titleLab.textAlignment = .center
        titleLab.textColor = UIColor.red
        titleLab.font = UIFont.systemFont(ofSize: fontSize)
        titleLab.numberOfLines = 0

    }
    
    
    
    
    
    // ------------------------ 外部调用 ------------------------ //
    /**
     1. 只展示提示信息,  此时字体变大了、字居view的中间显示、隐藏了图片。展示完后自动消失
     */
    func showPromptText(_ text:String) {
        
        // 全局并行队列(同步、异步都在主线程中，前者不会死锁)
        
        let que = DispatchQueue.global()
        
        que.sync(execute: { // 同步操作\同步任务
            self.imgV.isHidden = true
            self.titleLab.isHidden = false
            
            // 以使其在缩小动画后自动消失
            isImgVHidden = true
            
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
      2. 只展示图片, 图片居中、隐藏了titleLab，展示完后不会自动消失
     */
    func showProgressImage(_ image:UIImage) {
        
        // 和主线程同步执行且不会阻塞主线程
        let que = DispatchQueue(label: "myque1", attributes: DispatchQueue.Attributes.concurrent) // 并行队列
        
        que.sync(execute: { // 同步操作\同步任务
            self.titleLab.isHidden = true
            self.imgV.isHidden = false
            
            // 以使其在 外部调用dismiss时， 执行缩小动画doDismissAnimate后， 自动消失
            isImgVHidden = true
            
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
      3。成功时的图片和文字 ，展示完后自动消失
     */
    func showSuccessText(_ text:String, successImage image:UIImage) {
      
        // 和主线程同步执行且不会阻塞主线程
        let que = DispatchQueue(label: "myque2", attributes: DispatchQueue.Attributes.concurrent) // 并行队列
        
        que.sync(execute: { // 同步操作\同步任务
            
            self.imgV.isHidden = false
            self.titleLab.isHidden = false
            
            // 以使其在缩小动画后自动消失
            isImgVHidden = true
            
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
            doShowAnimate(false, isKeyWindowEnable: false)
        }
        
    }
    
    /**
       4. 失败时的图片和文字 ，展示完后自动消失
     */
    func showFailedText(_ text:String, failedImage image:UIImage) {
        
        let que = DispatchQueue(label: "myque3", attributes: DispatchQueue.Attributes.concurrent) // 并行队列
        
        que.sync(execute: { // 同步操作\同步任务
            
            self.imgV.isHidden = false
            self.titleLab.isHidden = false
            
            // 以使其在缩小动画后自动消失
            isImgVHidden = true
            
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
            doShowAnimate(false, isKeyWindowEnable: false)
        }
    }
    
    /**
      5. 消失 ;  isForFirstMethod:用于哪种方式的消失. 
     * 只有展示进度图片时，外部需要调此法，其余展示情况内部已经处理让其自动消失了
     */
    func dismiss(_ isForFirstMethod:Bool = true) {
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
        
        UIView.animate(withDuration: animateTime, animations: {
            self.view.transform = CGAffineTransform.identity
            
            }, completion: { (bl) in
                
                if isForImageView { // 只有图片时的情况
                    
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
                    // 2s后消失（提示label、 成功图片加label、失败图片加label）
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
        
        UIView.animate(withDuration: animateTime, animations: {
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
                if self.isImgVHidden {
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
