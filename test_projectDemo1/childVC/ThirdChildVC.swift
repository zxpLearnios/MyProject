//
//  ThirdChildVC.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/5/31.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit

class ThirdChildVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let lab = UILabel.init(frame: CGRectMake(10, 100, 200, 20))
        lab.text = "规范收入很高入很高"
        self.view.addSubview(lab)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.transitionWithType(AnimationType.SuckEffect.rawValue, withSubType: kCATransitionFromTop, forView: self.view)
    }

}
