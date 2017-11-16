//
//  Created by Jingnan Zhang on 16/10/8.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  1. 自定义的可替代pageControl, 2.里面的按钮和自己高度一样， 3. 默认已选中了第一个按钮了，4. 外部可改变动画圆圈的颜色  5. 外部只需init即可，无须传入frame，记得设置center


import UIKit

class QLProgressView: UIView {
    
    var progressBtns = [QLProgressButton]()
    var isFirst = true
    
    private var _borderColor = UIColor.red.cgColor // 默认为红色
    var borderColor:CGColor {
        get{
            return self._borderColor
        }
        set{
            self._borderColor = newValue
        }
    }
    
    private var _numberOfPages = 3 // 默认显示可3页
    var numberOfPages:Int {
        get{
            return self._numberOfPages
        }
        set{
            self._numberOfPages = newValue
            // 若外部在自己加到父view上后 延迟2s再设置numberOfPages，则由于自己的layoutSubviews方法里的处理，即只会调一次numberOfPages，故会导致外部的设置无用且导致currentIndex越界
            isFirst = true
            setNeedsLayout()
        }
    }
    
    
    private var _currentIndex = 0
    var currentIndex:Int{
        get{
            return self._currentIndex // 在外部scroller滚动时设置
        }
        set{
            if newValue == currentIndex { // 避免在didScroll时不停地设置相同的页码
                return
            }
            self._currentIndex = newValue
            // iOS 中performSelectorOnMainThread  参数 waitUntilDone 很多说这个参数在主线程无效，这样的说法是错误的，当这个参数为YES,时表示当前runloop循环中的时间马上响应这个事件，如果为NO则runloop会将这个事件加入runloop队列在合适的时间执行这个事件。
            performSelector(onMainThread: #selector(setButtonStatus), with: nil, waitUntilDone: false)
            
            
        }
    }
    
    @objc private func setButtonStatus(){
        for btn in progressBtns {
            let currentBtn = progressBtns[currentIndex]
            if btn.isSelected {
                btn.isSelected = false // 取消以前的选中
                btn.setNeedsDisplay()
            }
            currentBtn.isSelected = true // 选中当前
            btn.setNeedsDisplay()
        }
    }
    
    // 首次被加到父view上、添加子控件时会调、子控件变化时
    override func layoutSubviews() {
        super.layoutSubviews()
       
        if isFirst {
            doInit()
        }
        isFirst = false
    }
    
    private func doInit(){
//        self.backgroundColor = UIColor.grayColor()
        // 1. 此段代码可实现动态改变子控件个数了
        for subBtn in progressBtns{
            subBtn.removeFromSuperview()
        }
        progressBtns.removeAll()
        
        
        let btnW:CGFloat = 10
        let btnH:CGFloat = btnW
        let margin = btnW * 1.5 // 间隔  = 按钮宽度的1.5倍
        
        // 2. 加
        for i in 0..<numberOfPages{
            let newI = CGFloat(i)
            
            let x = newI*(margin + btnW)
            let y = (self.frame.height - btnH)/2
            let btn = QLProgressButton.init(frame: CGRect(x: x, y: y, width: btnW, height: btnH))
            btn.tag = i
            if i == 0 {
                btn.isSelected = true // 默认选中第一个
            }
            
            btn.layer.borderColor = borderColor // 都用一样颜色
            self.addSubview(btn)
            progressBtns.append(btn)
        }
        
        // 设置自己的bounds  外部设置center
        self.bounds = CGRect(x: 0, y: 0, width: CGFloat(numberOfPages) * btnW + CGFloat(numberOfPages - 1) * margin, height: btnH)
        
        
    }
    
    
  

}



