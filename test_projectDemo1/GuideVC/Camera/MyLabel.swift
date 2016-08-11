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

    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
    }
    
    private func doInit(){
        self.layer.cornerRadius = self.frame.width / 4
        self.font = UIFont.systemFontOfSize(12)
        self.textAlignment = .Center
        self.textColor = UIColor.whiteColor()
        self.backgroundColor = UIColor.redColor()
        self.layer.masksToBounds = true // 须加。  UILabel和其他的view不一样
    }
    
    
}
