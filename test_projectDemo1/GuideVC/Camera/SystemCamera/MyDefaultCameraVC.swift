//
//  MyDefaultCameraView.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/3.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  1. device设备初始化 ； 2. input输入设备，由硬件设备决定； 3. output输出设备， 自己写，自己设置相关属性，图片的显示、处理、拍照等
//  4. 两次拍照间隔再短也没有内存警告的问题， 这是完全OK的

import UIKit
import Photos
import AVFoundation
import  AssetsLibrary
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




class MyDefaultCameraVC: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var currentImgV: UIImageView!
    
    @IBOutlet weak var totalCount: MyLabel!
    
    private var images = [UIImage]()
    
    /** 可见区域、输入 */
    private var preViewLayer:AVCaptureVideoPreviewLayer!
    
    /** 输出流、设备、会话 */ // AVCaptureMovieFileOutput
    private let output = AVCaptureStillImageOutput(), session = AVCaptureSession()
    private var device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) // 默认的硬件设备即后置摄像头
    
    /** 默认的就是 后置摄像头 */
    private lazy var input:AVCaptureDeviceInput? = {
        
        do {
              let input = try AVCaptureDeviceInput.init(device: self.device)
            return input
        }catch {
            print(error)
            return nil
        }
        
    }()
    
    /** 前置摄像头 */
    private lazy var input_front:AVCaptureDeviceInput? = {
    
        
        for subdevice in AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]{
            
            if subdevice.position == .front {
                self.session.beginConfiguration()
                
                self.device = subdevice
                self.session.commitConfiguration()
                
            }
        }
        
        do {
            let input = try AVCaptureDeviceInput.init(device: self.device)
            return input
        }catch {
            print(error)
            return nil
        }
        
    }()
    
    /** 后置摄像头 */
    private lazy var input_back:AVCaptureDeviceInput? = {
        
        for subdevice in AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]{
            
            if subdevice.position == .back {
                self.session.beginConfiguration()
                
                self.device = subdevice
                self.session.commitConfiguration()
                
            }
        }
        
        do {
            let input = try AVCaptureDeviceInput.init(device: self.device)
            return input
        }catch {
            print(error)
            return nil
        }
        
    }()
    
    
//    convenience init(){
//        self.init(nibName: "MyDefaultCameraVC", bundle: nil)
//    }
    
    // 此时frame都是正确的
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        doInit()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
    }
    
    // MARK: 初始化
    private func doInit(){
        
        if device == nil {
            print("可能是模拟器,故无法获取硬件信息！")
            return
        }
        
        //这句代码是对夜间拍照时候的自动补光, 如果没有这句代码, 晚上拍照基本上是黑色的, 比苹果系统的相机照片差很多
        if (self.device?.isLowLightBoostEnabled)! {
            self.device?.automaticallyEnablesLowLightBoostWhenAvailable = true
        }
        
        // -1. 获取 权限下
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if authStatus == .restricted || authStatus == .denied{
            print("请在“设置”-“隐私”-“相机”功能中，打开本app的相机访问权限")
            return
        }
        
        
        // 1. Input
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        
        // 2. output
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        output.outputSettings = [AVVideoCodecJPEG: AVVideoCodecKey]
        
        // 2.3 设置扫描响应区域
        
        //        output.rectOfInterest = CGRectMake（y的起点/屏幕的高，x的起点/屏幕的宽，扫描的区域的高/屏幕的高，扫描的区域的宽/屏幕的宽）
//        let outputW:CGFloat = 250 // 增大后，扫描区域变大了自然会使扫描速度更快，
//        let outputH = outputW
//        let x = (kwidth - outputW)/2
//        let y = (kheight - outputH)/2
//        let width = kwidth // AVCaptureVideoPreviewLayer的对象的宽度
//        let height = kheight // AVCaptureVideoPreviewLayer的对象的高度
//        
//        output.rectOfInterest = CGRectMake(y/height, x/width, outputW/height, outputH/width)
        // 3. Session
        session.sessionPreset = AVCaptureSessionPresetHigh // 高质量采集率
        
        // 4. Preview == 可见区域
        preViewLayer = AVCaptureVideoPreviewLayer(session: session)
        preViewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        
        preViewLayer.frame = cameraView.bounds
        cameraView.layer.addSublayer(preViewLayer)
        
        // 1.开始扫描
        session.startRunning()
       
        
        // 2. 
        
        // 3.
        updateCountLabel()
    }
    
  // ------------------------------  action  ------------------------------- //
    
    // MARK: 拍照
    @IBAction func takephotoAction() {
        if !isGetCameraAccess() {
            return
        }
        
        let connection = output.connection(withMediaType: AVMediaTypeVideo)
        connection?.videoOrientation = preViewLayer.connection.videoOrientation
        session.commitConfiguration()
        
        // ----> 拍照就会调用
        output.captureStillImageAsynchronously(from: connection) { (buffer, error) in
            
            // 2.1 获取图片
            if buffer != nil {
                
                
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                let image = UIImage(data: imageData!)
                
                if image != nil{
                    self.currentImgV.image = image
                    self.images.append(image!)
                }
                
                // 2.2 保存图片到相册
                //                if self.isGetPhotoAccess(){
                //
                //                }else{
                //                    debugPrint("无相册权限！")
                //                    return
                //                }
                //
                //                let attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, buffer, kCMAttachmentMode_ShouldPropagate)
                //                let library = ALAssetsLibrary()
                //
                //                    library.writeImageDataToSavedPhotosAlbum(imageData, metadata: attachments as! Dictionary, completionBlock: { (url, error) in
                //
                //                })
                
                // 2.3 上传服务器, 先使图片的方向正确
                //                if image!.imageOrientation == .Down {
                //                    image = self.changeDirectionForImage(image!)
                //                }
                //                if image!.imageOrientation == .Up {
                //                    
                //                }
                
                // 2.3.1 这里写上传服务器的代码就好了 将img传过去即可
                
                
                // 2.4
                self.updateCountLabel()
            }
            
        }

//        session.beginConfiguration()
    }
    
    
    // 转换摄像头
    @IBAction func rotateCameraAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
