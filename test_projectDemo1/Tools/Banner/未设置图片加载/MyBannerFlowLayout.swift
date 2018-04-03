//
//  MyBannerFlowLayout.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 2017/3/23.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  170 为cell的宽度， 70为cell间距

import UIKit

class MyBannerFlowLayout: UICollectionViewFlowLayout {

    private let cellW:CGFloat = 170
    private let cellH:CGFloat = 100
    
    /** 有效距离:当item的中间x距离屏幕的中间x在HMActiveDistance以内,才会开始放大, 其它情况都是缩小 */
    private let activeDistance:CGFloat = 150
    /** 缩放因素: 值越大, item就会越大 */
    private let scaleFactor:CGFloat = 0.6
    
    override init() {
        super.init()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /**
     * 1. 只要显示的边界发生改变就重新布局:Invalidate 使无效
     内部会重新调用prepareLayout和layoutAttributesForElementsInRect方法获得所有cell的布局属性
     */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    
    /**
     *  一些初始化工作最好在这里实现
     */
    override func prepare() {
        super.prepare()
        
        
        // 每个cell的尺寸
        self.itemSize = CGSize.init(width: cellW, height: cellH)
        //    CGFloat inset = (self.collectionView.frame.size.width - HMItemWH) * 0.5;
        //    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
        // 设置水平滚动
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = cellH * 0.7 // item之间的距离
        self.minimumInteritemSpacing = 0
        
        //设置边距(让第一张图片与最后一张图片出现在最中央)
//        self.sectionInset = UIEdgeInsetsMake(0, (kwidth - self.itemSize.width) / 2, 0, (kwidth - self.itemSize.width) / 2)
        
        //  [self registerClass:[CVDEView class] forDecorationViewOfKind:@"CDV"]; // 注册Decoration View 装饰view
        // 每一个cell(item)都有自己的UICollectionViewLayoutAttributes
        // 每一个indexPath都有自己的UICollectionViewLayoutAttributes
        
    }

    
    
    /**
     * 2. 用来设置collectionView停止滚动那一刻的位置，这是swift3里用的
     *
     *  @param proposedContentOffset 原本collectionView停止滚动那一刻的位置
     *  @param velocity              滚动速度
     */
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        // 1.计算出scrollView最后会停留的范围
        var lastRect = CGRect.zero
        lastRect.origin = proposedContentOffset
        
        lastRect.size = (self.collectionView?.frame.size)!
        
        // 计算屏幕最中间的x
        let centerX:CGFloat = proposedContentOffset.x + (self.collectionView?.width)! * 0.5
        
        // 2.取出这个范围内的所有属性，调用了自己的复写了父类的方法
        let array = self.layoutAttributesForElements(in: lastRect)
        
        // 3.遍历所有属性
        var  adjustOffsetX:CGFloat = CGFloat(MAXFLOAT)
        for attrs in array! {
            if abs(attrs.center.x - centerX) < abs(adjustOffsetX) {
                adjustOffsetX = attrs.center.x - centerX
            }
        }
        
        return CGPoint.init(x: proposedContentOffset.x + CGFloat(adjustOffsetX), y: proposedContentOffset.y)

    }
    
    /**
     * 2.1 用来设置collectionView停止滚动那一刻的位置 这是OC里用的，swift3里用此法无效
     *
     *  @param proposedContentOffset 原本collectionView停止滚动那一刻的位置
     *  @param velocity              滚动速度
     */
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
    // 1.计算出scrollView最后会停留的范围
//    var lastRect = CGRect.zero
//    lastRect.origin = proposedContentOffset
//    
//    lastRect.size = (self.collectionView?.frame.size)!
//    
//    // 计算屏幕最中间的x
//    let centerX:CGFloat = proposedContentOffset.x + (self.collectionView?.width)! * 0.5
//    
//    // 2.取出这个范围内的所有属性，调用了自己的复写了父类的方法
//    let array = self.layoutAttributesForElements(in: lastRect)
//    
//    // 3.遍历所有属性
//    var  adjustOffsetX:CGFloat = CGFloat(MAXFLOAT)
//    for attrs in array! {
//    if abs(attrs.center.x - centerX) < abs(adjustOffsetX) {
//    adjustOffsetX = attrs.center.x - centerX
//    }
//    }
//    
//    return CGPoint.init(x: proposedContentOffset.x + CGFloat(adjustOffsetX), y: proposedContentOffset.y)
//
//
//    }

    
    
    /**
     * 3. 布局每个cell的样式，放大、缩小
     */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        // 0. 计算可见的矩形框，即collectionView当前显示的区域在collectionView上面的具体坐标区域
        var visiableRect = CGRect.zero
        visiableRect.size = (self.collectionView?.frame.size)!
        visiableRect.origin = (self.collectionView?.contentOffset)!
        
        // 1.取得默认的cell的UICollectionViewLayoutAttributes
        let array = super.layoutAttributesForElements(in: rect)
        
        // 计算屏幕最中间的x
        let  centerX:CGFloat = self.collectionView!.contentOffset.x + self.collectionView!.frame.size.width * 0.5
        
        // 2.遍历所有的布局属性
        for attrs in array! {
            
            // 如果不在屏幕上,直接跳过 Intersects:交叉
            if !visiableRect.intersects(attrs.frame){
                continue
            }
            
            // 每一个item的中点x
            let itemCenterX = attrs.center.x
            
            // 差距越小, 缩放比例越大
            // 根据跟屏幕最中间的距离计算缩放比例
//            let  scale = 1 + scaleFactor * (1 - (abs(itemCenterX - centerX) / activeDistance))
//            attrs.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        }
        
        return array

    }
    
}




