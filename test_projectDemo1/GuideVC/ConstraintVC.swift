//
//  ConstrantsVC.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/29.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit
import Cartography


class ConstraintVC: UIViewController {

    let redView = UIView()
    let greenView = UIView()
    let blueView = UIView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(redView)
         self.view.addSubview(greenView)
         self.view.addSubview(blueView)
        
        redView.backgroundColor = UIColor.redColor()
        greenView.backgroundColor = UIColor.greenColor()
        blueView.backgroundColor = UIColor.blueColor()
        
        addConstranit1()
        
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
        
        
        constrain(greenView, redView, blueView) { (g, r, b) in
            
            g.width == 200
            g.height == 50
            
            r.size == g.size
            b.size == g.size
            
            g.leading == g.superview!.left + 50
            
            g.top == g.superview!.top + 30
            
            r.top == g.bottom + 30
            
            b.top == r.bottom + 30
            
            
            
            align(leading: g, r, b)
            
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
}
