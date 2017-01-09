//
//  MyPresentMav.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/18.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  被present的控制器所用的nav，用于横竖屏切换

import UIKit

class MyPresentMav: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK:  -----------  在rootViewController里和需要旋转屏幕的VC里写 ------------------------- //
    override var shouldAutorotate : Bool {
        return (self.topViewController?.shouldAutorotate)!
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {

        return (self.topViewController?.supportedInterfaceOrientations)!
    }

    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return (self.topViewController?.preferredInterfaceOrientationForPresentation)!
    }
    
}
