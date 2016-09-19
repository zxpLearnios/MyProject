//
//  MyPlusButton.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/5/30.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  专用于tabbar上面的有、无图片时的自定义按钮，会根据有无title自动适应image的位置、大小

import UIKit

class MyPlusButton: UIButton {

    
    let buttonImageRatio:CGFloat = 0.7 // 比例
    let normalColor = UIColor.redColor() // 默认字体颜色
    let selectColor = UIColor.greenColor() // 选中时字体的颜色
    let fontSize:CGFloat = 10
    
    
    // 0. 高亮时图片。title皆不变
    private var _highlighted = false
    override var highlighted: Bool{
        get{
            return self._highlighted
        }
        set{
            self._highlighted = newValue
        }
    }
    // -0. 如下写，则无效
//    override var highlighted: Bool{
//        didSet{
//            
//        }
//    }
    
    
    // MARK: 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
       self.doInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func doInit(){
        self.adjustsImageWhenDisabled = false
        self.setTitleColor(normalColor, forState: .Normal)
        self.setTitleColor(selectColor, forState: .Selected)
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        self.titleLabel?.textAlignment = .Center
    }
    
    // 设置 setImage时有用
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        
        var imgW:CGFloat = 49
        var imgH = imgW
        var imgX:CGFloat = self.frame.width/2 - imgW/2
        var imgY:CGFloat = 0
        
        if !(self.titleLabel?.text == "" || self.titleLabel?.text == nil) { // 有title时的图片情况
            imgW = 29
            imgH = 29
            imgY = 5
            imgX = self.frame.width/2 - imgW/2
            return CGRectMake(imgX, imgY, imgH, imgH)
        }
        return  CGRectMake(imgX, imgY, imgW, imgH)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        let titleY:CGFloat = contentRect.size.height * buttonImageRatio
        let titleW:CGFloat = contentRect.size.width
        let titleH:CGFloat = contentRect.size.height-titleY
        let titleX:CGFloat = 0
        return CGRectMake(titleX, titleY, titleW, titleH)
    }
    
   
}
