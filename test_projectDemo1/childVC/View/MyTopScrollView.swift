//
//  MyTopScrollView.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/6/1.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  以后使用 UIScrollView， contentInset； 可以根据scroller的滚动情况缩放了

import UIKit

@objc protocol MyTopScrollViewDelegate {
    @objc optional func didSelectButtonAtIndex(_ index:NSInteger)
}

class MyTopScrollView: UIScrollView {
    // 直接创建一个全局的变量或静态属性来达到没有结果的just one time, 代替dispathc_once
    lazy var doOne:Void = {
        // 为保证此段代码值执行一次，则onceToken 应该写成全局的
        let total = CGFloat(self.titles.count)
        let btnW:CGFloat = 100
        let btnH = self.frame.height
        
        // 1. 底部红view
        //            let titleF = (self.titles[0] as NSString).boundingRectWithSize(CGSizeMake(kwidth, kheight), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(self.fontSize)], context: nil)
        
        self.redView.backgroundColor = UIColor.red
        self.addSubview(self.redView)
        
        // 2. 按钮
        for i in 0..<self.titles.count {
            
            let btnX = CGFloat(i) * btnW
            
            let btn = MyTopicButton.init(frame: CGRect(x: btnX, y: 0, width: btnW, height: btnH))
            btn.setTitle(self.titles[i], for: UIControlState())
            
            btn.tag = i
            btn.addTarget(self, action: #selector(self.topButtonAction), for: .touchUpInside)
            self.addSubview(btn)
            self.buttons.append(btn)
            
            //                if i == 0{ // 此时btn.titlelabel还没有宽、高, 故由外部设置了
            //
            //                    let x = btn.center.x - titleF.width/2
            //                    self.redView.frame = CGRectMake(x, self.frame.height - self.redViewH, titleF.width, self.redViewH)
            //                    btn.selected = true
            //                }
            
        }
        self.contentSize = CGSize(width: btnW * total, height: 0)
        
    }()

    var topScrollViewDelegate:MyTopScrollViewDelegate?
    
    var onceToken:Int = 0
    var selectBtn:MyTopicButton?
    
    var redView = UIView()
    let redViewH:CGFloat = 2
    let fontSize:CGFloat = 14.0
    var buttons = [MyTopicButton]()
    
    let scale:CGFloat = 0.3
    
    // MARK: 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.doInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    fileprivate func doInit(){
//        self.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0)
        self.backgroundColor = UIColor.init(red: 1, green: 0.5, blue: 0.3, alpha: 0.7)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
    }
    
    var titles:[String] = {
        return ["第一","二","第三","这第四个","第五个", "老六", "七月"]
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let _ = self.doOne
    }
    
    // MARK: 点击事件
    func topButtonAction(_ btn:MyTopicButton) {
        
//        if selectBtn != btn {
//            selectBtn.selected = false
//            btn.selected = true
//            selectBtn = btn
//        }
        
        if selectBtn == nil {
            btn.isSelected = true
            selectBtn = btn
        }else{
            if selectBtn == btn {
                return
            }else{
                selectBtn!.isSelected = false
                btn.isSelected = true
                selectBtn = btn
            }
            
        }
        // 1. 移动红view
        let lastLabF =  self.changeFrame((selectBtn!.titleLabel?.frame)!, toView: self)
        let x = lastLabF.origin.x + selectBtn!.frame.origin.x
         let newWidth = lastLabF.width
        
        UIView.animate(withDuration: 0.25, animations: {
           
            self.redView.frame = CGRect(x: x, y: self.frame.height - self.redViewH, width: newWidth, height: self.redViewH)
        }) 
        
        // 2.偏转scroller, 当前点击的按钮会尽量居中，距离不够时，不居中
        var  offX:CGFloat = 0.0
        if btn.center.x >= kcenter.x {
            let maxX = btn.frame.maxX
            if self.contentSize.width - maxX < kwidth/2 {
                offX = maxX - kwidth
            }else{
                offX = btn.center.x - kwidth/2
            }
            
        }
        
        self.setContentOffset(CGPoint(x: offX, y: 0), animated: true)
        
        print("点击了 \(btn.tag)")
        
        // 3. 点击按钮时，代理用来滚动内容scroller
        if self.topScrollViewDelegate != nil {
         self.topScrollViewDelegate?.didSelectButtonAtIndex!(btn.tag)
        }
        
        // 4，改变所点击按钮的属性
        
    }
    
    // MARK: 转换坐标系
    fileprivate func changeFrame(_ frame: CGRect, toView:UIView) -> CGRect{
        let newFrame =  self.convert(frame, to: toView)
        return newFrame
    }
    
}
