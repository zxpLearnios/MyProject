//
//  CLHUD.swift
//
//  Created by Jingnan Zhang on 16/7/20.
//  外部只需init之后，即可调用相应的方法使用

import UIKit
import PKHUD

class MyHUD: NSObject {
    
    private let timeOut = 2.0
    
    override init() {
        HUD.dimsBackground = true
        // 不允许交互
        HUD.allowsInteraction = false
        
    }
    
    /**
     1. 展示成功或失败，只有图片
     */
    func showSuccessOrErrorByImage(isSuccess:Bool) {
        if isSuccess {
            HUD.flash(.Success, delay: timeOut)
        }else{
            HUD.flash(.Error, delay: timeOut)
        }
        
    }
    
    /**
     2. 展示提醒文字
     */
    func showPromptText(text:String) {
         HUD.flash(.Label(text), delay: timeOut)
    }
    
    /**
     3. 展示提示文字和静态图片, 成功、失败的图片在里面已设置好了
     */
    func showPromptText(isSuccess:Bool, text: String) {
        if isSuccess {
            HUD.flash(.LabeledImage(image: UIImage(named: "progress"), title: "", subtitle: text), delay: timeOut)
        }else{
             HUD.flash(.LabeledImage(image: UIImage(named: "progress"), title: "", subtitle: text), delay: timeOut)
        }
        
    }
    
    /**
     *  4. 展示正在加载, 须调hidden方法使其隐藏
     */
    func showLoadingProgress() {
        // 它默认的菊花进度
//        HUD.flash(.Progress, delay: timeOut)
        
        HUD.show(.LabeledRotatingImage(image: UIImage(named: "progress"), title: "", subtitle: "正在加载..."))
        
        // 默认会 消失
//        HUD.flash(.LabeledRotatingImage(image: UIImage(named: "progress"), title: "", subtitle: "正在加载..."))
    }
    
    /**
     *  5. 展示成功或失败时的文字和动态图片，外部传入文字
     */
    func showSuccessOrError(isSuccess:Bool, text: String) {
        if isSuccess {
            HUD.flash(.LabeledSuccess(title: "", subtitle: text), delay: timeOut)
        }else{
            HUD.flash(.LabeledError(title: "", subtitle: text), delay: timeOut)
        }
        
    }
    
    /**
     *  6. 隐藏
     */
    func hidden(afterDelay: Double) {
        HUD.hide(afterDelay: afterDelay, completion: nil)
    }
}
