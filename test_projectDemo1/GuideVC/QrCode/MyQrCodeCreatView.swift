//
//  MyQrCodeView.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/6/24.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  二维码 生成View
//  1. 生成清晰的二维码， 2. 生成各种颜色的清晰的二维码， 3. 二维码可加个中间icon，4. 生成的二维码都是正方形的
//   调用顺序 4-->3-->1-->2  5. UnsafeMutablePointer在swift的使用

import UIKit
import CoreImage
//import CoreGraphics

// 闭包的三种写法
//typealias colsure = (str:String) -> Void
//var colsure1:((str:String) -> String) = {str in return str }
//let colsure2:((str:String) -> String) = {str in return str + "你好"}


class MyQrCodeCreatView: UIView {

    fileprivate let imageV = UIImageView()
    
    
    // MARK: 初始化, 加载UIView类xib时，就用此法
//    class func getSelf() -> MyQrCodeCreatView{
//        
//        let view = NSBundle.mainBundle().loadNibNamed("MyQrCodeCreatView", owner: nil, options: nil).last as! MyQrCodeCreatView
//        return view
//    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func doInit(){
        self.backgroundColor = UIColor.lightGray
        
        // 1.设置到imageView上即可
//        imageV.image = createQRImageWithString("http://www.baidu.com")
        
        // 1.1 测试最终的方法是否好用(此法，供外部调用)
        imageV.image = createQRImageWithString("http://www.baidu.com", qrImageWidth: 200, qrColor: UIColor.orange, iconImage: UIImage(named: "icon"), qrIconWidth: 30)
        
