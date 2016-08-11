//
//  GuideVC.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/5/31.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit
import Kingfisher
import QKLockView

class GuideVC: UIViewController,UIScrollViewDelegate {
    
    private let im  = UIImageView(), scroller = UIScrollView(), timeBtn = UIButton(), downloadBtn = UIButton(), bgimageV = UIImageView(), useNowBtn = UIButton(), takePhotoBtn = UIButton(), scanBtn = UIButton()
    
    private var dy =  UIDynamicAnimator.init(), ga:UIGravityBehavior!, cBh:UICollisionBehavior!
    
    var musicPlayer:MyMusicPlayer! // 音频
    var vedioPlayer:MyVideoPlayerView! // 视频
    var qrCodeView:MyQrCodeCreatView! // 二维码生成view
    var qrCodeScanView:MyQrCodeScanView! // 二维码扫描
    
      var  cameraView:MyDefaultCameraVC! // 拍照  MyCameraView MyDefaultCameraVC
    
    var request:MyBaseNetWorkRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let date0 = NSDate()
        let date1 = date0.dateByAddingTimeInterval(10)
        let date2 = date0.dateByAddingTimeInterval(20)
        
        var numbers = [date2, date0, date1] // "a", "be", "ba", "e", "a1"; 1, 3, 2; date2, date0, date1
        numbers.sort { (date0, date1) -> Bool in
            
            return date0.isEarlierThanDate(ompareToDate: date1)
        }
        
        //        numbers.sortInPlace({$0 < $1})
        
        // 0. 按value的升序排序后 得到新的key数组
        let dic = ["c":"c1", "a":"a1", "d":"d1"]
        
        let keys = Array(dic.keys)
        
        var sortedKeys = keys.sort() {
            let value0 = dic[$0]
            let value1 = dic[$1]
            return value0 < value1
        }
        
        // 0.1 测试Array的扩展
        var ary:[CGFloat] = [23, 30,35, 10, 30, -48, 38, 1.7]
//        ary.binarySort(&ary, isAscending: false)
        ary.quickSort(&ary, left: 0, right: 7, isAscending: true)
        
        // 1. 背景图
        bgimageV.frame = self.view.bounds
//        bgimageV.y = 100
//        bgimageV.width = 10
        bgimageV.image = UIImage(named: "guide_bg0")
        self.view.addSubview(bgimageV)
        
        
        // 3.
//        self.addScrollerView()
        self.addTimeButton()
        self.addDownloadBtn()
        
        self.playRemoteMusic()
        self.addScanButton()
        
        // 4. 模拟请求
//        request = MyBaseNetWorkRequest()
//        let params = ["xx":"11"]
//        request.getRequestWithPath("ccc", params: params) { (result, code) in
//            
//        }
        
        // 5. 拍照
        addTakePhotoBtn()
        
        // 6. SDwebImage
        let str = "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg"
        let url = NSURL.init(string: str)
//        bgimageV.kf_setImageWithURL(url)
        
        // 9.   gif
        let gifView = MyGifView.shareInstance
        let fm = CGRectMake(100, 100, 100, 100)
        gifView.frame = fm
        gifView.showGifWithNoSuffixName(gifName: "test")
//        self.view.addSubview(gifView)
        let gv = MyGifView.shareInstance
        
        let gifWebView = MyGifWebView.init(frame:CGRectMake(10, 100, 200, 200))
        
        gifWebView.loadGif(withGifName: "test")
        
//        let gifPath = NSBundle.mainBundle().URLForResource("test.gif", withExtension: nil)
//        
//        let gifData = NSData.init(contentsOfURL: gifPath!)
//        gifWebView.scalesPageToFit = true
//        gifWebView.loadData(gifData!, MIMEType: "image/gif", textEncodingName: "uft-8", baseURL: gifPath!)
        self.view.addSubview(gifWebView)
        
