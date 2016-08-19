//
//  MyPresentMav.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/18.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit

class MyPresentMav: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK:  -----------  在rootViewController里和需要旋转屏幕的VC里写 ------------------------- //
    override func shouldAutorotate() -> Bool {
        return (self.topViewController?.shouldAutorotate())!
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {

        return (self.topViewController?.supportedInterfaceOrientations())!
    }

    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return (self.topViewController?.preferredInterfaceOrientationForPresentation())!
    }
    
}
