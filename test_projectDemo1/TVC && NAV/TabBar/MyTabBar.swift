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
    var onceToken:dispatch_once_t = 0
    
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
        
        debugPrint("layoutSubviews-------tabbar")
//        dispatch_once(&onceToken) {
            for item in self.subviews {
                
                var buttonX  = index * self.buttonW
                // 只找出 所有的UITabBarItem,
                if item.isKindOfClass(UIControl.classForCoder()) {
                    if index > 0 {
                        buttonX = (index + 1) * self.buttonW
                    }
                    item.frame = CGRectMake(buttonX, buttonY, self.buttonW, buttonH)
                    index += 1
                    
                    // 最后一个加的控制器多对应的item， 此时将此item放在第二个的位置处；
                    if index == self.totalCount {
                        let rVC = kwindow!.rootViewController as! MyCustomTVC
                        if rVC.isCompleteAnimate { // 在按钮动画结束后， 移除并加新的按钮
                            rVC.plusBtn.removeFromSuperview()
                            buttonX = self.buttonW
                            item.frame = CGRectMake(buttonX, buttonY, self.buttonW, buttonH)
                        }
                        
                        
                    }
                }
                
                
//            }
                
        }
        
        
    }
    
    
}
