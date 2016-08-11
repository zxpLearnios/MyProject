//
//  MyLoadProgressView.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/6/24.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit


class MyLoadProgressView: UIView {

    var startPoint:CGPoint = CGPointZero
    var stopPoint:CGPoint = CGPointZero
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // 缓冲条
        let beziPath = UIBezierPath.init()
        
        //
        beziPath.moveToPoint(startPoint)
        beziPath.addLineToPoint(stopPoint)
        
        beziPath.lineWidth = 6
        beziPath.lineJoinStyle = .Round
        
        UIColor.redColor().setStroke()
        beziPath.stroke()
    }

}
