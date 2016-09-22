//
//  UIFont+extension.swift
//  QTimelyLoan
//
//  Created by Jingnan Zhang on 16/9/2.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit


private class Path {
    
    /**
     文件名
     */
    static func basename(path: String) -> String {
        return ((path as NSString).lastPathComponent as NSString).stringByDeletingPathExtension
    }
    
    /**
     文件的扩展名
     */
    static func extname(path: String) -> String {
        return (path as NSString).pathExtension
    }
    
    /**
     文件所在的文件夹名
     */
    static func dirname(path: String) -> String {
        return (path as NSString).stringByDeletingLastPathComponent
    }
    
    
    
}

extension UIFont {

    /**
     使用时，  最后将字体库放在mainBundle，  这是注册字体的方法之一，此法不如直接在info里面加入此库
    *   let fontPath = "FontAwesome.otf" ， UIFont.register(fontPath)，  之后即可使用此字体库了
     */
    static func register(path: String, bundle: NSBundle = NSBundle.mainBundle()) {
        
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        
        let basename = Path.basename(path)
        
        if UIFont.fontNamesForFamilyName(basename).isEmpty {
            // Ensure single instance
            dispatch_once(&Static.onceToken) {
                let data = getFontData(path, bundle: bundle)
                
                registerGraphicsFont(data)
            }
        }
    }
    
    
    private static func getFontData(path: String, bundle: NSBundle) -> NSData {
        let basename = Path.basename(path)
        let dirname = Path.dirname(path)
        let extname = Path.extname(path)
        
        if let
            fontURL = bundle.URLForResource(basename, withExtension: extname, subdirectory: dirname),
            data = NSData(contentsOfURL: fontURL)
        {
            return data
        }
        
        fatalError("`\(path)` is not found in \(bundle).")
    }
    
    private static func registerGraphicsFont(data: NSData) {
        var error: Unmanaged<CFError>?
        
        if let
            provider = CGDataProviderCreateWithCFData(data),
            font = CGFontCreateWithDataProvider(provider)
            where !CTFontManagerRegisterGraphicsFont(font, &error) {
            print(error)
        }
    }

}