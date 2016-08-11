//
//  MyCustomTabBar.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/5/30.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  自定义的tabbar

import UIKit


class MyCustomTabBar: UITabBar {
    
//    var plusBtn = MyPlusButton()
//    var countTag = 0
//    
//    var selectedBtn  = UIButton()
//    var buttons = [UITabBarItem]()
//    
//    // MARK: 初始化
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.doInit()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    private func doInit(){
////        self.barTintColor = UIColor.redColor()
//        plusBtn.setBackgroundImage(UIImage(named: "tabBar_publish_icon"), forState: .Normal)
//        plusBtn.frame.size = (plusBtn.currentBackgroundImage?.size)!
//        
////       self.items
//        plusBtn.addTarget(self, action: #selector(btnAction), forControlEvents: .TouchUpInside)
//        self.addSubview(plusBtn)
//    }
//    
//    
//    /**
//     *   添加tabbar按钮
//     */
//    func addTabBarItemsWith(title:String, image:UIImage?, selectedImage:UIImage?) {
//        
//        let btn = UITabBarItem.init(title: title, image: image, tag: countTag)
//        self.items?.append(btn)
//        
//        countTag += 1
//        
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//         plusBtn.center = CGPointMake(self.frame.width * 0.5, self.frame.height * 0.5)
//        
//        
//        let  buttonY:CGFloat = 0
//        let  buttonW = self.frame.width / 3
//        let  buttonH = self.frame.height
//        var  index:CGFloat = 0
//        
//        for item in self.subviews {
//            
//            var buttonX  = index * buttonW
//            if !(item.isKindOfClass(UIControl.classForCoder())  || item == plusBtn ) { // || item == plusBtn
//               continue
//            }
//            if index == 0 {
//                buttonX = buttonW
//                
////                item.backgroundColor = UIColor.redColor()
//            }else if index == 1{
//                buttonX = 0
////                item.backgroundColor = UIColor.greenColor()
//            }else{
//                buttonX = index * buttonW
////                item.backgroundColor = UIColor.blueColor()
//            }
//            
//            item.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH)
////            plusBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -self.frame.width/2, 0, 0)
//            index += 1
//
//        }
//
//    
//        
//    }
//
//    func  btnAction(btn:UIButton){
//        print("点击了加号按钮")
//    }
//    
//    
//    func itemClick(itemButton:UITabBarItem) {
////        if selectedBtn.frame == CGRectZero {
////            itemButton.selected = true
////            selectedBtn = itemButton
////        }else{
////            if selectedBtn == itemButton {
////                return
////            }else{
////                selectedBtn.selected = false
////                itemButton.selected = true
////                selectedBtn = itemButton
////            }
////        }
//        
//        print(itemButton.tag)
//    }
}


