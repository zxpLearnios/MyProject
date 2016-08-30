//
//  MyCustomTabBarItem.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/5/30.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  专门用于无title的tabbar的item

import UIKit

class MyCustomTabBarItem: UITabBarItem {

//    private let ButtonImageRatio:CGFloat = 0.6
//    
//    // MARK: 初始化
//    
    override init() {
        super.init()
       
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    convenience init(image: UIImage?, selectedImage: UIImage?){
        self.init()
        
        self.image = image
        self.selectedImage = selectedImage
        
        self.imageInsets = UIEdgeInsetsMake(9, 0, -9, 0)
        
    }
    
}
