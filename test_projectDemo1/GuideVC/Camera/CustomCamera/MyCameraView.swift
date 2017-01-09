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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


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
    fileprivate var   videoCamera:GPUImageVideoCamera!, customFilter:GPUImageFilter!, filteredVideoView:GPUImageView!
    fileprivate var   stillCamera:GPUImageStillCamera!, stillFilter:GPUImageBilateralFilter!, captrueView:GPUImageView!, filterGroup:GPUImageFilterGroup!
    
    fileprivate var images = [UIImage](), timer:Timer!
    
    lazy var focusView:UIView = {
        let fv = UIView()
        fv.backgroundColor = UIColor.clear
        fv.layer.borderWidth = 1
        fv.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        fv.layer.borderColor = UIColor.orange.cgColor
        
        return fv
    }()

    
    class func getSelf(withFrame frame:CGRect) -> MyCameraView{
        let  view = Bundle.main.loadNibNamed("MyCameraView", owner: nil, options: nil)?.last as! MyCameraView
        view.frame = frame
        view.collectionView.delegate = view
        view.collectionView.dataSource = view
        return view
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let time = DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
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
    
    fileprivate func doInit(){
        
        collectionView.register(UINib.init(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
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
    
    
    
    fileprivate func doInitCaptrue(){
            
        stillCamera = GPUImageStillCamera.init(sessionPreset: AVCaptureSessionPresetPhoto, cameraPosition: .back)
        
        stillCamera.outputImageOrientation = .portrait
        
        stillFilter = GPUImageBilateralFilter.init()
        filterGroup = GPUImageFilterGroup.init()
        
        // 1.1
//        stillCamera.addTarget(stillFilter)
        
        // 1.2
//        stillCamera.addTarget(filterGroup)
//        filterGroup.addTarget(stillFilter)
        
        let  frame = CGRect(x: self.cameraView.x, y: self.cameraView.y, width: self.cameraView.width, height: self.cameraView.height)
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
            stillCamera.startCapture()
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
    @IBAction func rotateCameraAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if isGetCameraAccess() {
           stillCamera.rotateCamera()
        }else{
            debugPrint("无相机权限！")
        }

        
    }
    
    // MARK: 开灯 不同于flashModel, 即这是直接就开了，而前者是拍照时才开灯的
    @IBAction func openLightAction(_ sender: UIButton) {
        
        if !isGetCameraAccess() {
            print("没有相机权限，请到设置->隐私中开启本程序相机权限")
        }else{
            sender.isSelected = !sender.isSelected
            let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            if device == nil {
                print("可能是模拟器,故无法获取硬件信息！")
                return
            }
            
            if (device?.hasTorch)! {
                try!  device?.lockForConfiguration()
                
                if (sender.isSelected) {
                    device?.torchMode = .on
                }else {
                    device?.torchMode = .off
                }
                device?.unlockForConfiguration()
            }
            
        }
    }
    
    // MARK: 去相册
    @IBAction func albumAction(_ sender: UIButton) {
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
    fileprivate func takePhoto() {
        
        let currentFilter = stillCamera.targets().last as! GPUImageOutput
        stillCamera.capturePhotoAsImageProcessedUp(toFilter: currentFilter) { (processedImage, error) in
            if error != nil {
                print("takePhotoError:\(error)")
            } else {
                if processedImage != nil {
                    self.currentImgV.image = processedImage
                    self.images.append(processedImage!)
                    
                    DispatchQueue.main.async(execute: {
                        // 保存图片
                        UIImageWriteToSavedPhotosAlbum(processedImage!, self, #selector(self.saveImageToAlbum(_:didFinishSavingWithError:contextInfo:)), nil)
                    })
                    
                }
            }
            self.updateCountLabel()
        }
        
    }

    // MARK: 点击事件
   @objc fileprivate func tapAction(_ tap: UITapGestureRecognizer) {
        
        switch tap.state {
            
        case .ended:
            let point = tap.location(in: cameraView)
            doFocusToCurrentPoint(point)
            break
        case .ended, .failed, .cancelled:
            debugPrint("点击手势结束！")
            break
        default:
        break
        
        }
    }
    
    // MARK: 点击屏幕，聚焦；一定要先设置位置，再设置对焦模式。
    fileprivate func doFocusToCurrentPoint(_ point:CGPoint){
        let  size = cameraView.bounds.size
        let  focusPoint = CGPoint(x: point.y / size.height, y: 1-point.x / size.width )
        
        do{
            let device = stillCamera.inputCamera
            
            try device?.lockForConfiguration()
            
            // 对焦模式和对焦点
            if (device?.isFocusModeSupported(.autoFocus))!{
//                device.setFocusModeLockedWithLensPosition(<#T##lensPosition: Float##Float#>, completionHandler: <#T##((CMTime) -> Void)!##((CMTime) -> Void)!##(CMTime) -> Void#>)
                device?.focusPointOfInterest = focusPoint
                device?.focusMode = .autoFocus
        
            }
            
            // 曝光模式和曝光点
            if (device?.isExposureModeSupported(.autoExpose))! {
                device?.exposurePointOfInterest = focusPoint
                device?.exposureMode = .autoExpose
            }

            device?.unlockForConfiguration()
            
        }catch{
        
        }
        
        // focusView动画
        doAnimateForFoucus(atPoint: point)
    }
    

    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
        updateFilterGroup(atIndex: indexPath.row)
    
    }
    
    // ------------------------  private ------------------------ //

    //MARK: ---相机权限
    fileprivate func isGetCameraAccess()-> Bool{

        let authStaus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)

        if authStaus != AVAuthorizationStatus.denied{
            return true
        }else{
            return false
        }
    }
    
    
    //MARK: ----获取相册权限
    fileprivate func isGetPhotoAccess()->Bool{
        
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
    fileprivate func updateCountLabel(){
        
        if images.count == 0 {
            totalCount.text = ""
        }else{
            totalCount.text = String(images.count)
        }
    }
    
    // MARK: 更新fliter
    fileprivate func updateFilterGroup(atIndex index:Int){
        
        
        stillCamera.removeAllTargets()
//        filterGroup.removeAllTargets()
        
        switch index {
        case 0:
            let  filter = GPUImageGaussianBlurFilter() // 高斯模糊, 此时和无效果差不多
            filter.switch(toVertexShader: kGPUImageVertexShaderString, fragmentShader: kGPUImagePassthroughFragmentShaderString)
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
    @objc fileprivate func saveImageToAlbum(_ image:UIImage, didFinishSavingWithError error:NSError?, contextInfo:UnsafeMutableRawPointer){
        if error != nil {
            hud.showPromptText("保存图片失败！")
        }else{
            hud.showPromptText("保存图片成功！")
        }
    }
    
    // MARK: 点击屏幕聚焦时的动画
    fileprivate func doAnimateForFoucus(atPoint point:CGPoint){
        stopTimer()
        focusView.removeFromSuperview()
        
        startTimer()
        self.focusView.transform = CGAffineTransform.identity
        
        captrueView.addSubview(focusView)
        focusView.center = point
        focusView.alpha = 0
        
        UIView.animate(withDuration: 1, animations: {
            self.focusView.alpha = 1
            self.focusView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            })
    }
    
    // MARK: 定时器的
    @objc fileprivate func timeActionForFocus(){
        self.focusView.removeFromSuperview()
        self.focusView.transform = CGAffineTransform.identity
    }
    
    fileprivate func stopTimer(){
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
       
    }
    fileprivate func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timeActionForFocus), userInfo: nil, repeats: false)
    }
    
    deinit{
        // 全部置空
    }
    
}
