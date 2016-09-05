//
//  IconFontImageView.swift
//  QuarkCobraQSS
//
//  Created by Zhengkui Wang  on 16/6/27.
//  Copyright © 2016年 Zhengkui Wang . All rights reserved.
//  外部设置text = 采用这样的格式："\u{编号}"   例如 ： "\u{e603}"

import UIKit

@IBDesignable class QLIconFontLabel: UILabel {

    
    /*
     设置字体大小
     */
    private var _fontSize : Int = 14
    @IBInspectable var fontSize : Int {
        get {
            return _fontSize
        }
        
        set {
             _fontSize = newValue
            
             setFontForSelf()
        }

    }
    
    /** 圆角 */
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
    
    private func setFontForSelf(){
        let iconFont = UIFont(name: "iconfont", size: CGFloat(_fontSize))
        self.font = iconFont
        
    }
 
    
    func addTap(obj: AnyObject?, action: Selector) {
        if obj != nil {
            if obj!.respondsToSelector(action) {
                let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: obj, action:action)
                self.userInteractionEnabled = true
                self.addGestureRecognizer(tap)
            }
            
        }
    }
    
}
