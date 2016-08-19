

//
//  testVCViewController.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/19.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit

class testVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let pushVC = pushByfirstVC()
        let nav = MyPresentMav.init(rootViewController: pushVC)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
}
