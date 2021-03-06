//
//  GuideVC.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/5/31.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit
import Kingfisher



//import QKLockView
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
private func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



class GuideVC: UIViewController,UIScrollViewDelegate, UIAlertViewDelegate {
    
    private let im  = UIImageView(), scroller = UIScrollView(), timeBtn = UIButton(), downloadBtn = UIButton(), bgimageV = UIImageView(), useNowBtn = UIButton(), takePhotoBtn = UIButton(), scanBtn = UIButton()
    
    private var dy =  UIDynamicAnimator.init(), ga:UIGravityBehavior!, cBh:UICollisionBehavior!
    
    var musicPlayer:MyMusicPlayer! // 音频
    var vedioPlayer:MyVideoPlayerView! // 视频
    var qrCodeView:MyQrCodeCreatView! // 二维码生成view
    var qrCodeScanView:MyQrCodeScanView! // 二维码扫描
    // 拍照
      var  cameraView:MySystemAlbumVC!  // MyCameraView MyDefaultCameraVC  MySystemAlbumVC
    
    var request:MyBaseNetWorkRequest!
    var bannerView: QLBannerView! // MyBannerView!
    
    let kn = Khowledge()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
       
        
        // -1. 日期排序，swift自带功能
//        let date0 = Date()
//        let date1 = date0.addingTimeInterval(10)
//        let date2 = date0.addingTimeInterval(20)
//        
//        var numbers = [date2, date0, date1] // "a", "be", "ba", "e", "a1"; 1, 3, 2; date2, date0, date1
//        numbers.sorted { (date0, date1) -> Bool in
//            
//            return date0.isEarlierThanDate(compareToDate: date1)
//        }
        
        //        numbers.sortInPlace({$0 < $1})
        
        // 0. 按value的升序排序后 得到新的key数组
//        let dic = ["c":"c1", "a":"a1", "d":"d1"]
//        
//        let keys = Array(dic.keys)
//        
//        var sortedKeys = keys.sorted() {
//            let value0 = dic[$0]
//            let value1 = dic[$1]
//            return value0 < value1
//        }
        
        
        // 0.1 测试Array的扩展
//        var ary:[CGFloat] = [23, 30,35, 10, 30, -48, 38, 1.7]
////        ary.binarySort(&ary, isAscending: false)
//        ary.quickSort(&ary, left: 0, right: 7, isAscending: true)
        
        // 1. 背景图
//        bgimageV.frame = self.view.bounds
//        bgimageV.y = 100
//        bgimageV.width = 10
//        bgimageV.image = UIImage(named: "guide_bg0")
//        self.view.addSubview(bgimageV)
        
        
        // 3.
        self.addScrollerView()
        
//        self.addTimeButton()
//        self.addDownloadBtn()
//        
//        self.playRemoteMusic()
//        self.addScanButton()
        
        // 4. 模拟请求
//        request = MyBaseNetWorkRequest()
//        let params = ["xx":"11"]
//        request.getRequestWithPath("ccc", params: params) { (result, code) in
//            
//        }
        
        // 5. 拍照
//        addTakePhotoBtn()
        
        // 6. SDwebImage
        let str = "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg"
        let url = URL.init(string: str)
//        bgimageV.kf_setImageWithURL(url)
        
        // 9.   gif
//        let gifView = MyGifView.shareInstance
//        let fm = CGRect(x: 100, y: 100, width: 100, height: 100)
//        gifView.frame = fm
//        gifView.showGifWithNoSuffixName(gifName: "test")
//        self.view.addSubview(gifView)
        
//        let gifWebView = MyGifWebView.init(frame:CGRect(x: 10, y: 100, width: 200, height: 200))
//        gifWebView.loadGif(withGifName: "test")
//        view.addSubview(gifWebView)
        
//        let gifPath = NSBundle.mainBundle().URLForResource("test.gif", withExtension: nil)
//        
//        let gifData = NSData.init(contentsOfURL: gifPath!)
//        gifWebView.scalesPageToFit = true
//        gifWebView.loadData(gifData!, MIMEType: "image/gif", textEncodingName: "uft-8", baseURL: gifPath!)
//        self.view.addSubview(gifWebView)
        
        // 10. 测试QKLockView
        
//        let lv = QKLockView
//        lv.frame = CGRect(x: 10, y: 100, width: 300, height: 310)
//        lv.backgroundColor = UIColor.red
//        self.view.addSubview(lv)
        
