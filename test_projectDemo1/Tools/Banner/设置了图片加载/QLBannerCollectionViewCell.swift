//
//  GGBannerCollectionViewCell.swift
//  QTimelyLoan
//
//  Created by Jingnan Zhang on 16/9/30.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit

class QLBannerCollectionViewCell: UICollectionViewCell {
    var imageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func doInit(){
        imageView = UIImageView.init(frame: self.bounds)
        imageView.contentMode = .scaleToFill
        self.contentView.addSubview(imageView)
    }
    
}
