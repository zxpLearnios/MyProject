//
//  WeakAndStrong.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 2017/5/5.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  默认的即为strong. 测试强弱引用，默认的即为强引用
//  强弱引用的样式

import UIKit

class WeakAndStrong: NSObject {

    
    private let name = "WeakAndStrong_name"
    
    override  init() {
        super.init()
      
        
    }
    
    final func testRetainCount() {
          let strongSelf = self
        UIView.animate(withDuration: 1, delay: 2, options: .curveEaseInOut, animations: {
            [weak self] in
            
            debugPrint("弱引用-当前名字是：%@", self?.name ?? "")
            debugPrint("默认引用即强引用-当前名字是：%@", strongSelf.name)
            }, completion: { finish in
                
        })
        
        // 强弱引用的样式
//        let sSelf = self
//        
//        UIView.animate(withDuration: 0, animations: { 
//            
//        }, completion: { [weak self] (finish) in
//            
//        })
//    
//        UIView.animate(withDuration: 1, delay: 2, options: .curveEaseInOut, animations: {
//            [weak self] in
//            
//            }, completion: { finish in
//                
//        })
    }
    
    
    deinit{
        debugPrint("WeakAndStrong 销毁了！")
    }
    
    
}