        // 11. 
        let hStr = String.deleteBlankFromHeadAndTail(primordailStr: "   123   ")
        
        
        // 12.
//         Config.showAlert(withDelegate: self, title: "温馨提示", message: "是否呼叫", cancleTitle: nil, confirmTitle: "呼叫")
        
        // 13.  测试存储
//        let testPath = NSHomeDirectory() + "/user.plist"
//        
//        let testAry = ["ary0", "ary1"]
//        // 13.1
////        let finish = NSKeyedArchiver.archiveRootObject(testAry, toFile: testPath)
////        let getAry = NSKeyedUnarchiver.unarchiveObjectWithFile(testPath)
//        // 13.2
//        let bl =  (testAry as NSArray).writeToFile(testPath, atomically: true)
//        let newAry = NSArray.init(contentsOfFile: testPath)
//        
//        // 13.3   将已归档的数据读取，但之后不能进行其他操作的
//            let getData = kFileManager.contentsAtPath(testPath)
//        
//        do{
//            // 必须是 序列化后的数据才可以被反序列化
//            let jsonobj = try  NSJSONSerialization.JSONObjectWithData(getData!, options: .AllowFragments)
//            debugPrint(jsonobj)
//        }catch let error  {
//            debugPrint(error)
//        }
        
        
        // 14. 约束第三方的使用
//        addConstraintsButton()
//        
//        // 15. Iconfont
//        let iconLab = UILabel.init(frame: CGRect(x: 30, y: 250, width: 300, height: 30))
//        iconLab.font = UIFont.init(name: "lantinghei", size: 20) // iconfont
//        iconLab.text = "就输入该太难usefjkn" // "\u{e603}"
//        self.view.addSubview(iconLab)
        
        // 16.  二维码生成
//        let qrCodeimage = QRCodeImage.createQrCodeImage(with: "3r5", size: 250, qrColor: UIColor.yellow, bgColor: UIColor.brown, icon: UIImage.init(named: "guide_bg0"), iconWidth: 50) //QRCodeImage.createQrCodeImage(with: "wet", size: 300, qrColor: UIColor.orange, icon: UIImage.init(named: "guide_bg0"), iconWidth: 50, isHaveWhiteBg: true) //QRCodeImage.createQrCodeImage(with: "fwef", size: 250, qrColor: UIColor.blue, bgColor: UIColor.red) //QRCodeImage.createQrCodeImage(with: "ferg", size: 200, color: UIColor.orange, isHaveWhiteBg: false)    //QRCodeImage.creatCodeImage(with: "fer", size: 200, qrColor: UIColor.red, icon: UIImage.init(named: "guide_bg0"), iconWidth: 50) // QRCodeImage.creatCodeImage(with: "ferg", size: 200, qrColor: UIColor.red) //QRCodeImage.creatCodeImage(with: "ferg", size: 200)
        
//        let imgv = UIImageView.init(image: qrCodeimage)
//        view.addSubview(imgv)
        
        // 16. 测试图片浏览器
//        addTestPhotoBrowser()
        
        // 17. 测试利用CIImage来 不失真的放大图片
//        let ciImg = CIImage.init(image: UIImage(named: "icon")!)
//        if #available(iOS 10.0, *) {
//            let newImg = UIImage.init(cgImage: (ciImg?.cgImage)!)
//            
//            let imgV = UIImageView.init(image: newImg)
//            imgV.bounds = CGRect.init(x: 0, y: 0, width: 300, height: 300)
//            imgV.center = kcenter
//            view.addSubview(imgV)
//        } else {
//        }
        
        // 18. 点击按钮弹出键盘，必须实现初始化一个textField或textView 来作为响应者
//        addPopKeyboardByClickButton()
        
        // 19. 测试bannerView
        bannerView = QLBannerView.init(frame: CGRect.init(x: 0, y: 100, width: kwidth, height: 170)) // MyBannerView
        view.addSubview(bannerView)
        let images = [ #imageLiteral(resourceName: "guide_bg0") , #imageLiteral(resourceName: "guide_bg1"), #imageLiteral(resourceName: "guide_bg2")]
        bannerView.localImages = images
        bannerView.timeInterval = 2
        
        // 20. 测试引用计数
//        let weakStrong = WeakAndStrong()
//        weakStrong.testRetainCount()
        
        // 21. 
//        kn
        
        // 22.  reactiveCocoa rac
//        addTestReactiveCocoa()
        
        
    }
    
    
    
