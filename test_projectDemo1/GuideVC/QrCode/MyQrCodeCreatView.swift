//
//  MyQrCodeView.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/6/24.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  二维码 生成View
//  1. 生成清晰的二维码， 2. 生成各种颜色的清晰的二维码， 3. 二维码可加个中间icon，4. 生成的二维码都是正方形的
//   调用顺序 4-->3-->1-->2

import UIKit
import CoreImage
//import CoreGraphics

// 闭包的三种写法
//typealias colsure = (str:String) -> Void
//var colsure1:((str:String) -> String) = {str in return str }
//let colsure2:((str:String) -> String) = {str in return str + "你好"}


class MyQrCodeCreatView: UIView {

    private let imageV = UIImageView()
    
    
    // MARK: 初始化, 加载UIView类xib时，就用此法
//    class func getSelf() -> MyQrCodeCreatView{
//        
//        let view = NSBundle.mainBundle().loadNibNamed("MyQrCodeCreatView", owner: nil, options: nil).last as! MyQrCodeCreatView
//        return view
//    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.doInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    private func doInit(){
        self.backgroundColor = UIColor.lightGrayColor()
        
        // 1.设置到imageView上即可
//        imageV.image = createQRImageWithString("http://www.baidu.com")
        
        // 1.1 测试最终的方法是否好用(此法，供外部调用)
        imageV.image = createQRImageWithString("http://www.baidu.com", qrImageWidth: 200, qrColor: UIColor.orangeColor(), iconImage: UIImage(named: "icon"), qrIconWidth: 30)
        
        // 2. 加 二维码中间图片
//        let imgV  = UIImageView.init(image: UIImage(named: "guide_bg0"))
//        imgV.bounds = CGRectMake(0, 0, 50, 50)
//        imgV.center = CGPointMake(self.width/2, self.height/2)
        //        self.addSubview(imgV)
    }
    
    /**
     1.  根据字符串生成二维码图片
     */
    private func createQRImageWithString(string:String) -> UIImage{
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
        let data =   dataString.dataUsingEncoding(NSUTF8StringEncoding)
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
    private func createNonInterpolatedUIImageFormCIImage(image:CIImage, withSize size:CGFloat)  -> UIImage {
    
        let  extent = CGRectIntegral(image.extent); // 原图片的尺寸
        let scale = min(size/extent.width, size/CGRectGetHeight(extent)) // 以便不失真的缩放
        
        // 1.创建bitmap == 位映像
        let  width = size_t(CGRectGetWidth(extent) * scale)
        let  height = size_t(CGRectGetHeight(extent) * scale)
        
        let cs = CGColorSpaceCreateDeviceGray()
        
        let bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, CGImageAlphaInfo.None.rawValue)
        
        let context =  CIContext.init(options: nil)
        let  bitmapImage =  context.createCGImage(image, fromRect: extent)
        
        // 插值质量
        CGContextSetInterpolationQuality(bitmapRef, .None)
        CGContextScaleCTM(bitmapRef, scale, scale)
        CGContextDrawImage(bitmapRef, extent, bitmapImage)
        
        // 2.保存bitmap到图片 创建具有内容的位图图像
        let  scaledImage = CGBitmapContextCreateImage(bitmapRef)
        
        
        return UIImage.init(CGImage: scaledImage!)

    }
    
    /**
     *  3. 生成 自定义颜色的二维码图片
     */
    private func createQRImageWithString(string:String, qrImageWidth width:CGFloat, qrColor color:UIColor) -> UIImage {
        
        // 1. 由字符串（调用方法1.  2）得到 一个清晰的二维码
        let image = createQRImageWithString(string)
        
        // 2. 颜色数值
        let components = CGColorGetComponents(color.CGColor)
        
        let  red  = components[0]*255
        let green = components[1]*255
        let blue  = components[2]*255
        
        let imageWidth    = image.size.width
        let imageHeight   = image.size.height
        let bytesPerRow = imageWidth * 4
         let rgbImageBuf   = UnsafeMutablePointer<UInt32> (malloc(Int(bytesPerRow * imageHeight)))
        
        // 3. 创建上下文
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGBitmapContextCreate(rgbImageBuf,
                                            Int(imageWidth),
                                            Int(imageHeight),
                                            8,
                                            Int(bytesPerRow),
                                            colorSpace,
                                            CGBitmapInfo.ByteOrder32Little.rawValue | CGImageAlphaInfo.NoneSkipLast.rawValue) // NoneSkipLast
        
        
        CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage)
        
         // 4.像素转换
        
        let pixelNum = Int(imageWidth * imageHeight)
        var pCurPtr = rgbImageBuf
        
        for _ in 0..<pixelNum {
            
            if ((pCurPtr.memory & 0xFFFFFF00) < 0x99999900){
                let  ptr =   UnsafeMutablePointer<UInt8>(pCurPtr)
                ptr[3] = UInt8(red) //0~255
                ptr[2] = UInt8(green)
                ptr[1] = UInt8(blue)
            }else{
                let  ptr = UnsafeMutablePointer<UInt8>(pCurPtr)
                ptr[0] = 0
            }
            pCurPtr += 1
        }

        // 5.生成UIImage
        
   
        let dataProvider = CGDataProviderCreateWithData(nil, rgbImageBuf, Int(bytesPerRow * imageHeight)) { (info, data, size) in
            
        }
        
        
        let imageRef = CGImageCreate(Int(imageWidth),
                                     Int(imageHeight),
                                     8,
                                     32,
                                     Int(bytesPerRow),
                                     colorSpace,
                                    CGBitmapInfo.ByteOrder32Little,
                                     dataProvider,
                                     nil,
                                     true,
                                     CGColorRenderingIntent.RenderingIntentDefault) // CGImageAlphaInfo.Last.rawValue
        
        let resultUIImage = UIImage.init(CGImage: imageRef!)
        
        return resultUIImage
    }
    
    /**
     *  4. 外部只调用此法即可，生成各种颜色二维码图片
     */
     func createQRImageWithString(string:String, qrImageWidth imageWidth:CGFloat, qrColor color:UIColor, iconImage icon:UIImage?, qrIconWidth iconWidth:CGFloat) -> UIImage {
        // 6.  最终的图片
        let bgImage = createQRImageWithString(string, qrImageWidth: imageWidth, qrColor: color)
        
        UIGraphicsBeginImageContext(bgImage.size)
        bgImage.drawInRect(CGRectMake(0, 0, bgImage.size.width, bgImage.size.height))
        
        
        let  x = (bgImage.size.width - iconWidth) * 0.5
        let  y = (bgImage.size.height - iconWidth) * 0.5
        
        if icon != nil { // icon不为空
            icon?.drawInRect(CGRectMake( x,  y, iconWidth,  iconWidth))
        }
        
        let newImage =  UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage

    }
}
