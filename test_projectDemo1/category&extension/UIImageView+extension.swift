//
//  UIImageView+extension.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/8.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  加载gif比webView快，但性能不如之

import UIKit

extension UIImageView {

    
    /**
     1. 展示gif图片 UIImage，不需要后缀名
     */
    func showGifWithNoSuffixName(gifName name:String){
        let image = UIImage.gifWithName(name)
        self.image = image
    }
    
    /**
     2. 展示gif图片 NSData，不需要后缀名
     */
    func showGifWithData(gifData data:Data){
        let image = UIImage.gifWithData(data)
        self.image = image
    }
    
    
    /**
     停止gif
     */
    
    fileprivate func stopGif(){
        
    }
    
    /**
     隐藏gif
     */
    fileprivate func hiddenGif(){
        
    }
}
