//
//  Config.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/25.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit

enum SystemSetting:String {
    
    case set   = "" , //  UIApplicationOpenSettingsURLString,
    wifi = "prefs:root=WIFI",
    locate = "prefs:root=LOCATION_SERVICES", // 定位
    general = "prefs:root=General"  // 通用
}

class Config: NSObject {
    
   
    /**
     0. 弹框提醒，只有文字
     */
    class func showAlert(_ message:String){
        MyHUD.shareInstance.showPromptText(message)
    }
    
    
    /**
     1. 弹框提醒，有取消或确定按钮的
     *  外部传入的cancleTitle为空时，则无取消按钮了，只剩下确定按钮
     *  外部代理， 记得执行相应的代理方法; 不执行的话，会使点击后无反应而已
     */
    class func showAlert(withDelegate delegate:AnyObject?, title: String, message: String?, cancleTitle:String?, confirmTitle:String){
        
        let alert = UIAlertView() // UIAlertView.init(title: title, message: message, delegate: nil, cancelButtonTitle: cancleTitle, otherButtonTitles: confirmTitle)
        alert.delegate = delegate
        alert.title = title
        alert.message = message
        
        if cancleTitle != nil {
            alert.addButton(withTitle: cancleTitle)
        }
        
        alert.addButton(withTitle: confirmTitle)
        
        alert.show()
    }
    
    
    /**
     16 位颜色 传入0x****** \ #******
     
     - parameter color: <#color description#>
     
     - returns: <#return value description#>
     */
    class func colorWithHexString(_ color: String) -> UIColor!{
        
        var cString: String = color.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if cString.characters.count < 6 {return UIColor.black}
        if cString.hasPrefix("0X") {cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 2))}
        if cString.hasPrefix("#") {cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))}
        if cString.characters.count != 6 {return UIColor.black}
        
        var range: NSRange = NSMakeRange(0, 2)
        
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0 // 默认的内存地址0x00
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
    }
    
    /**
     *  跳转至设置界面
     */
    class func skipToSystemSetting(_ str:SystemSetting) {
        
        let url = URL.init(string: str.rawValue)
        if url == nil {
            return
        }
        if UIApplication.shared.canOpenURL(url!){
            UIApplication.shared.openURL(url!)
        }
    }
    
}