        // 10. 测试QKLockView
//        let lv = QKLockView()
        
        
    }
    
    private func addScanButton(){
        scanBtn.frame = CGRectMake(30, 70, 80, 40)
        scanBtn.setTitle("二维码", forState: .Normal)
        scanBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        scanBtn.addTarget(self, action: #selector(scanAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(scanBtn)
        
    }
    private func addTimeButton(){
        timeBtn.frame = CGRectMake(kwidth - 40, 70, 40, 40)
        timeBtn.setTitle("时间", forState: .Normal)
        timeBtn.addTarget(self, action: #selector(timeBtnACtion), forControlEvents: .TouchUpInside)
        self.view.addSubview(timeBtn)
    }
    
    private func addDownloadBtn(){
        downloadBtn.frame = CGRectMake(kwidth/2 - 30, 90, 80, 40)
        downloadBtn.setTitle("下载资源", forState: .Normal)
        downloadBtn.addTarget(self, action: #selector(downloadBtnAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(downloadBtn)
    }
    
     // 拍照
    private func addTakePhotoBtn(){
        takePhotoBtn.frame = CGRectMake(kwidth/2 - 30, 130, 80, 40)
        takePhotoBtn.setTitle("拍摄", forState: .Normal)
        takePhotoBtn.addTarget(self, action: #selector(takePhotoAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(takePhotoBtn)
    }
    
    // 马上 使用按钮
    private func addUseNowButton(){
        
        if useNowBtn.frame == CGRectZero {
            useNowBtn.frame = CGRectMake(kwidth/2 - 50, kheight, 100, 40)
            useNowBtn.setTitle("马上进入", forState: .Normal)
            useNowBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            useNowBtn.backgroundColor = UIColor.orangeColor()
            useNowBtn.addTarget(self, action: #selector(useNowAction), forControlEvents: .TouchUpInside)
            self.view.addSubview(useNowBtn)
        }
        
        
        if ga == nil {
            ga = UIGravityBehavior.init(items: [useNowBtn])
            ga.gravityDirection = CGVectorMake(0, -1)
            ga.magnitude = 3
        }
        
        if cBh == nil {
            cBh = UICollisionBehavior.init(items: [useNowBtn])
            cBh.collisionMode = .Boundaries
            let path = UIBezierPath.init(rect: CGRectMake(0, kheight * 0.7, kwidth, 1))
            cBh.addBoundaryWithIdentifier("", forPath: path)
            
        }
        
        if dy.behaviors.count == 0 {
            dy.addBehavior(ga)
            dy.addBehavior(cBh)
        }
        
    }
    

    
    // --------------------------  btnAction -------------------------- //
    
    func  scanAction(btn:UIButton) {
        self.presentViewController(MyQrCodeScanVC.init(), animated: true, completion: nil)
    }
    
    func takePhotoAction(){
        
        // 8. 拍照
        let frame = CGRectMake(0, 64, kwidth, kheight - 64)
        //       cameraView =  NSBundle.mainBundle().loadNibNamed("MyCameraView", owner: nil, options: nil).last as! MyCameraView
        
        cameraView = MyDefaultCameraVC() // MyCameraView.getSelf(withFrame: frame) MyDefaultCameraVC()
//        self.view.addSubview(cameraView)
        self.presentViewController(cameraView, animated: true, completion: nil)
    }

    // MARK: 点击时间按钮
    func timeBtnACtion(btn:UIButton)  {
        print("时间按钮")
        btn.selected = !btn.selected
        //        if btn.selected {
        //             musicPlayer.play()
        //        }else{
        //            musicPlayer.pause()
        //        }
        
        
    }
    
    // MARK: 下载按钮的事件
    func downloadBtnAction(btu: UIButton){
        
        // 7. 测试NetWorkTool
        //        request = MyBaseNetWorkRequest() // http://www.hangge.com/upload.php
        //        var path = ""
        
        //        let fileUrl = NSBundle.mainBundle().URLForResource("upload", withExtension: "png")
        //        path = "http://www.hangge.com/upload.php"
        // 上传单个文件
        //        request.uploadOneFile(withFileUrl: fileUrl!, andUploadPath: path, scriptName: "icon_png")
        
        // 上传多个文件
        //        let test = "test".dataUsingEncoding(NSUTF8StringEncoding)
        //        let num = String(101).dataUsingEncoding(NSUTF8StringEncoding)
        //
        //        let files = [test!, num!, fileUrl!]
        //        let names = ["name0", "name1", "name2"]
        //        request.uploadMoreFileByMutiData(fileURLs: files, scriptNames: names, andUploadPath: path)
        
        // 下载
        //        path =  "http://www.hangge.com/blog/images/logo.png"
        //        path = "https://c2.staticflickr.com/4/3345/5832660048_55f8b0935b.jpg" // 图片
        //        path = "http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4" // 视频
        //        path = "http://dldir1.qq.com/qqfile/qq/QQ7.9/16621/QQ7.9.exe" // 文件
        //        request.downloadWithResourcePath(path)
        //        request.downloadWithDefaultDownloadDestination(path)
        //        request.downloadResource(path)
        //        request.downloadResourceByResumeData(resourcePath: path) // 断点续传 --> 下载
        
        //        request.downloadResource(withPath: path, savePath: "Files", saveName: "firstFile")
        
        // 压缩图片
        //        let originImg = UIImage(named: "guide_bg2")!
        //        let newImg = request.compressImage(originImg, scale: 0.5)
        
    }

    func useNowAction()  {
        print("立刻使用")
        self.view.transitionWithType(AnimationType.Reveal.rawValue, withSubType: kCATransitionFromRight, forView: self.view)
        kwindow?.rootViewController = MyCustomTVC()
    }
    
    
    // MARK:  添加scroller
    private func addScrollerView(){
        scroller.frame = self.view.frame
        scroller.contentSize = CGSizeMake(kwidth * 3, kheight)
        scroller.backgroundColor = UIColor.clearColor()
        scroller.showsHorizontalScrollIndicator = false
        scroller.pagingEnabled = true
        scroller.bounces = false
        scroller.delegate = self
        self.view.addSubview(scroller)
        
        for i in 0...2 {
            let x = kwidth * CGFloat(i)
            let lab = UILabel.init(frame: CGRectMake(x, kheight/2, kwidth, 20))
            lab.text = "改善生态的改善生态的改善生态的+\(i)"
            lab.textAlignment = .Center
            
            scroller.addSubview(lab)
            
        }
        
        // 2. 视频
//         vedioPlayer = NSBundle.mainBundle().loadNibNamed("MyVideoPlayerView", owner: nil, options: nil).last as! MyVideoPlayerView
//        vedioPlayer.center = kcenter
//        scroller.addSubview(vedioPlayer)
        

        
        // 3. 二维码
        
//        let x = (kwidth - 200)/2
//        qrCodeView = MyQrCodeCreatView.init(frame: CGRectMake(x , 100, 200, 200))
//        self.view.addSubview(qrCodeView)
        
//        // 4. 无用，
//        
//        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
//        dispatch_after(time, dispatch_get_main_queue()) {
//            
//            self.qrCodeScanView = MyQrCodeScanView.init(frame: self.view.bounds)
//            self.view.addSubview(self.qrCodeScanView)
//        }
        
        // 5.  测试  
//        var person:Person?
//        var part:Part?
//        
//        part = Part.init()
//        person = Person.init() // Person.init(part: part!)
//        person?.part = part
//        part?.person = person
//        person = nil
//        part = nil
        
        
        // 5.1
//        let now = NSDate()
//        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(4 * Double(NSEC_PER_SEC)))
//        dispatch_after(time, dispatch_get_main_queue()) {
////            let date = NSDate.compareFromdate(now)
//            let date = NSDate.compareFromdate(now, toDate: NSDate())
//            print(date)
//        }
//        
//        
//        let newD =  NSDate.formatDateString("2015-10-09 10:10:10", byFormatter: "yyyy-MM-dd HH:mm:ss")
//        print("时间是-- \(newD)")
        
        // 6. 测试 HUD, 第二种方式
//        hud.showProgressImage(UIImage(named: "pauseBtn")!)
//        //        hud.showSuccessText("成功彩色法尔", successImage: UIImage(named: "progress_circular")!)
//        
//        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
//        dispatch_after(time, dispatch_get_main_queue()) {
//            
//            hud.dismiss(false)
//            
//            let time1 = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
//            dispatch_after(time1, dispatch_get_main_queue()) {
//                hud.showPromptText("发的规划的规划的规划的规划的规划的规划的规划的规划的规划")
//            }
//            
//            
//        }
        
        
      
        
    }
    
    
    // get 请求的结果
    private func getRequestResult(result:AnyObject, code:String){
        
    }
    
    
    /**
     播放远程音频
     */
    private func playRemoteMusic(){
        musicPlayer = MyMusicPlayer.init()
    }
    
    // 动画须在此做
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        self.view.backgroundColor = UIColor.redColor()
//        
//        self.view.transitionWithType(AnimationType.PageCurl.rawValue, withSubType: kCATransitionFromRight, forView: self.view)
        
        
        //  测试 HUD, 第一种方式
//        hud.showProgressImage(UIImage(named: "pauseBtn")!)
////        hud.showSuccessText("成功彩色法尔", successImage: UIImage(named: "progress_circular")!)
//        
//        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
//        dispatch_after(time, dispatch_get_main_queue()) {
//            
//            hud.dismiss(true)
//            
//            let time1 = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
//            dispatch_after(time1, dispatch_get_main_queue()) {
//               hud.showPromptText("发的规划的规划的规划的规划的规划的规划的规划的规划的规划")
//            }
//            
//            
//        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let offsetX = scroller.contentOffset.x
        
        // 1. 改变背景图
//        let imageName = "guide_bg\(offsetX/kwidth)"
        
//        bgimageV.image = UIImage(named: imageName)
        
        
        // 2. 视频
        
        
        if offsetX/kwidth == 2 {
            addUseNowButton()
        }else if offsetX == 0 || offsetX == kwidth{
            removeUseNowButton()
        }
    }
    
    
    private func removeUseNowButton(){
        useNowBtn.frame = CGRectZero
        useNowBtn.removeFromSuperview()
        dy.removeAllBehaviors()
        ga = nil
        cBh = nil
    }
    
    
}
