//
//  MyQrCodeScanVC.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/6/29.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  二维码扫描ViewController
//  1. UIAlertController,  2. 从图片中读取二维码,  3. 判断是否可以获取硬件信息等是为了防止在模拟器上出错
//  4.  从相册的图片中读取二维码 >=8.2模拟器就可以了

import UIKit
import AVFoundation
import Photos
import AssetsLibrary


class MyQrCodeScanVC: UIViewController, MyQrCodeScanViewDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var scanQrCodeView: MyQrCodeScanView!
    var  alert:UIAlertController!

    convenience init(){
        self.init(nibName:"MyQrCodeScanVC", bundle: nil)
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        scanQrCodeView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func beginScanAction(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected {
            scanQrCodeView.start()
        }else{
            scanQrCodeView.stop()
        }
        
    }
    
    // MARK: 相册
    @IBAction func albumAction(sender: UIButton) {
        if !isGetPhotoAccess() {
            print("没有相册权限，请到设置->隐私中开启本程序相册权限")
        }else{ // 进入相册
            
            let picker = MyImagePickerController.getSelf(nil)  // UIImagePickerController
//            picker.delegate = self
            
            //指定图片控制器类型
//            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            let vc = MyAlbumViewController()
            let nav = MyCustomNav.init(rootViewController: vc)
            nav.pushViewController(picker, animated: false)
            self.presentViewController(nav, animated: true, completion: nil)
        }
        
    }

    // MARK: 开灯
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

    // MARK: ----- private ------
    // 展示扫描结果
    private func showScanResultInViewController(result:String, InViewController:UIViewController){
        
        if result.hasPrefix("http") {
            
            // 1. alert
            alert = UIAlertController.init(title: "", message: "此为一个链接，确定打开吗", preferredStyle: .Alert)
            let confirm = UIAlertAction.init(title: "确定", style: .Destructive, handler: { (action) in
                let url = NSURL.init(string: result)
                if url != nil {
                    UIApplication.sharedApplication().openURL(url!)
                }
            })
            
            let cancle = UIAlertAction.init(title: "取消", style: .Cancel, handler: { (action) in
                
            })
            
            alert.addAction(confirm)
            alert.addAction(cancle)
            
            InViewController.presentViewController(alert, animated: true, completion: nil)
            
        }else{
            if  result == "" {
                alert = UIAlertController.init(title: "", message: "没有读取到二维码！", preferredStyle: .Alert)
                let confirm = UIAlertAction.init(title: "确定", style: .Cancel, handler: nil)
                
                alert.addAction(confirm)
                InViewController.presentViewController(alert, animated: true, completion: nil)

            }
        
        }

    }
    
    // MARK: -- MyQrCodeScanViewDelegate
    func finishScanQrCodeWithOutPutString(result: String) {
        print("获取到的二维码内容是---->\(result)")
        showScanResultInViewController(result, InViewController: self)
    }
    
    // MARK: ------  UIImagePickerControllerDelegate -----
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        // 从所选中的图片中读取二维码
        let ciImage  = CIImage(image:image)!
        
        // 探测器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
        let features = detector.featuresInImage(ciImage)
        
        //遍历所有的二维码  && 取出探测到的数据
        for feature in features {
            let qrCodeFeature = feature as! CIQRCodeFeature
            showScanResultInViewController(qrCodeFeature.messageString, InViewController: picker)
            print(qrCodeFeature.messageString)
        }
        
//        let resultVC = MyQrCodeScanResultVC()
//        resultVC.image = image
//        picker.presentViewController(resultVC, animated: true, completion: nil)
        
        
    }
    
    
}
