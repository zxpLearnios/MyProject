//
//  MySystemCamera.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/9/30.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//     系统自带相机

import UIKit

@objc protocol QLSystemCamareVCDelegate {
    optional func didFinishSelectImage(withResultImage image: UIImage)
}

/**
 *   系统拍照的使用
 */
class MySystemCamareVC: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    override class func initialize() {
//        
//    }
    var selectImgDelegate:QLSystemCamareVCDelegate!
    
    
    func doThing(){
        
        self.delegate = self
        self.allowsEditing = true
        self.sourceType = .Camera //
        //        cameraView.mediaTypes =  [kUTTypeImage as String]
        self.cameraCaptureMode = .Photo // 拍照 ;   .Vedio
        //        impVC.cameraFlashMode = .Auto  // 也是默认的值
        self.cameraDevice = .Rear
        let preView = UIView()
        preView.backgroundColor = UIColor.redColor()
        self.cameraOverlayView = preView
    }
    
    
    
    // MARK: 
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if self.selectImgDelegate != nil {
            self.selectImgDelegate.didFinishSelectImage!(withResultImage: image)
        }
        
    }
    
    
}