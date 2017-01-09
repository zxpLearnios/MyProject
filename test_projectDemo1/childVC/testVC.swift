

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let pushVC = pushByfirstVC()
        let nav = MyPresentMav.init(rootViewController: pushVC)
        self.present(nav, animated: true, completion: nil)
    }
    
}
