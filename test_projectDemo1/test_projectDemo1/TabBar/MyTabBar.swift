//
//  MyTabBar.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/5/30.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  虽然替换了tabbar，但设置tabbar自身的属性时，还需在TVC里进行

import UIKit



class MyTabBar: UITabBar {

    private let totalCount:CGFloat = 4 // 必须自己来修改,这样其实会更方便
    var   buttonW:CGFloat = 0.0 // 方便外界的加号按钮来设置
    
    // MARK: 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.doInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func doInit() {
        
    }

    // 有几个子控件就会调用几次
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let  buttonY:CGFloat = 0
        
        buttonW = self.frame.width / totalCount
        let  buttonH = self.frame.height
        var  index:CGFloat = 0
        
        for item in self.subviews {
            
            var buttonX  = index * buttonW
            // 只找出 所有的UITabBarItem,
            if item.isKindOfClass(UIControl.classForCoder()) {
                if index > 0 {
                    buttonX = (index + 1) * buttonW
                }
                item.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH)
                index += 1

            }
            
        }
        
    }
}
