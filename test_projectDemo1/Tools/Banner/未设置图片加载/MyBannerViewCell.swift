//
//  MyBannerViewCell.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 2017/3/21.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

import UIKit

class MyBannerViewCell: UICollectionViewCell {

    @IBOutlet weak var contentV: UIView!
    @IBOutlet weak var titlelab: UILabel!
    @IBOutlet weak var deslab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        contentV.layer.borderColor = UIColor.white.cgColor
        contentV.layer.borderWidth = 1
        contentV.layer.cornerRadius = 5
        
    }

    
}
