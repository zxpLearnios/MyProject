//
//  MyCameraView.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/7/26.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit
import GPUImage
import Photos
import AssetsLibrary

//import AVFoundation
//import CoreMedia
//import CoreVideo
//import OpenGLES
//import QuartzCore


class MyCameraView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var currentImgV: UIImageView!
    
    @IBOutlet weak var totalCount: MyLabel!
    
    let cellId = "MyCaptureCell"
//    private var camera:GPUImageVignetteFilter!
    private var   videoCamera:GPUImageVideoCamera!, customFilter:GPUImageFilter!, filteredVideoView:GPUImageView!
    private var   stillCamera:GPUImageStillCamera!, stillFilter:GPUImageBilateralFilter!, captrueView:GPUImageView!, filterGroup:GPUImageFilterGroup!
    
    private var images = [UIImage](), timer:NSTimer!
    
    lazy var focusView:UIView = {
        let fv = UIView()
        fv.backgroundColor = UIColor.clearColor()
        fv.layer.borderWidth = 1
        fv.frame = CGRectMake(0, 0, 120, 120)
        fv.layer.borderColor = UIColor.orangeColor().CGColor
        
        return fv
    }()

    
    class func getSelf(withFrame frame:CGRect) -> MyCameraView{
        let  view = NSBundle.mainBundle().loadNibNamed("MyCameraView", owner: nil, options: nil).last as! MyCameraView
        view.frame = frame
        view.collectionView.delegate = view
        view.collectionView.dataSource = view
        return view
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.doInitCaptrue()
        }
        
        self.updateCountLabel()
        self.doInit() // 不要延迟执行，否则后面会找不到cell，crash掉
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.doInitCaptrue()
//        updateCountLabel()
//        doInit()
    }
    
    private func doInit(){
        
        collectionView.registerNib(UINib.init(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
    }
//    private func doInitVedio ()  {
//        
//        videoCamera = GPUImageVideoCamera.init(sessionPreset: AVCaptureSessionPresetPhoto, cameraPosition: .Back)
//        
//        videoCamera.outputImageOrientation = .Portrait // 拍的照片的方向
//        
//        // 滤镜
//        customFilter = GPUImageSharpenFilter.init()
////            GPUImageFilter.init(fragmentShaderFromFile: "CustomShader")
//      
//        
//        // 可见区域
//        filteredVideoView = GPUImageView.init(frame: CGRectMake(0.0, 0.0, self.width, self.height))
//       
//        
//        videoCamera.addTarget(customFilter)
//        videoCamera.addTarget(filteredVideoView)
//        
//        
//        videoCamera.startCameraCapture()
//         self.addSubview(filteredVideoView)
//    }
    
    
    
    private func doInitCaptrue(){
            
        stillCamera = GPUImageStillCamera.init(sessionPreset: AVCaptureSessionPresetPhoto, cameraPosition: .Back)
        
        stillCamera.outputImageOrientation = .Portrait
        
        stillFilter = GPUImageBilateralFilter.init()
        filterGroup = GPUImageFilterGroup.init()
        
        // 1.1
//        stillCamera.addTarget(stillFilter)
        
        // 1.2
//        stillCamera.addTarget(filterGroup)
//        filterGroup.addTarget(stillFilter)
        
        let  frame = CGRectMake(self.cameraView.x, self.cameraView.y, self.cameraView.width, self.cameraView.height)
        captrueView = GPUImageView.init(frame: frame)
        captrueView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill
        self.addSubview(captrueView)
        // 2.1
        stillCamera.addTarget(captrueView) // 直接加即可， 而不是先加filter，再让filter加captrueView
        
        // 2.2
//        stillFilter.addTarget(captrueView)
//        filterGroup.addTarget(captrueView) // 不能设置
        
        if !isGetCameraAccess() {
            debugPrint("无相机权限！")
        }else{
            stillCamera.startCameraCapture()
        }
        
       
        // 2.  加点击view
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        captrueView.addGestureRecognizer(tap)
    }
    
    
    // MARK: 拍照
    @IBAction func takephotoAction() {
        if !isGetCameraAccess() {
            return
        }
        takePhoto()
    }
    
    // MARK:  转换摄像头
    @IBAction func rotateCameraAction(sender: UIButton) {
        sender.selected = !sender.selected
        
        if isGetCameraAccess() {
           stillCamera.rotateCamera()
        }else{
            debugPrint("无相机权限！")
        }

        
    }
    
    // MARK: 开灯 不同于flashModel, 即这是直接就开了，而前者是拍照时才开灯的
    @IBAction func openLightAction(sender: UIButton) {
        
        if !isGetCameraAccess() {
            print("没有相机权限，请到设置->隐私中开启本程序相机权限")
        }else{
            sender.selected = !sender.selected
            let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            if device == nil {
                print("可能是模拟器,故无法获取硬件信息！")
                return
            }
            
            if device.hasTorch {
                try!  device.lockForConfiguration()
                
                if (sender.selected) {
                    device.torchMode = .On
                }else {
                    device.torchMode = .Off
                }
                device.unlockForConfiguration()
            }
            
        }
    }
    
    // MARK: 去相册
    @IBAction func albumAction(sender: UIButton) {
//        if !isGetPhotoAccess() {
//            print("没有相册权限，请到设置->隐私中开启本程序相册权限")
//        }else{ // 进入相册
//            
//            let picker = MyImagePickerController.getSelf(nil)
//            
//            
//            let vc = MyAlbumViewController()
//            let nav = MyCustomNav.init(rootViewController: vc)
//            nav.pushViewController(picker, animated: false)
//            
//            kAppDelegate.window?.rootViewController!.presentViewController(nav, animated: true, completion: nil)
//        }
        
    }

    
    // MARK: 拍照 processedImage: 加工过的图片
    private func takePhoto() {
        
        let currentFilter = stillCamera.targets().last as! GPUImageOutput
        stillCamera.capturePhotoAsImageProcessedUpToFilter(currentFilter) { (processedImage, error) in
            if error != nil {
                print("takePhotoError:\(error)")
            } else {
                if processedImage != nil {
                    self.currentImgV.image = processedImage
                    self.images.append(processedImage)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        // 保存图片
                        UIImageWriteToSavedPhotosAlbum(processedImage, self, #selector(self.saveImageToAlbum(_:didFinishSavingWithError:contextInfo:)), nil)
                    })
                    
                }
            }
            self.updateCountLabel()
        }
        
    }

    // MARK: 点击事件
   @objc private func tapAction(tap: UITapGestureRecognizer) {
        
        switch tap.state {
            
        case .Recognized:
            let point = tap.locationInView(cameraView)
            doFocusToCurrentPoint(point)
            break
        case .Ended, .Failed, .Cancelled:
            debugPrint("点击手势结束！")
            break
        default:
        break
        
        }
    }
    
    // MARK: 点击屏幕，聚焦；一定要先设置位置，再设置对焦模式。
    private func doFocusToCurrentPoint(point:CGPoint){
        let  size = cameraView.bounds.size
        let  focusPoint = CGPointMake(point.y / size.height, 1-point.x / size.width )
        
        do{
            let device = stillCamera.inputCamera
            
            try device.lockForConfiguration()
            
            // 对焦模式和对焦点
            if device.isFocusModeSupported(.AutoFocus){
//                device.setFocusModeLockedWithLensPosition(<#T##lensPosition: Float##Float#>, completionHandler: <#T##((CMTime) -> Void)!##((CMTime) -> Void)!##(CMTime) -> Void#>)
                device.focusPointOfInterest = focusPoint
                device.focusMode = .AutoFocus
        
            }
            
            // 曝光模式和曝光点
            if device.isExposureModeSupported(.AutoExpose) {
                device.exposurePointOfInterest = focusPoint
                device.exposureMode = .AutoExpose
            }

            device.unlockForConfiguration()
            
        }catch{
        
        }
        
        // focusView动画
        doAnimateForFoucus(atPoint: point)
    }
    

    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
  
        updateFilterGroup(atIndex: indexPath.row)
    
    }
    
    // ------------------------  private ------------------------ //

    //MARK: ---相机权限
    private func isGetCameraAccess()-> Bool{

        let authStaus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)

        if authStaus != AVAuthorizationStatus.Denied{
            return true
        }else{
            return false
        }
    }
    
    
    //MARK: ----获取相册权限
    private func isGetPhotoAccess()->Bool{
        
        var result = false
        if  Float(UIDevice.currentDevice().systemVersion) < 8.0{
            if( ALAssetsLibrary.authorizationStatus() != ALAuthorizationStatus.Denied ){
                result = true
            }
        }else{
            
            if ( PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.Denied ){
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
    
    // MARK: 更新fliter
    private func updateFilterGroup(atIndex index:Int){
        
        
        stillCamera.removeAllTargets()
//        filterGroup.removeAllTargets()
        
        switch index {
        case 0:
            let  filter = GPUImageGaussianBlurFilter() // 高斯模糊, 此时和无效果差不多
            filter.switchToVertexShader(kGPUImageVertexShaderString, fragmentShader: kGPUImagePassthroughFragmentShaderString)
            stillCamera.addTarget(filter)
            filter.addTarget(captrueView)
//            filterGroup.addTarget(filter)
            
        case 1:
            let  filter = GPUImageHueFilter() //色度
            stillCamera.addTarget(filter)
            filter.addTarget(captrueView)
            
        case 2:
            let  filter = GPUImageBilateralFilter() //双边模糊,
            stillCamera.addTarget(filter)
            filter.addTarget(captrueView)
            
        case 3:
            let  filter =  GPUImageGaussianSelectiveBlurFilter()  //高斯模糊，选择部分清晰
            filter.excludeCirclePoint = captrueView.center
            filter.excludeCircleRadius = 100
            stillCamera.addTarget(filter)
            filter.addTarget(captrueView)
        case 4:
            let  filter =  GPUImageMosaicFilter()  //黑白马赛克
            
            
            stillCamera.addTarget(filter)
            filter.addTarget(captrueView)
        
        case 5:
            let  filter =  GPUImageMosaicFilter()  //素描
            
            
            stillCamera.addTarget(filter)
            filter.addTarget(captrueView)
        default:
            let filter = GPUImageColorInvertFilter() //反色
            stillCamera.addTarget(filter)
            filter.addTarget(captrueView)
        }

        
//        stillCamera.addTarget(filterGroup)
        
        
//        filterGroup.initialFilters = [filterGroup]
//        filterGroup.terminalFilter = filterGroup.targets().last as! GPUImageOutput
    }
    
    // MARK: 保存图片到相册的结果
    @objc private func saveImageToAlbum(image:UIImage, didFinishSavingWithError error:NSError?, contextInfo:UnsafeMutablePointer<Void>){
        if error != nil {
            hud.showPromptText("保存图片失败！")
        }else{
            hud.showPromptText("保存图片成功！")
        }
    }
    
    // MARK: 点击屏幕聚焦时的动画
    private func doAnimateForFoucus(atPoint point:CGPoint){
        stopTimer()
        focusView.removeFromSuperview()
        
        startTimer()
        self.focusView.transform = CGAffineTransformIdentity
        
        captrueView.addSubview(focusView)
        focusView.center = point
        focusView.alpha = 0
        
        UIView.animateWithDuration(1, animations: {
            self.focusView.alpha = 1
            self.focusView.transform = CGAffineTransformMakeScale(0.75, 0.75)
            })
    }
    
    // MARK: 定时器的
    @objc private func timeActionForFocus(){
        self.focusView.removeFromSuperview()
        self.focusView.transform = CGAffineTransformIdentity
    }
    
    private func stopTimer(){
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
       
    }
    private func startTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(timeActionForFocus), userInfo: nil, repeats: false)
    }
    
    deinit{
        // 全部置空
    }
    
}
