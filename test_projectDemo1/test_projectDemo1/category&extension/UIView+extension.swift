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
    case Fade = "fade",                  //淡入淡出 kCATransitionFade
    Push = "push",                       //推挤  kCATransitionPush
    Reveal = "reveal",                     //揭开  kCATransitionReveal
    MoveIn = "moveIn",                     //覆盖  kCATransitionMoveIn
    
    Cube = "cube",                       //立方体
    SuckEffect = "suckEffect",                 //吮吸
    OglFlip = "oglFlip",                    //翻转
    RippleEffect = "rippleEffect",               //波纹
    PageCurl = "pageCurl",                   //翻页
    PageUnCurl = "pageUnCurl",                 //反翻页
    CameraIrisHollowOpen = "cameraIrisHollowOpen",       //开镜头
    CameraIrisHollowClose = "cameraIrisHollowClose",      //关镜头
    
    /**  以下的由animationWithView方法实现 */
    CurlDown = "CurlDown",                   //下翻页
    CurlUp = "CurlUp",                     //上翻页
    FlipFromLeft = "FlipFromLeft",               //左翻转
    FlipFromRight = "FlipFromRight"             //右翻转
    
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
            
            self.bounds = CGRectMake(0, 0, newValue, self.bounds.height)
        }
        
    }
    
    /**  高度 */
    var height:CGFloat {
        get{
            return self.bounds.height
        }
        set{
            self.bounds = CGRectMake(0, 0, self.bounds.width, newValue)
        }
        
    }
    
    /**
     这是用CATransition动画实现, 效果更好; 注意subType(就那4种)不能==type， 不然系统默认没动画效果了，并且有些subType、type的搭配也没效果
     */
    func transitionWithType(type:String,withSubType subType:String,forView view:UIView){
        
        let animation = CATransition()
        
        animation.duration = viewTransitionDuration
        //设置运动type
        animation.type = type
        if (!subType.isEmpty) {
            //设置子类
            animation.subtype = subType;
        }
        //设置运动速度
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        view.layer.addAnimation(animation, forKey: "animation")
    }
    
    // 提醒作用
//    @available(iOS, introduced=8.0, deprecated=8.0, message="这是UIView实现的动画， 效果不如transitionWithType方法; 控制器view的动画需要在viewDidAppear里做")
    
    /**
      这是用UIView实现动画，
     */
    func animationWithView(view:UIView,withAnimationTransition transition:UIViewAnimationTransition){
        
        UIView.animateWithDuration(viewTransitionDuration, animations: {
            
            UIView.setAnimationCurve(UIViewAnimationCurve.Linear)
            UIView.setAnimationTransition(transition, forView: view, cache: true)
            
        })
    }
    
}