    private func addScanButton(){
        scanBtn.frame = CGRect(x: 30, y: 70, width: 80, height: 40)
        scanBtn.setTitle("二维码", for: UIControlState())
        scanBtn.setTitleColor(UIColor.black, for: UIControlState())
        scanBtn.addTarget(self, action: #selector(scanAction), for: .touchUpInside)
        self.view.addSubview(scanBtn)
        
    }
    
    private func addTimeButton(){
        timeBtn.frame = CGRect(x: kwidth - 40, y: 70, width: 40, height: 40)
        timeBtn.setTitle("时间", for: UIControlState())
        timeBtn.addTarget(self, action: #selector(timeBtnACtion), for: .touchUpInside)
        self.view.addSubview(timeBtn)
    }
    
    private func addDownloadBtn(){
        downloadBtn.frame = CGRect(x: kwidth/2 - 30, y: 90, width: 80, height: 40)
        downloadBtn.setTitle("下载资源", for: UIControlState())
        downloadBtn.addTarget(self, action: #selector(downloadBtnAction), for: .touchUpInside)
        self.view.addSubview(downloadBtn)
    }
    
     // 拍照
    private func addTakePhotoBtn(){
        takePhotoBtn.frame = CGRect(x: kwidth/2 - 30, y: 130, width: 80, height: 40)
        takePhotoBtn.setTitle("拍摄", for: UIControlState())
        takePhotoBtn.addTarget(self, action: #selector(takePhotoAction), for: .touchUpInside)
        self.view.addSubview(takePhotoBtn)
    }
    
    // 马上 使用按钮
    private func addUseNowButton(){
        
        if useNowBtn.frame == CGRect.zero {
            useNowBtn.frame = CGRect(x: kwidth/2 - 50, y: kheight, width: 100, height: 40)
            useNowBtn.setTitle("马上进入", for: .normal)
            useNowBtn.setTitleColor(UIColor.white, for: UIControlState())
            useNowBtn.backgroundColor = UIColor.orange
            useNowBtn.addTarget(self, action: #selector(useNowAction), for: .touchUpInside)
            self.view.addSubview(useNowBtn)
        }
        
        
        if ga == nil {
            ga = UIGravityBehavior.init(items: [useNowBtn])
            ga.gravityDirection = CGVector(dx: 0, dy: -1)
            ga.magnitude = 3
        }
        
        if cBh == nil {
            cBh = UICollisionBehavior.init(items: [useNowBtn])
            cBh.collisionMode = .boundaries
            let path = UIBezierPath.init(rect: CGRect(x: 0, y: kheight * 0.7, width: kwidth, height: 1))
            cBh.addBoundary(withIdentifier: "" as NSCopying, for: path)
            
        }
        
        if dy.behaviors.count == 0 {
            dy.addBehavior(ga)
            dy.addBehavior(cBh)
        }
        
    }
    
    
    private func addConstraintsButton(){
        let  constranitsBtn = UIButton()
        constranitsBtn.frame = CGRect(x: 150, y: 270, width: 80, height: 40)
        constranitsBtn.setTitle("约束按钮", for: UIControlState())
        constranitsBtn.setTitleColor(UIColor.black, for: UIControlState())
        constranitsBtn.addTarget(self, action: #selector(constaintsAction), for: .touchUpInside)
        self.view.addSubview(constranitsBtn)
        
    }
    
    // MARK: 测试图片浏览器
    private func addTestPhotoBrowser(){
    
        let  photoBrowserBtn = UIButton()
        photoBrowserBtn.frame = CGRect(x: 50, y: 370, width: 180, height: 40)
        photoBrowserBtn.setTitle("图片浏览器", for: .normal)
        photoBrowserBtn.setTitleColor(UIColor.black, for: .normal)
        photoBrowserBtn.addTarget(self, action: #selector(photoBrowserBtnAction), for: .touchUpInside)
        self.view.addSubview(photoBrowserBtn)
        
    }
    
    // 点击按钮弹出键盘
    private func addPopKeyboardByClickButton(){
        
        let  photoBrowserBtn = UIButton()
        photoBrowserBtn.frame = CGRect(x: 50, y: 470, width: 300, height: 40)
        photoBrowserBtn.setTitle("点击按钮弹出键盘", for: .normal)
        photoBrowserBtn.setTitleColor(UIColor.black, for: .normal)
        photoBrowserBtn.addTarget(self, action: #selector(popKeyboardByClickButtonAction), for: .touchUpInside)
        self.view.addSubview(photoBrowserBtn)
    }
    
    private func addTestReactiveCocoa (){
        let  racBtn = UIButton()
        racBtn.frame = CGRect(x: 50, y: 570, width: 300, height: 40)
        racBtn.setTitle("测试RAC", for: .normal)
        racBtn.setTitleColor(UIColor.black, for: .normal)
        racBtn.addTarget(self, action: #selector(racButtonAction), for: .touchUpInside)
        self.view.addSubview(racBtn)
        
    }
    
    // --------------------------  btnAction -------------------------- //
    
    func  scanAction(_ btn:UIButton) {
        self.present(MyQrCodeScanVC.init(), animated: true, completion: nil)
    }
    
    func takePhotoAction(){
        
        // 8. 拍照
        let frame = CGRect(x: 0, y: 64, width: kwidth, height: kheight - 64)
        //       cameraView =  NSBundle.mainBundle().loadNibNamed("MyCameraView", owner: nil, options: nil).last as! MyCameraView
        
        cameraView = MySystemAlbumVC.init(false)  // MyCameraView.getSelf(withFrame: frame) MyDefaultCameraVC()    MySystemCamareVC()
        
//        self.view.addSubview(cameraView)
        self.present(cameraView, animated: true, completion: nil)
    }

    // MARK: 点击时间按钮
    func timeBtnACtion(_ btn:UIButton)  {
        print("时间按钮")
        btn.isSelected = !btn.isSelected
        //        if btn.selected {
        //             musicPlayer.play()
        //        }else{
        //            musicPlayer.pause()
        //        }
        
        
    }
    
    // MARK: 下载按钮的事件
    func downloadBtnAction(_ btu: UIButton){
        
        // 7. 测试NetWorkTool
                request = MyBaseNetWorkRequest() // http://www.hangge.com/upload.php
                var path = ""
        
                let fileUrl = Bundle.main.url(forResource: "背叛情歌", withExtension: "mp3") // upload
                path = "http://www.hangge.com/upload.php"
        // 上传单个文件
                request.uploadOneFile(withFileUrl: fileUrl!, andUploadPath: path, scriptName: "icon_png")
        
        // 上传多个文件
        //        let test = "test".dataUsingEncoding(NSUTF8StringEncoding)
        //        let num = String(101).dataUsingEncoding(NSUTF8StringEncoding)
        //
        //        let files = [test!, num!, fileUrl!]
        //        let names = ["name0", "name1", "name2"]
//                request.uploadMoreFileByMutiData(fileURLs: files, scriptNames: names, andUploadPath: path)
        
        // 下载
        //        path =  "http://www.hangge.com/blog/images/logo.png"
        //        path = "https://c2.staticflickr.com/4/3345/5832660048_55f8b0935b.jpg" // 图片
//                path = "http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4" // 视频
        //        path = "http://dldir1.qq.com/qqfile/qq/QQ7.9/16621/QQ7.9.exe" // 文件
        //        request.downloadWithResourcePath(path)
        //        request.downloadWithDefaultDownloadDestination(path)
//                request.downloadResource(path)
        //        request.downloadResourceByResumeData(resourcePath: path) // 断点续传 --> 下载
        
        //        request.downloadResource(withPath: path, savePath: "Files", saveName: "firstFile")
        
        // 压缩图片
        //        let originImg = UIImage(named: "guide_bg2")!
        //        let newImg = request.compressImage(originImg, scale: 0.5)
        
        
        let time = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.request.cancleAllRequest()
        }
        
    }

    func useNowAction()  {
        print("立刻使用")
        self.view.transitionWithType(AnimationType.reveal.rawValue, subType: kCATransitionFromRight)
        kwindow?.rootViewController = MyCustomTVC()
    }
    
   
    
    
    // MARK: 约束
    func constaintsAction()  {
        // 测试约束
        let constranitVC = ConstraintVC()
        self.navigationController?.pushViewController(constranitVC, animated: true)
        
    }
    
    // MARK: 图片浏览器
    @objc private func photoBrowserBtnAction (){
        
        //   测试图片浏览器
        var ary = [UIImage]()
        for i in 0...7{
            let str = "0" + String(i)
            let img = UIImage.init(named: str)!
            ary.append(img)
        }
        
//        let fl = UICollectionViewFlowLayout()
//        fl.scrollDirection = .horizontal
//        fl.itemSize = CGSize.init(width: 100, height: 100)
//        fl.minimumLineSpacing = 100
//        fl.minimumInteritemSpacing = 300
        
        
        let browserVC = MyPhotoBrowserController()
        browserVC.images = ary
        browserVC.view.frame = self.view.bounds
        self.view.addSubview(browserVC.view)
        self.addChildViewController(browserVC)
    }
    
    @objc private func popKeyboardByClickButtonAction (){
//        self.view.becomeFirstResponder()
    }
    
    @objc private func racButtonAction(){
        let vc = MyCustomTVC()  // RACViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK:  添加scroller
    private func addScrollerView(){
        scroller.frame = self.view.frame
        scroller.contentSize = CGSize(width: kwidth * 3, height: kheight)
        scroller.backgroundColor = UIColor.clear
        scroller.showsHorizontalScrollIndicator = false
        scroller.isPagingEnabled = true
        scroller.bounces = false
        scroller.delegate = self
        self.view.addSubview(scroller)
        
        for i in 0...2 {
            let x = kwidth * CGFloat(i)
            let lab = UILabel.init(frame: CGRect(x: x, y: kheight/2, width: kwidth, height: 20))
            lab.text = "改善生态的改善生态的改善生态的+\(i)"
            lab.textAlignment = .center
            
            scroller.addSubview(lab)
            
        }
        
        // 2. 视频
//         vedioPlayer = NSBundle.mainBundle().loadNibNamed("MyVideoPlayerView", owner: nil, options: nil).last as! MyVideoPlayerView
//        vedioPlayer.center = kcenter
//        scroller.addSubview(vedioPlayer)
        

        
        // 3. 二维码
//        let x = (kwidth - 200)/2
//        qrCodeView = MyQrCodeCreatView.init(frame: CGRect.init(x: x, y: 180, width: 200, height: 200))
//        qrCodeView.doInit()
//        self.view.addSubview(qrCodeView)
        
        
        
        // 4. 无用， 二维码扫描
//        let now = Date()
//        let time = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//        DispatchQueue.main.asyncAfter(deadline: time) {
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
//        let now = Date()
//        let time = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//        
//        DispatchQueue.main.asyncAfter(deadline: time) {
//            let date = Date.compareFromdate(now, toDate: Date())
//            debugPrint(date)
//        }
//        
//        
//        let newD =  Date.formatDateString("2015-10-09 10:10:10", byFormatter: "yyyy-MM-dd HH:mm:ss")
//        debugPrint("时间是-- \(newD)")
//        
//        let n = 0.4 - 0.3 //  0.10000000000000003
        
        // 6. 测试 MyProgressHUD, 第一种方式
//        hud.showProgressImage(UIImage(named: "pauseBtn")!)
//        hud.showSuccessText("位哈维不可交互问题个可交互问题个可交互问题个未通过", successImage: UIImage(named: "pauseBtn")!)
//
//        let time = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//        
//        DispatchQueue.main.asyncAfter(deadline: time) {
//            hud.dismiss(true)
//            
//            let time1 = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//            
//            DispatchQueue.main.asyncAfter(deadline: time1) {
//                hud.showPromptText("发的规划的规划的规划的规划的规划的规划的规划的规划的规划")
//            }
//        }
    
        
    }
    
    
    // get 请求的结果
    private func getRequestResult(_ result:AnyObject, code:String){
        
    }
    
    
    /**
     播放远程音频
     */
    private func playRemoteMusic(){
        musicPlayer = MyMusicPlayer.init()
    }
    
    
    // 动画须在此做
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.alpha = 0
        
        // 测试view的转场动画
//        self.view.backgroundColor = UIColor.red
//        self.view.transitionWithType(AnimationType.pageCurl.rawValue, subType: kCATransitionFromRight)
        
        
        //  测试 HUD, 第二种方式
//        hud.hudInit()
//        hud.showProgressImage(UIImage(named: "pauseBtn")!)
//        hud.showSuccessText("regtrgedhth回国后", successImage: UIImage(named: "pauseBtn")!)
//        
//        
//        let time = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//
//        DispatchQueue.main.asyncAfter(deadline: time) {
//            hud.dismiss(true)
//
//            let time1 = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//
//            DispatchQueue.main.asyncAfter(deadline: time1) {
//                hud.showPromptText("发的规划的规划的规划的规划的规划的规划的规划的规划的规划")
//            }
//        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
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
        useNowBtn.frame = CGRect.zero
        useNowBtn.removeFromSuperview()
        dy.removeAllBehaviors()
        ga = nil
        cBh = nil
    }
    

    // MARK: UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
         let totla = alertView.numberOfButtons
        if buttonIndex  == totla - 1{ // 确保点击的实在是最后的那个按钮
           
        }
    }
    
    
    
}
