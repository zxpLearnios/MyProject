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
        guard let clsName = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] else {
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
     通过SB加载控制器
    */
    static func load(withStoryBoardName name:String) -> UIViewController {
        let sb = UIStoryboard.init(name: name, bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier(name)
        return vc
    }
   
}
