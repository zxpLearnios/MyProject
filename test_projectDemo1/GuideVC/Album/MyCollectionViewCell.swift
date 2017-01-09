//
//  MyCollectionCell.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/7/22.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit
import AssetsLibrary

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var imgV: UIImageView!

    var  image:UIImage!{
        didSet{
            imgV.image = image
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        imgV.image = UIImage(named: "guide_bg2")
        
    }
    
    
    override var isSelected: Bool {
        didSet{
            selectView.isHidden = !isSelected
        }
        
    }

}
