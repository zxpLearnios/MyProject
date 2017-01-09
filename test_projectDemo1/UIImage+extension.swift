//
//  Gif.swift
//  SwiftGif
//
//  Created by Arne Bahlo on 07.06.14.
//  Copyright (c) 2014 Arne Bahlo. All rights reserved.
//  主要用于 扩展以得到gif图片

import UIKit
import ImageIO
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


extension UIImage {

    class func gifWithData(_ data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }

        return UIImage.animatedImageWithSource(source)
    }

    class func gifWithURL(_ gifUrl:String) -> UIImage? {
        // Validate URL
        guard let bundleURL:URL? = URL(string: gifUrl)
            else {
                print("SwiftGif: This image named \"\(gifUrl)\" does not exist")
                return nil
        }

        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL!) else {
            print("SwiftGif: Cannot turn image named \"\(gifUrl)\" into NSData")
            return nil
        }

        return gifWithData(imageData)
    }

    class func gifWithName(_ name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
          .url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }

        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return gifWithData(imageData)
    }

    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1

        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)

        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        delay = delayObject as! Double

        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }

        return delay
    }

    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }

        // Swap for modulo
        if a < b {
            let c = a
            a = b
            b = c
        }

        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!

            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }

    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }

        return gcd
    }


    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }

            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }

        // Calculate full duration
        let duration: Int = {
            var sum = 0

            for val: Int in delays {
                sum += val
            }

            return sum
            }()

        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)

            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }

        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)

        return animation
    }

        //*************************** 有Iconfont字体文件里的编码获取图片  *****************//
    /**
     由Iconfont获取图片;
     1. 当tabbarItem的图片用此法获取时，颜色就会不起作用了，因为tabbar很特殊
     2. 当UIImageView的图片用此法获取时，字体大小就不起作用了，而frame起固定图片尺寸的作用
     - parameter content:    编码后的text 字体样式名字
     - parameter familyName: 字体库  不使用此参数时，此参数取默认
     - parameter size:       字体大小
     - parameter color:      字体颜色    不使用此参数时，此参数取默认
     
     - returns: 图片
     */
    static func if_image(withUniCode content: String, familyName: String = "iconfont", fontSize size: CGFloat, fontColor color: UIColor = UIColor.red) -> UIImage {
        
        //        debugPrint("familyName = \(familyName), fontColor = \(color)")
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        var attributes = [
            NSForegroundColorAttributeName: color,
            NSParagraphStyleAttributeName: paragraph
        ]
        
        if let font = UIFont(name: familyName, size: size) {
            attributes[NSFontAttributeName] = font
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, 0)
        
        content.draw(in: CGRect(x: 0, y: 0, width: size, height: size), withAttributes: attributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }

}
