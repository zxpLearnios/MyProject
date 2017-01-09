//
//  MyAlbumTableViewCell.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/7/22.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit

class MyAlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var totalLab: UILabel!
    @IBOutlet weak var albumNameLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    
}
