//
//  MyCollectionViewLayout.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/7/22.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit

class MyCollectionViewLayout: UICollectionViewFlowLayout {


    
    /**
     内部会重新调用prepareLayout和layoutAttributesForElementsInRect方法获得所有cell的布局属性
     */
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    // 每行显示3个cell
    override func prepareLayout() {
        super.prepareLayout()
        
        let inset:CGFloat = 10
        let width = (kwidth - inset * 4)/3
        self.itemSize = CGSizeMake(width, width)
        
        self.sectionInset = UIEdgeInsetsMake(64, inset, 0, inset)
        self.collectionView?.alwaysBounceVertical = true // 数据不够一屏时，默认不滚动
        // 设置水平滚动
//        self.scrollDirection = .Vertical
        // 设置分区的头视图和尾视图是否始终固定在屏幕上边和下边
//        self.sectionHeadersPinToVisibleBounds = true
//        self.headerReferenceSize = CGSizeMake(50, kwidth)
//        self.minimumLineSpacing = 10
//        self.minimumInteritemSpacing = 10
    }
    
    // 此时不写此法或注释掉 即为prepareLayout里所设置的布局
//    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        
//        // 1.取得默认的cell的UICollectionViewLayoutAttributes
//        let array = super.layoutAttributesForElementsInRect(rect) // 页面所有的元素
//        for i in 0..<array!.count  {
//            let attrs = array![i]
//            if attrs.representedElementCategory == .SupplementaryView {
//                continue
//            }
////            attrs.transform = CGAffineTransformMakeRotation(45)
//        }
//        
//        return array;
//
//    }
    
}
