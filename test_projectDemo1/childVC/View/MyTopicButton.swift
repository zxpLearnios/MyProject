//
//  MyTOpicButton.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/6/3.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  可以根据scroller的滚动情况缩放了

import UIKit

class MyTopicButton: UIButton {

    let fontSize:CGFloat = 14.0
    var red:CGFloat = 0.4
    var green:CGFloat = 0.6
    var blue:CGFloat = 0.7
    
    var normalColor = UIColor.red // 默认字体颜色
    var selectColor = UIColor.green // 选中时字体的颜色
    var bgColor = UIColor.init(red: 0.4, green: 0.6, blue: 0.7, alpha: 1)
    
    // r  g   b  a
    // 1  0  0    1 (默认)
    // 0  1   0    1 (选中)
    
    var scrollDirection = 0 // 0 用户左滑
    /** 0---1 */
    
    fileprivate var _colorProgress:CGFloat = 0.0
    var colorProgress:CGFloat {
        get{
            return self._colorProgress
        }
        set{
            self._colorProgress = newValue
            //      R G B
            // 默认：0.4 0.6 0.7
            // 红色：1   0   0
            
//            red = red + (1 - red) * colorProgress
//            green = green + (0 - green) * colorProgress
//            blue = blue + (0 - blue) * colorProgress
//            bgColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1)
//            self.setNeedsDisplay()
        }
    }
    
    fileprivate var _scale:CGFloat = 0.0
    var scale : CGFloat {
        get{
            return _scale
        }
        set{
            _scale = newValue
            
             self.transform = CGAffineTransform(scaleX: 1 + scale , y: 1 + scale) // [1  2]
        }
    }
    // 即可是高亮是的字体，图片状态不变
    fileprivate var _highlighted = false
    override var isHighlighted: Bool {
        get{
            return self._highlighted
        }
        set{
            self._highlighted = newValue
        }
    }

    // 不知道为啥，原来没事的。 现在，若重写此selected属性，则有关字体的颜色必须在此设置且在此设置也会出错，故此处调用了setNeedsDisplay
    fileprivate var _selected = Bool()
    override var isSelected: Bool{
        get{
            return _selected
        }
        set{
            _selected = newValue
            
            self.setNeedsDisplay()
            if isSelected {
                    self.transform = CGAffineTransform(scaleX: 2, y: 2)
            }else{
                self.transform = CGAffineTransform.identity
            }
        }
    }
    
    
    // MARK: 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.doInit()
    }
    
    fileprivate func doInit(){
        self.adjustsImageWhenDisabled = false
        self.titleLabel?.textAlignment = .center
        self.setTitleColor(normalColor, for: UIControlState())
        self.setTitleColor(selectColor, for: .selected)
        self.titleLabel?.font = UIFont.systemFont(ofSize: self.fontSize)
//        self.backgroundColor = bgColor
    }
    
   

}
