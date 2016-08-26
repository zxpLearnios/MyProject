//
//  Config.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/25.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit

class Config: NSObject {

    /**
     0. 弹框提醒，只有文字
     */
    class func showAlert(message:String){
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
            alert.addButtonWithTitle(cancleTitle)
        }
        
        alert.addButtonWithTitle(confirmTitle)
        
        alert.show()
    }
    
    
    /**
     16 位颜色 传入0x****** \ #******
     
     - parameter color: <#color description#>
     
     - returns: <#return value description#>
     */
    class func colorWithHexString(color: String) -> UIColor!{
        
        var cString: String = color.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if cString.characters.count < 6 {return UIColor.blackColor()}
        if cString.hasPrefix("0X") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(2))}
        if cString.hasPrefix("#") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))}
        if cString.characters.count != 6 {return UIColor.blackColor()}
        
        var range: NSRange = NSMakeRange(0, 2)
        
        let rString = (cString as NSString).substringWithRange(range)
        range.location = 2
        let gString = (cString as NSString).substringWithRange(range)
        range.location = 4
        let bString = (cString as NSString).substringWithRange(range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        NSScanner.init(string: rString).scanHexInt(&r)
        NSScanner.init(string: gString).scanHexInt(&g)
        NSScanner.init(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
    }
}
