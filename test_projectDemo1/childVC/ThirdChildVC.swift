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
        self.view.backgroundColor = UIColor.white
        
        let lab = UILabel.init(frame: CGRect(x: 10, y: 100, width: 200, height: 20))
        lab.text = "规范收入很高入很高"
        self.view.addSubview(lab)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.transitionWithType(AnimationType.SuckEffect.rawValue, withSubType: kCATransitionFromTop, forView: self.view)
    }

}
