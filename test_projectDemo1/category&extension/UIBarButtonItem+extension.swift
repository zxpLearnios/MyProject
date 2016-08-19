//
//  UIBarButtonItem+extension.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/19.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit


extension UIBarButtonItem{

    static func initWith(image:UIImage, highlightImage hlImage:UIImage, selector sel:Selector, target:AnyObject) -> UIBarButtonItem{
        
        let barBtnItem:UIBarButtonItem!
        
        let btn = UIButton.init(type: .Custom)
        btn.setBackgroundImage(image, forState: .Normal)
        btn.setImage(hlImage, forState: .Highlighted)
        
        btn.frame.size = (btn.currentImage?.size)!
        btn.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
        
        barBtnItem = UIBarButtonItem.init(customView: btn)
        return barBtnItem

    }
    
   }
