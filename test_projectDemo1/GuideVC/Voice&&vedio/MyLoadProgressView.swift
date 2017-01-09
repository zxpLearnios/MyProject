//
//  MyLoadProgressView.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/6/24.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit


class MyLoadProgressView: UIView {

    var startPoint:CGPoint = CGPoint.zero
    var stopPoint:CGPoint = CGPoint.zero
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 缓冲条
        let beziPath = UIBezierPath.init()
        
        //
        beziPath.move(to: startPoint)
        beziPath.addLine(to: stopPoint)
        
        beziPath.lineWidth = 6
        beziPath.lineJoinStyle = .round
        
        UIColor.red.setStroke()
        beziPath.stroke()
    }

}
