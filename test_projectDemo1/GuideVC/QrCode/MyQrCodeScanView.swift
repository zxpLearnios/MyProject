//
//  MyQrCodeScanView.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/6/27.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  二维码扫描View
//  1.  模拟器<8.3版本不可以，2. AVFoundation框架不仅支持二维码扫描。还支持非常多别的条码类别。比如Code39，Code128，Aztec，和PDF417,  3. 本view暂时控制为 200*200, 为了隐藏那个上下移动的view（当移动到太靠下时）, 4. 判断是否可以获取硬件信息等是为了防止在模拟器上出错, 5. 若需要让动画view上移而后下移，只需改变重力方向无须再清空之， 6. 此view弄得和屏幕一样大

import UIKit
import AVFoundation

@objc protocol MyQrCodeScanViewDelegate {
    optional func finishScanQrCodeWithOutPutString(result:String)
}



class MyQrCodeScanView: UIView, AVCaptureMetadataOutputObjectsDelegate, UIDynamicAnimatorDelegate {

    /** 可见区域、输入 */
    private var preViewLayer:AVCaptureVideoPreviewLayer!
    
    /** 输出、设备、会话 */
    private let output = AVCaptureMetadataOutput(), session = AVCaptureSession(), device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    
    /** 物理仿真行为 */
    private var dy =  UIDynamicAnimator.init(), ga:UIGravityBehavior!, cBh:UICollisionBehavior!, aniImgV:UIImageView!, bgImgV:UIImageView!
    
    
    private lazy var input:AVCaptureDeviceInput? = {
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            return input
        }catch {
            print(error)
            return nil
        }

    }()
    
    /** 代理 */
    var delegate:MyQrCodeScanViewDelegate?
    var isStopScan = false // 是否停止扫描
    
    
    // MARK: 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.doInit()
    }
    
    // MARK: 初始化
    private func doInit(){
        
        if device == nil {
            print("可能是模拟器,故无法获取硬件信息！")
            return
        }
        
        
//        do {
//          
//            
//        } catch let error as NSError {
//            print(error)
//            print("请在“设置”-“隐私”-“相机”功能中，打开本app的相机访问权限")
//            return
//        }
        
        // -1. 获取 权限下
        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        if authStatus == .Restricted || authStatus == .Denied{
            print("请在“设置”-“隐私”-“相机”功能中，打开本app的相机访问权限")
            return
        }
        
        // 0. 设备
        self.clipsToBounds = true // 使超出碰撞边界后的效果看不见
        
        // 1. Input
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        // 2.2 OutPut ，必须先将output加入session中，才可以对output进行其他的设置
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        // 2. output
        if session.canAddOutput(output) {
            session.addOutput(output)
            
            // 2.1  一般这几种条码扫描就够用
            output.metadataObjectTypes = [
                AVMetadataObjectTypeEAN13Code,
                AVMetadataObjectTypeEAN8Code,
                AVMetadataObjectTypeCode128Code,
                AVMetadataObjectTypeQRCode
            ]
        }
        
        
        // 2.3 设置扫描响应区域
        
//        output.rectOfInterest = CGRectMake（y的起点/屏幕的高，x的起点/屏幕的宽，扫描的区域的高/屏幕的高，扫描的区域的宽/屏幕的宽） 
        let outputW:CGFloat = 250 // 增大后，扫描区域变大了自然会使扫描速度更快，
        let outputH = outputW
        let x = (kwidth - outputW)/2
        let y = (kheight - outputH)/2
        let width = kwidth // AVCaptureVideoPreviewLayer的对象的宽度
        let height = kheight // AVCaptureVideoPreviewLayer的对象的高度
        
        output.rectOfInterest = CGRectMake(y/height, x/width, outputW/height, outputH/width)
        // 3. Session
        session.sessionPreset = AVCaptureSessionPresetHigh // 高质量采集率
        
        // 4. Preview == 可见区域
        preViewLayer = AVCaptureVideoPreviewLayer(session: session)
        preViewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        
        preViewLayer.frame = self.bounds
        self.layer.insertSublayer(preViewLayer, atIndex: 0)
        
        // 5. 背景view
        bgImgV = UIImageView.init(image: UIImage(named: "scan_bg_pic"))
        bgImgV.frame = CGRectMake(x, y, outputW, outputH)
        
        self.addSubview(bgImgV)
        
        // 6. 上下移动的view
        aniImgV = UIImageView.init(image: UIImage(named: "scan_line"))
        aniImgV.frame = CGRectMake(bgImgV.x, bgImgV.y, bgImgV.width, 5)
        self.addSubview(aniImgV)
        
        // 7. 仿真行为
        dy.delegate = self
        
        // 8. 加暗色view
        addOtherViews()
    }
    
    private func addOtherViews() {
        for i in 0...1 {
            
            // 上面、下面的view
            let topAndButtom = UIView.init()
            topAndButtom.backgroundColor = UIColor.blackColor()
            topAndButtom.alpha = 0.5
            var y:CGFloat = 0
            if i == 1 {
                y = bgImgV.frame.maxY
            }
            topAndButtom.frame = CGRectMake(0, y, kwidth, (kheight - bgImgV.height)/2)
            self.addSubview(topAndButtom)
            
            
            // 左边、右边的view
            let leftAndRight = UIView.init()
            leftAndRight.backgroundColor = UIColor.blackColor()
            leftAndRight.alpha = 0.5
            let  y1 = bgImgV.y
            var x1:CGFloat = 0
            if i == 1 {
                x1 = bgImgV.frame.maxX
            }
            leftAndRight.frame = CGRectMake(x1, y1, (kwidth - bgImgV.width)/2, bgImgV.height)
            self.addSubview(leftAndRight)
        }
        
        
    }
    
    // MARK: 做 仿真动画
    private func doAnimate(){
        
        if ga == nil {
            ga = UIGravityBehavior.init(items: [aniImgV])
            ga.magnitude = 1
            ga.gravityDirection = CGVectorMake(0, 1)
            
        }
        
        if cBh == nil { // 有碰撞感
            cBh = UICollisionBehavior.init(items: [aniImgV])
            cBh.collisionMode = .Boundaries
            
            let rectLimit =  CGRectMake(0, bgImgV.frame.maxY, kwidth, 1)
            
            let path = UIBezierPath.init(rect: rectLimit)
            cBh.removeAllBoundaries()
            cBh.addBoundaryWithIdentifier("", forPath: path)
        }
        
        if dy.behaviors.count == 0 {
            dy.addBehavior(ga)
            dy.addBehavior(cBh)
        }
        
    }
    
    // MARK: 移除仿真行为
    private func removeAnimate(){
        
        aniImgV.frame = CGRectMake(bgImgV.x, bgImgV.y, bgImgV.width, 5) // 恢复原处
        dy.removeAllBehaviors()
        ga = nil
        cBh = nil
        
    }
    
    // MARK: 共外部调用的开始、结束扫描方法
    func  start() {
        startScanQrCode()
    }
    func stop()  {
        stopScanQrCode()
    }
    
    // MARK: 开始扫描
    private func startScanQrCode(){
        isStopScan = false
        doAnimate() // 上下移动图片
        // 1.开始扫描
        session.startRunning()
    }
    
    // MARK: 结束扫描
    private func stopScanQrCode(){
        isStopScan = true
        // 1. 结束上下移动动画
        removeAnimate()
        session.stopRunning()
        
    }
    
    //  MARK: -----  UIDynamicAnimatorDelegate ---
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        removeAnimate()
        if  !isStopScan {
            
            doAnimate()
        }
        
    }
    
    // MARK: ---- AVCaptureMetadataOutputObjectsDelegate ----
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if metadataObjects != nil && metadataObjects.count > 0 {
          
            stopScanQrCode()
            let result = metadataObjects[0]
            
            
            if self.delegate != nil {
                self.delegate?.finishScanQrCodeWithOutPutString!(result.stringValue)
            }
            // 这里先不移除，实际中肯定会移除的
//            self.preViewLayer.removeFromSuperlayer()
        }
    }

    deinit{
        session.stopRunning()
        removeAnimate()
    }
}


