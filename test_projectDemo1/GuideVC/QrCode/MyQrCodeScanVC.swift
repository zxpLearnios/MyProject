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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func beginScanAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            scanQrCodeView.start()
        }else{
            scanQrCodeView.stop()
        }
        
    }
    
    // MARK: 相册
    @IBAction func albumAction(_ sender: UIButton) {
        if !isGetPhotoAccess() {
            print("没有相册权限，请到设置->隐私中开启本程序相册权限")
        }else{ // 进入相册
            
            let picker = UIImagePickerController() //MyImagePickerController.getSelf(nil)  // UIImagePickerController
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            
//            let vc = MyAlbumViewController()
//            let nav = MyCustomNav.init(rootViewController: vc)
//            nav.pushViewController(picker, animated: false)
//            self.presentViewController(nav, animated: true, completion: nil)
        }
        
    }

    // MARK: 开灯
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

    // MARK: ----- private ------
    // 展示扫描结果
    fileprivate func showScanResultInViewController(_ result:String, InViewController:UIViewController){
        
        if result.hasPrefix("http") {
            
            // 1. alert
            alert = UIAlertController.init(title: "", message: "此为一个链接，确定打开吗", preferredStyle: .alert)
            let confirm = UIAlertAction.init(title: "确定", style: .destructive, handler: { (action) in
                let url = URL.init(string: result)
                if url != nil {
                    UIApplication.shared.openURL(url!)
                }
            })
            
            let cancle = UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                
            })
            
            alert.addAction(confirm)
            alert.addAction(cancle)
            
            InViewController.present(alert, animated: true, completion: nil)
            
        }else{
            if  result == "" {
                alert = UIAlertController.init(title: "", message: "没有读取到二维码！", preferredStyle: .alert)
                let confirm = UIAlertAction.init(title: "确定", style: .cancel, handler: nil)
                
                alert.addAction(confirm)
                InViewController.present(alert, animated: true, completion: nil)

            }
        
        }

    }
    
    // MARK: -- MyQrCodeScanViewDelegate
    func finishScanQrCodeWithOutPutString(_ result: String) {
        print("获取到的二维码内容是---->\(result)")
        showScanResultInViewController(result, InViewController: self)
    }
    
    // MARK: ------  UIImagePickerControllerDelegate -----
    // 使用真机调试没问题, 模拟器选iphone5s及以上设备也是可以检测到的。
    // MARK: 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取选择的原图
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // 从所选中的图片中读取二维码
        let ciImage  = CIImage(image:image)!
        
        // 探测器
        let context = CIContext.init(options: nil)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        
        let features = detector?.features(in: ciImage)
        
        //遍历所有的二维码  && 取出探测到的数据
        for feature in features! {
            let qrCodeFeature = feature as! CIQRCodeFeature
            debugPrint(qrCodeFeature.messageString)
        }
        
        //        let resultVC = MyQrCodeScanResultVC()
        //        resultVC.image = image
        //        picker.presentViewController(resultVC, animated: true, completion: nil)
        
        
    }

    
}
