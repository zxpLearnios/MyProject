//
//  Created by Jingnan Zhang on 16/8/8.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  动画按钮， 选中时背景色：红色 ； 取消选中时：透明

import UIKit

class QLProgressButton: UIButton, CAAnimationDelegate {

   
    let animateTime = 0.25
    
     //  用此动画，会导致 由停止到启动时的bug（从banner页进入其他页，在返回banner页时）
    var selectkeyAni = CAKeyframeAnimation()
    var cancleSelectkeyAni = CAKeyframeAnimation()
    
    let selectAniKey = "selectkeyAni_animate"
    let cancleSelectAniKey = "cancleSelectkeyAni_animate"
    
    
    // 串行队列
    var  queue:DispatchQueue!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.doInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.doInit()
    }
    
    private var _selected = Bool()
    override var isSelected: Bool{
    
        get{
            return self._selected
        }
        set{
            self._selected = newValue
            if self.isSelected {
                    DispatchQueue.main.async(execute: {
                        self.doSelectedAnimate()
                    })
                }else{
                    DispatchQueue.main.async(execute: {
                        self.doCancleSelectedAnimate()
                    })
                }
          
        }
    }
    
    private func doInit(){
        self.isEnabled = false
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = self.frame.width/6

        // 串行队列
        queue = DispatchQueue(label: "my_queue_name", attributes: [])
        
        
//        self.setImage(UIImage(named: "gesture_pre_normal"), forState: .Normal)
//        self.setImage(UIImage(named: "gesture_pre_confirm"), forState: .Selected)
        
    }
    
    // MARK: 选中、取消选中的动画
    func doSelectedAnimate() {
        self.layer.removeAllAnimations()
        self.backgroundColor = UIColor.red // 改变背景色
        
//        selectkeyAni = CAKeyframeAnimation.init(keyPath: "transform.scale")
//        selectkeyAni.duration = animateTime
//        selectkeyAni.values = [1.5, 1.0, 1.5]
//        selectkeyAni.delegate = self
//        self.layer.addAnimation(selectkeyAni, forKey: selectAniKey)
        
        UIView.animate(withDuration: animateTime, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: -10, options: .curveLinear, animations: {
            
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: nil)
        
    }
    
    func doCancleSelectedAnimate() {
        self.layer.removeAllAnimations()
        self.backgroundColor = UIColor.clear // 改变背景色
        
//        cancleSelectkeyAni = CAKeyframeAnimation.init(keyPath: "transform.scale")
//        cancleSelectkeyAni.duration = animateTime
//        cancleSelectkeyAni.values = [1.5, 0.7, 1.0]
//        cancleSelectkeyAni.delegate = self
//        self.layer.addAnimation(cancleSelectkeyAni, forKey: cancleSelectAniKey)
        
        UIView.animate(withDuration: animateTime, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveLinear, animations: {
//
            self.transform = CGAffineTransform.identity
            }, completion: nil)
        
    }

    // MARK:  动画结束后
 
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {

        
        if  flag && self.isSelected{ // 选中时，放大
            self.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1)
        }
        
        if flag && !self.isSelected { // 取消选中后，复原
            self.layer.transform = CATransform3DIdentity
        }
    }
}
