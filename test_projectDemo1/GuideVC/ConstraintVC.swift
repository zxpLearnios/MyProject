//
//  ConstrantsVC.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/29.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  使用CoreText

import UIKit
import Cartography
import LTMorphingLabel
import CoreText


class ConstraintVC: UIViewController, LTMorphingLabelDelegate {

    private let redView = UIView(), greenView = UIView(), blueView = UIView(), label = UILabel()//UILabel()
    private let muLabel = LTMorphingLabel()
    
    let mTexts = ["计划", "函数几号的", "客户萨尔那块", "弄好塞飞洛", "看发货", "看红方", "告诉你的"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(redView)
         self.view.addSubview(greenView)
         self.view.addSubview(blueView)
        self.view.addSubview(label)
        self.view.addSubview(muLabel)
        
        muLabel.delegate = self
        muLabel.text = mTexts[0]
        muLabel.textColor = UIColor.orangeColor()
      
        
        
        
//        label.textColor = UIColor.blackColor()
        label.text = "社团人格的若干"
        label.textAlignment = .Center
        redView.backgroundColor = UIColor.redColor()
        greenView.backgroundColor = UIColor.greenColor()
        blueView.backgroundColor = UIColor.blueColor()
        
        addConstranit1()
        
        
        useCoreText()
        
    }

    private func addConstranit1(){
      
        // 所有属性必须 都在里面设置
//        constrain(greenView, redView, blueView) { (g, r, b) in
//            
//            g.width == 200
//            g.height == 50
//            
//            g.center == g.superview!.center
//            r.width == g.height
//            r.height == g.width
//            r.left == g.right
//            r.topMargin == g.bottom + 20
//            
//           
//            b.size == b.superview!.size / 4
//            b.top == b.superview!.centerY - 250
//            b.leading == b.superview!.leading + 30
//            
//            
//        }
        
        // 注意， 主动view是第一个view，不要放错。  label 根据需要，可以不设置宽度的（和autolayout一样）
        // leading 和 trailing一起用， left和right一起用，最好不要出现leading\trailing和left\right一起用
        constrain(greenView, redView, blueView, label, muLabel) { (g, r, b, lab, mLab) in
            
            let superV = g.superview!
            g.width == 200
            g.height == 50
            
            r.size == g.size
            b.size == g.size
            
            g.leading == superV.leading + 50
            
            g.top == superV.top + 30
            
            r.top == g.bottom + 30
            
            b.top == r.bottom + 30
            
            
            
            align(leading: g, r, b, lab, mLab)
            
            lab.width == kwidth
            lab.top == g.bottom + 30
            
            mLab.center == superV.center
            
            //            distribute(by: 40, vertically: mainV, view1, view2) // view1.bottom = mainV.bottom + 40 ,  view2.bottom = view1.bottom + 40
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    private func useCoreText(){
    
        var str = NSMutableAttributedString.init(string: "vdth而后人和他")
        
        var attributeDic = [:]
         attributeDic = [UIColor.redColor(): kCTForegroundColorAttributeName]
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        super.touchesBegan(touches, withEvent: event)
        let index = random() % 6 //  case Scale , Evaporate, Fall, Pixelate, Sparkle, Burn, Anvil
        debugPrint("产生的随机数是 \(index)")
        
        
        // 动态效果, 两次的text必须不一样，才会有动画效果, 故在设置morphingEffect前先将text清空然后在设置先前的text，以达到，text一样时也有动态效果
        
        self.muLabel.text = ""
        if let  effect = LTMorphingEffect.init(rawValue: index) {
            self.muLabel.morphingEffect = effect
            self.muLabel.text = "动态效果就是的人还给她"  // mTexts[index]
        }
        
        
        label.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
    }
    
    
    // MARK: LTMorphingLabelDelegate
    
    func morphingDidStart(label: LTMorphingLabel) {
        debugPrint(morphingDidStart)
    }
    
    func morphingDidComplete(label: LTMorphingLabel) {
        debugPrint(morphingDidComplete)
    }
    
    func morphingOnProgress(label: LTMorphingLabel, progress: Float) {
//        debugPrint(progress)
    }
    
    
    
}
