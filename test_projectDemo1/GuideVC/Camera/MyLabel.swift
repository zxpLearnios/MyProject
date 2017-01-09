//
//  MyLabel.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/3.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit

class MyLabel: UILabel {

 
    override func awakeFromNib() {
        super.awakeFromNib()
        doInit()
    }

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    fileprivate func doInit(){
        self.layer.cornerRadius = self.frame.width / 4
        self.font = UIFont.systemFont(ofSize: 12)
        self.textAlignment = .center
        self.textColor = UIColor.white
        self.backgroundColor = UIColor.red
        self.layer.masksToBounds = true // 须加。  UILabel和其他的view不一样
    }
    
    
}