        // 2. 加 二维码中间图片
//        let imgV  = UIImageView.init(image: UIImage(named: "guide_bg0"))
//        imgV.bounds = CGRectMake(0, 0, 50, 50)
//        imgV.center = CGPointMake(self.width/2, self.height/2)
        //        self.addSubview(imgV)
    }
    
    /**
     1.  根据字符串生成二维码图片
     */
    fileprivate func createQRImageWithString(_ string:String) -> UIImage{
        // 0.
        imageV.frame = self.bounds
        self.addSubview(imageV)
        
        //系统自带能生成的码
        //        CIAztecCodeGenerator 二维码
        //        CICode128BarcodeGenerator 条形码
        //        CIPDF417BarcodeGenerator
        //        CIQRCodeGenerator     二维码
        // 1.创建滤镜对象
        let fliterName = "CIQRCodeGenerator" // CICode128BarcodeGenerator
        let filter =  CIFilter.init(name: fliterName)
        
        // 2.设置相关的信息
        filter?.setDefaults()
        
        
        // 3.设置二维码的数据
        let dataString = string
        let data =   dataString.data(using: String.Encoding.utf8)
        let keyPath = "inputMessage"
        filter?.setValue(data, forKey: keyPath)
        filter?.setValue("M", forKey: "inputCorrectionLevel") // L M H (L M 都很清晰)，各自形成的样式不一样的
        
        // 4.获取输出的图片
        let outputImage = filter?.outputImage
        
        
       // 5. 返回图片
        return createNonInterpolatedUIImageFormCIImage(outputImage!, withSize: 200)
    }
    
    /**
     2. 生成一定大小的 不变（原）的二维码图片
     */
    fileprivate func createNonInterpolatedUIImageFormCIImage(_ image:CIImage, withSize size:CGFloat)  -> UIImage {
    
        let  extent = image.extent.integral; // 原图片的尺寸
        let scale = min(size/extent.width, size/extent.height) // 以便不失真的缩放
        
        // 1.创建bitmap == 位映像
        let  width = size_t(extent.width * scale)
        let  height = size_t(extent.height * scale)
        
        let cs = CGColorSpaceCreateDeviceGray()
        
        let bitmapRef = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        
        let context =  CIContext.init(options: nil)
        let  bitmapImage =  context.createCGImage(image, from: extent)
        
        // 插值质量
        bitmapRef!.interpolationQuality = .none
        bitmapRef?.scaleBy(x: scale, y: scale)
        bitmapRef?.draw(bitmapImage!, in: extent)
        
        // 2.保存bitmap到图片 创建具有内容的位图图像
        let  scaledImage = bitmapRef?.makeImage()
        
        
        return UIImage.init(cgImage: scaledImage!)

    }
    
    /**
     *  3. 生成 自定义颜色的二维码图片
     */
    fileprivate func createQRImageWithString(_ string:String, qrImageWidth width:CGFloat, qrColor color:UIColor) -> UIImage {
        
        // 1. 由字符串（调用方法1.  2）得到 一个清晰的二维码
        let image = createQRImageWithString(string)
        
        // 2. 颜色数值
        let components = color.cgColor.components!
        if components.count == 0 {
            debugPrint("无法生成二维码图片！")
            return UIImage()
        }
        let  red  = (components[0])*255
        let green = (components[1])*255
        let blue  = (components[2])*255
        
        let imageWidth    = image.size.width
        let imageHeight   = image.size.height
        let bytesPerRow = imageWidth * 4
        
        let muResult = Int(bytesPerRow * imageHeight)
        
        let rgbImageBuf   =  UnsafeMutablePointer<UInt32>.init(bitPattern: muResult)!
        
//        let rgbImageBuf =   // UnsafeMutablePointer<UInt>.allocate(capacity: Int(bytesPerRow * imageHeight)) // (malloc(Int(bytesPerRow * imageHeight))) // UnsafeMutablePointer<UInt32>.init(bitPattern: muResult)
        // 3. 创建上下文
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var context = CGContext(data: rgbImageBuf,
                                            width: Int(imageWidth),
                                            height: Int(imageHeight),
                                            bitsPerComponent: 8,
                                            bytesPerRow: Int(bytesPerRow),
                                            space: colorSpace,
                                            bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.noneSkipLast.rawValue) // NoneSkipLast
        
        if image.cgImage ==  nil || context == nil{
            debugPrint("无法生成二维码图片！")
            return UIImage()
        }
        
        context!.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        
        
         // 4.像素转换
        let pixelNum = Int(imageWidth * imageHeight)
        var pCurPtr = rgbImageBuf
        
        for _ in 0..<pixelNum {
            
            // memory 在swift3变成了pointee
            if (pCurPtr.pointee & 0xFFFFFF00) < 0x99999900{

                let  ptr = pCurPtr // UnsafeMutablePointer<UInt8>.init(bitPattern: Int(pCurPtr.pointee))  // UnsafeMutablePointer<UInt8>.allocate(capacity: Int(pCurPtr.pointee))//  pCurPtr
                ptr[3] = UInt32(red)  //UInt32(UInt(UInt8(red))) //0~255
                ptr[2] = UInt32(green)
                ptr[1] = UInt32(blue)
            }else{
                
                let  ptr = pCurPtr
                ptr[0] = 0
            }
            pCurPtr += 1 // 循环
        }

        // 5.生成UIImage
        
//        let dataProvider = CGDataProvider(dataInfo: nil, data: rgbImageBuf, size: Int(bytesPerRow * imageHeight)) { (info, data, size) in
        
//        }
        
       let dataProvider = CGDataProvider.init(dataInfo: nil, data: rgbImageBuf, size: Int(bytesPerRow * imageHeight), releaseData: { (info, data, size) in
            
        })
        var imageRef = CGImage(width: Int(imageWidth),
                                     height: Int(imageHeight),
                                     bitsPerComponent: 8,
                                     bitsPerPixel: 32,
                                     bytesPerRow: Int(bytesPerRow),
                                     space: colorSpace,
                                    bitmapInfo: CGBitmapInfo.byteOrder32Little,
                                     provider: dataProvider!,
                                     decode: nil,
                                     shouldInterpolate: true,
                                     intent: CGColorRenderingIntent.defaultIntent) // CGImageAlphaInfo.Last.rawValue
        
        let resultUIImage = UIImage.init(cgImage: imageRef!)
        
        // 4.释放
        imageRef = nil
        context = nil
//        colorSpace = nil
        return resultUIImage
    }
    
    /**
     *  4. 外部只调用此法即可，生成各种颜色二维码图片
     */
     func createQRImageWithString(_ string:String, qrImageWidth imageWidth:CGFloat, qrColor color:UIColor, iconImage icon:UIImage?, qrIconWidth iconWidth:CGFloat) -> UIImage {
        // 6.  最终的图片
        let bgImage = createQRImageWithString(string, qrImageWidth: imageWidth, qrColor: color)
        
        UIGraphicsBeginImageContext(bgImage.size)
        bgImage.draw(in: CGRect(x: 0, y: 0, width: bgImage.size.width, height: bgImage.size.height))
        
        
        let  x = (bgImage.size.width - iconWidth) * 0.5
        let  y = (bgImage.size.height - iconWidth) * 0.5
        
        if icon != nil { // icon不为空
            icon?.draw(in: CGRect( x: x,  y: y, width: iconWidth,  height: iconWidth))
        }
        
        let newImage =  UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!

    }
}
