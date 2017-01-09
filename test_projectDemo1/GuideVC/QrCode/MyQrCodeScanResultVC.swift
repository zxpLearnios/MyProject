//
//  MyQrCodeScanResultVC.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/6/30.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  从相册中扫描图片后的结果  二维码扫描结果 ， 1. 从相册的图片中读取二维码 >=8.2模拟器就可以了

import UIKit

class MyQrCodeScanResultVC: UIViewController {

    @IBOutlet weak var imgV: UIImageView!
    var image = UIImage()
    convenience init(){
        self.init(nibName: "MyQrCodeScanResultVC", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgV.image = image
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
   
        // 从所选中的图片中读取二维码
        let ciImage  = CIImage(image:imgV.image!)!
        
        // 探测器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
        let features = detector?.features(in: ciImage)
        
        //遍历所有的二维码  && 取出探测到的数据
        for feature in features! {
            let qrCodeFeature = feature as! CIQRCodeFeature
            print(qrCodeFeature.messageString)
        }
        
        sleep(2)
        self.dismiss(animated: true, completion: nil)
        
    }

}
