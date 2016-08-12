//
//  QKLockViewImage.swift
//  QKLockViewDemo
//
//  Created by Jingnan Zhang on 16/8/11.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit

class QKLockViewImage: NSObject {

    class var cicleNormalImage:UIImage  {
        get{
            return QKLockViewImage.bundledImage(named: "circle_normal")
        }
    }
    
    class var cicleSelectImage:UIImage  {
        get{
            return QKLockViewImage.bundledImage(named: "circle_select")
        }
    }
    
    
    private class func bundledImage(named name: String) -> UIImage {
        let bundle = NSBundle.init(forClass: QKLockView.self)
        let image = UIImage(named: name, inBundle:bundle, compatibleWithTraitCollection:nil)
        if let image = image {
            return image
        }
        return UIImage()
    }

    
    
}
