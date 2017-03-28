//
//  MySystemCamera.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/9/30.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//     系统自带相册： 从拍照、图库、相册获取图片

import UIKit
import MobileCoreServices

@objc protocol MySystemAlbumVCDelegate {
    @objc optional func didFinishSelectImage(withResultImage image: UIImage)
}

/**
 *   系统拍照的使用
 */
class MySystemAlbumVC: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    override class func initialize() {
//        
//    }
    var selectImgDelegate:MySystemAlbumVCDelegate!
    
    /**
     * 是啥是用于相册
     */
    convenience init(_ isForAlbum:Bool){
        self.init()
        
        if isForAlbum{
        
        }else{
            doThing()
        }
    }
    
    private func doThing(){
        
        self.delegate = self
        self.allowsEditing = true
        
        
        
        // photoLibrary：来自图库， camera：来自相机, savedPhotosAlbum:来自相册. 在用这些来源的时候最好检测以下设备是否支持
        self.sourceType = .camera
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        
        }else if UIImagePickerController.isSourceTypeAvailable(.camera) {
        
        }else{
        
        }
        
//        cameraView.mediaTypes =  [kUTTypeImage as NSString]
        
        // photo: 相册        video：拍照
//        if self.doesCameraSupportShootingVideos() {
//            
//            self.cameraCaptureMode = .video // 拍照
//        
//        }
//        
//        if self.doesCameraSupportShootingTakePhoto() {
//            
//            self.cameraCaptureMode = .video // 拍照
//            
//        }
        
        self.cameraFlashMode = .auto  // 也是默认的值
        self.cameraDevice = .rear
        
        
//        let preView = UIView()
//        preView.backgroundColor = UIColor.red
//        self.cameraOverlayView = preView
    }
    
    
    
    // MARK:  获取原始图片, 从相册里选中或 拍照后点立即使用
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if self.selectImgDelegate != nil {
            self.selectImgDelegate.didFinishSelectImage!(withResultImage: image)
        }
        
    }
    
    //------------------- private -------------------- //
    
    /**
     * 判断设备是否有摄像头
     */
    private func isCameraAvailable() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    /**
     * 前面的摄像头是否可用
     */
    private func isFrontCameraAvailable() -> Bool{
        return UIImagePickerController.isCameraDeviceAvailable(.front)
    }
    
    /**
     *  后面的摄像头是否可用
     */
    private func isRearCameraAvailable() -> Bool{
        return UIImagePickerController.isCameraDeviceAvailable(.rear)
    }
    
    /**
     * 检查摄像头是否支持录像
     */
    private func doesCameraSupportShootingVideos() -> Bool{
        return self.cameraSupportsMedia( String(kUTTypeMovie), .camera)
    }
    
    /**
     * 检查摄像头是否支持拍照
     */
    private func doesCameraSupportShootingTakePhoto() -> Bool{
        return self.cameraSupportsMedia( String(kUTTypeImage), .camera)
    }
    
    /**
     * 判断是否支持某种多媒体类型：拍照，视频
     */
    private func cameraSupportsMedia(_ paramMediaType: String,_ sourceType: UIImagePickerControllerSourceType) -> Bool {
        
        
        var available = false
        
        if paramMediaType.characters.count == 0{
            
            
        }
        
        var availableMediaTypes = NSArray()
        
        if  let availableMediaTypeAry = UIImagePickerController.availableMediaTypes(for: sourceType) {
             availableMediaTypes = availableMediaTypeAry as NSArray
        }else{
            debugPrint("availableMediaTypes is empty.")
            return false
        }
        
        //  as NSArray
        availableMediaTypes.enumerateObjects({ (obj, index, stop) in
            
            let mediaType = obj as! String
            
            if mediaType == paramMediaType {
                available = true
                
            }
            
        })
        
        return available
        
    }
    
    
    
   // - 相册文件选取相关
    /**
     * 相册是否可用
     */
    private func isPhotoLibraryAvailable() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    /**
     * 是否可以在相册中选择视频
     **/
    private func canUserPickVideosFromPhotoLibrary() -> Bool{
        return self.cameraSupportsMedia(String(kUTTypeMovie), .photoLibrary)
    }
    
    /**
     * 是否可以在相册中选择视频
     */
    private func canUserPickPhotosFromPhotoLibrary() -> Bool{
        return self.cameraSupportsMedia(String(kUTTypeImage), .photoLibrary)
    }
    
    
    
}



