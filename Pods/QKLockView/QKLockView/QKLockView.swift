//
//  QKLockView.swift
//  Created by Jingnan Zhang on 16/7/12.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  这是手势密码的工具类

import UIKit

//  手势密码每次设置完成后的代理方法
 protocol QKLockViewDelegate:NSObjectProtocol {
 func lockView<T>(lockView:QKLockView, didEndWithPassCode passcode:T)
    
}

/** 此view最好是正方形,目前宽高比=1：1.1 */
class QKLockView: UIView {
    
    var delegate:QKLockViewDelegate?
    var password:String?
    
    /** 选中按钮数组 */
    var btnAry = [UIButton]()
    
    var selectBtnAry = [UIButton]()
    var btnW:CGFloat = 0
    var verticalMergin:CGFloat = 0
    var horizonMergin:CGFloat = 0
    
    var currentPoint:CGPoint = CGPoint.init()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.doInit()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.doInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    func doInit() { // 宽高比 = 1：1.1
//        self.backgroundColor = UIColor.grayColor()
        btnW = UIScreen.mainScreen().bounds.size.width * 55.0 / 375.0
        horizonMergin = (UIScreen.mainScreen().bounds.size.width * 0.85 - 3 * btnW) * 0.5
        verticalMergin = ((btnW * 3 + horizonMergin * 2) * 1.1 - 3 * btnW) * 0.5
        for i in 0...8 {
            let btn:UIButton = UIButton.init(frame: CGRectMake(CGFloat(i % 3) * (btnW + horizonMergin), CGFloat(i/3) * (btnW + verticalMergin), btnW, btnW))
            btn.tag = i
            btn.contentMode = .ScaleAspectFill
            btn.userInteractionEnabled = false // 禁止与用户交互
            let nImg = QKLockViewImage.cicleNormalImage
            let sImg = QKLockViewImage.cicleSelectImage
            btn.setImage(nImg, forState: .Normal)
            btn.setImage(sImg, forState: .Selected)
            self.addSubview(btn)
            
            btnAry.append(btn)
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let tch:UITouch = (touches as NSSet).anyObject() as! UITouch
        currentPoint  = tch.locationInView(self)
        for btn in btnAry{
            if CGRectContainsPoint(btn.frame, currentPoint) && btn.selected == false{ // 按钮包含这个点
                btn.selected = true
                selectBtnAry.append(btn)
            }
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        currentPoint = ((touches as NSSet).anyObject() as! UITouch).locationInView(self)
        for btn in btnAry{
            if CGRectContainsPoint(btn.frame, currentPoint) && btn.selected == false { // 按钮包含这个点
                btn.selected = true
                selectBtnAry.append(btn)
            }
        }
        self.setNeedsDisplay()
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        var passStr:String = ""
        for btn in selectBtnAry {
            // 按钮的图片复原
            btn.selected = false
            passStr = passStr.stringByAppendingFormat("%d", btn.tag)
        }
        // 执行代理的方法,selectBtnAry.count != 0,防止了点击别处就触发代理的方法
        if (delegate != nil) && selectBtnAry.count != 0{
                delegate?.lockView(self, didEndWithPassCode: passStr)
        }
        selectBtnAry.removeAll()
        self.setNeedsDisplay()
        
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        selectBtnAry.removeAll()
        self.setNeedsDisplay()
    }
    
    /**
      * 绘图
     */
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let beziPath = UIBezierPath.init() // 必须重置
        
        if selectBtnAry.count == 0 {
            return
        }else{
            for i in 0...selectBtnAry.count-1 {
                if 1 == selectBtnAry.count {
                    beziPath.moveToPoint(selectBtnAry[i].center)
                    beziPath.addLineToPoint(currentPoint)
                    
                }else{
                    if i == selectBtnAry.count - 1 {
                        beziPath.moveToPoint(selectBtnAry[i].center)
                        beziPath.addLineToPoint(currentPoint)
                    }else{
                        beziPath.moveToPoint(selectBtnAry[i].center)
                        beziPath.addLineToPoint(selectBtnAry[i+1].center)
                    }
                    
                }
            
            }
        }
        beziPath.lineWidth = 8
        beziPath.lineJoinStyle = .Round
        UIColor.orangeColor().setStroke()
        beziPath.stroke()
    }
    
}


