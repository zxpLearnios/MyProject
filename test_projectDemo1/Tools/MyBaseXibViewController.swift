//
//  QLBaseXibViewController.swift
//  QTimelyLoan
//
//  Created by Jingnan Zhang on 16/9/21.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  1. 所有通过xib创建的控制器，xib名必须与类名一致， 继承之之后无须在写convenience方法加载xib了
//  2. TVC用xib不能编辑，故没意义的。
//  3. type(of: self) 获取类型

import UIKit



class  MyBaseXibViewController:UIViewController {
    
   
    convenience init(){
        
        let type = NSStringFromClass(type(of: self))
        let name = type.components(separatedBy: ".").last!
        self.init(nibName: name, bundle: nil)
        
    }
    
//    convenience init(_ name:String) {
//        self.init()
//    }
}
