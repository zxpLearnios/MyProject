//
//  UIView+extension.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/6/1.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  1. 主要是由于实现转场动画

import UIKit



enum AnimationType:String {
    
    /** 以下的由transitionWithType方法实现 */
    case fade = "fade",                  //淡入淡出 kCATransitionFade
    push = "push",                       //推挤  kCATransitionPush
    reveal = "reveal",                     //揭开  kCATransitionReveal
    moveIn = "moveIn",                     //覆盖  kCATransitionMoveIn
    
    cube = "cube",                       //立方体
    suckEffect = "suckEffect",                 //吮吸
    oglFlip = "oglFlip",                    //翻转
    rippleEffect = "rippleEffect",               //波纹
    pageCurl = "pageCurl",                   //翻页
    pageUnCurl = "pageUnCurl",                 //反翻页
    cameraIrisHollowOpen = "cameraIrisHollowOpen",       //开镜头
    cameraIrisHollowClose = "cameraIrisHollowClose",      //关镜头
    
    /**  以下的由animationWithView方法实现 */
    curlDown = "CurlDown",                   //下翻页
    curlUp = "CurlUp",                     //上翻页
    flipFromLeft = "FlipFromLeft",               //左翻转
    flipFromRight = "FlipFromRight"             //右翻转
    
}

/** 动画总时长 */
let viewTransitionDuration = 2.0

extension UIView{

    /**  x值 */
    var x:CGFloat {
        get{
            return self.frame.origin.x
        }
        set{
            self.frame.origin.x = newValue
        }
        
    }
    
    /**  y值 */
    var y:CGFloat {
        get{
            return self.frame.origin.y
        }
        set{
            self.frame.origin.y = newValue
        }
        
    }
    
    /**  宽度 */
    var width:CGFloat {
        get{
            return self.bounds.width
        }
        set{
            self.bounds = CGRect(x: 0, y: 0, width: newValue, height: self.bounds.height)
//            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newValue, self.frame.height)
        }
        
    }
    
    /**  高度 */
    var height:CGFloat {
        get{
            return self.bounds.height
        }
        set{
            self.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: newValue)
            
//            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newValue)
        }
        
    }
    
    /**
     这是用CATransition动画实现, 效果更好; 注意subType(就那4种)不能==type， 不然系统默认没动画效果了，并且有些subType、type的搭配也没效果
     */
    func transitionWithType(_ type:String, subType:String){
        
        let animation = CATransition()
        
        animation.duration = viewTransitionDuration
        //设置运动type
        animation.type = type
        if (!subType.isEmpty) {
            //设置子类
            animation.subtype = subType
        }
        //设置运动速度
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.layer.add(animation, forKey: "animation")
    }
    
    // 提醒作用
//    @available(iOS 8.0, *)
    
    /**
      这是用UIView实现动画，
     */
    func animationWith(_ transition:UIViewAnimationTransition){
        
        UIView.animate(withDuration: viewTransitionDuration, animations: {
            
            UIView.setAnimationCurve(.linear)
            UIView.setAnimationTransition(transition, for: self, cache: true)
            
        })
    }
    
}
