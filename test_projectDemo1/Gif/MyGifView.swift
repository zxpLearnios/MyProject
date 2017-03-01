//
//  MyGifView.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/8.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  gif图片放在项目的任何地方都可以; 单例的写法

import UIKit

class MyGifView: UIImageView {
    
    /**  单例  */
    // 1.方法一   static:表示类用
//    private static let view = MyGifView() // 1.1
//    private class var view:MyGifView { // 1.2. 此时static == class; 1 == 2
//        return MyGifView()
//    }
    
//    static let shareInstance:MyGifView = { // 此时static == class
//        return view
//    }()
    
   
    // 2. 方法二
    private struct Constans {
        static let view = MyGifView()
    }
    
    class var shareInstance:MyGifView  { // 此时static == class
        return MyGifView.Constans.view
    }

  

}
