//
//  ViewController.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/7/21.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /**
     8.1 以下 xib加载控制器
     */
    convenience init(withNibName xibName:String){
        self.init(nibName: xibName, bundle: nil)
    }
    
    /**
     通过控制器的类名 创建控制器
     */
    func creatViewController(withControllerName controllerName: String) -> UITableViewController? {
        
        // 1.获取命名空间
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            debugPrint("命名空间不存在")
            return nil
        }
        
        // 2.通过命名空间和类名转换成类
        let cls: AnyClass? = NSClassFromString((clsName as! String) + "." + controllerName)
        
        // swift 中通过Class创建一个对象,须告诉系统Class的类型
        guard let clsType = cls as? UITableViewController.Type else {
            debugPrint("无法转换成UITableViewController")
            return nil
        }
        
        // 3.通过Class创建对象
        let controller = clsType.init()
        return controller
    }

    /**
     通过SB加载控制器  , 最后转换， 如： as QLRegisterViewController（这是使用泛型的弊端）
     */
    class func load<T>(withStoryBoardName name:String) -> T {
        let sb = UIStoryboard.init(name: name, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: name) as! T
        return vc
    }
    
   
}



class  QLBaseViewController:UIViewController {
    
    // 在swift里 控制器的init（构造器）发福利时无法加载xib的， 找不到。
    convenience init(){
        
        let type = NSStringFromClass(type(of: self))
        let name = type.components(separatedBy: ".").last!
        
        let nib = Bundle.main.path(forResource: name, ofType: "xib")
        let xx = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.last
        debugPrint("dfdfdfgdrgdfrgdg")
        if nib == nil {
            self.init(nibName: nil, bundle: nil)
        }else{
            self.init(nibName: name, bundle: nil)
        }
        
    }
    
    
}