//        session.beginConfiguration() // 不用要
        if isGetCameraAccess() {
            do {
               
                try device?.lockForConfiguration()
                
                session.removeInput(input)
                if sender.isSelected {
                    input = input_front
//                    session.removeInput(input_back)
                }else{
                    input = input_back
//                    session.removeInput(input_front)
                }
                
                session.addInput(input)
                device?.unlockForConfiguration()
            }catch{
                debugPrint("无法锁定拍摄硬件！")
            }
        }else{
            debugPrint("无相机权限！")
        }
        
//        session.commitConfiguration()
    }
    
    // MARK: 开灯， 不同于torch, 即这是拍照时才开灯的，而前者是直接就开了
    @IBAction func openLightAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if !isGetCameraAccess() {
            return
        }
        
        
        if (device?.hasFlash)! {
            if isGetCameraAccess() {
                do {
                    try device?.lockForConfiguration()
                    if sender.isSelected {
                        device?.flashMode = .on
                    }else{
                        device?.flashMode = .off
                    }
                    
                    device?.unlockForConfiguration()
                }catch{
                    debugPrint("无法锁定拍摄硬件！")
                }
            }else{
                debugPrint("无相机权限！")
            }

        }else{
            // 无闪光灯
        }
        
    }
    
   // MARK: 点击屏幕，聚焦；一定要先设置位置，再设置对焦模式。
    private func doFocusToCurrentPoint(){
        
    }
    
    // ------------------------ pprivate ---------------------- //
    //MARK: ---相机权限
    private func isGetCameraAccess()-> Bool{
        
        let authStaus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if authStaus != AVAuthorizationStatus.denied{
            return true
        }else{
            return false
        }
    }
    
    
    //MARK: ----获取相册权限
    private func isGetPhotoAccess()->Bool{
        
        var result = false
        if  Float(UIDevice.current.systemVersion) < 8.0{
            if( ALAssetsLibrary.authorizationStatus() != ALAuthorizationStatus.denied ){
                result = true
            }
        }else{
            
            if ( PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.denied ){
                result = true
            }
        }
        
        return result
    }
    
    // MARK: 更新图片总数
    private func updateCountLabel(){
        
        if images.count == 0 {
            totalCount.text = ""
        }else{
            totalCount.text = String(images.count)
        }
    }

    // MARK: 改变图片方向
    private func changeDirectionForImage(_ image:UIImage) -> UIImage{
    
        if image.imageOrientation == .up{
            return image
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage!
    }
    
    
    deinit{
        session.stopRunning()
    }
    
}

