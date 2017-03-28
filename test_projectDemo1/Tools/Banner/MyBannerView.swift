//
//  MyBannerView.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 2017/3/21.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  显示样式：  2   3  (1  2  3 ...)  1  2  3 // 默认显示2在中间、显示1，3的各一小部分，即应返回比原数据多4个
//   170 为cell的宽度， 70为cell间距


import UIKit

class MyBannerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    private var collectionView:UICollectionView!
    private let cellId = "MyBannerViewCell"
    
//    var modelAry:[Model]!
    
    private var modelAry:[String] {
        return ["1", "2", "3", "4"]
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    
    private func doInit(){
        self.backgroundColor = UIColor.gray
        
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .horizontal
//        flowLayout.itemSize =  CGSize.init(width: 240, height: 100)
//        flowLayout.minimumLineSpacing = (self.width - 240) / 2 // 行间距，默认是10
//        flowLayout.minimumInteritemSpacing = self.width - 240 // 列间距，默认是10
//        let sectionPard = (self.width - 240) / 2 // 行内边距
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, sectionPard, 0, sectionPard)
        
        
//        let frame = CGRect.init(x: (self.width - 240 ) / 2, y:  (self.height - 240 ) / 2, width: 240, height: 100)
//        
//        let partWidth = (self.width - 240 - 20) / 2 // 显示的那一小部分
        // 1. 设置collectionView
        collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: MyBannerFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        
        
        // 1.1   170 为cell的宽度， 70为cell间距
        collectionView.contentSize = CGSize.init(width: 7 * 170 + 6 * 70, height: 0)
        collectionView.setContentOffset(CGPoint.init(x:   2.5 * 170 + 2 * 70 - collectionView.width / 2
            , y: 0), animated: false)
        
        // 2. 注册cell
        collectionView.register(UINib.init(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        
    }
    
    
    // MARK: UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelAry.count + 2 + 3 // 前面多2个后面多3个即可
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let celll = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MyBannerViewCell
        
        var titleStr = ""
        var desStr = ""
        
        if indexPath.item == 0{ // 前面多的那2个
            titleStr = modelAry[modelAry.count - 2]
        }else if indexPath.item == 1{
            titleStr = modelAry[modelAry.count - 1]
        }else if indexPath.item > modelAry.count + 1{ // 后面多的那3个
            if indexPath.item ==  modelAry.count + 2 {
                titleStr = modelAry[0]
            }else if  indexPath.item ==  modelAry.count + 3 {
                titleStr = modelAry[1]
            }else{
                titleStr = modelAry[2]
            }
            
        }else{ // 中间的，显示model数据
            titleStr = modelAry[indexPath.item - 2]
        }
        
        desStr = "展示的是第" + titleStr + "个"
        
        // 根据模型数据设置
        celll.titlelab.text = titleStr
        celll.deslab.text = desStr
        
        return celll
    }
    
    
   // 在这里处理滚动时的 偷换效果
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffX = scrollView.contentOffset.x
        //        let page = Int(contentOffX / itemSizeW + 0.5)
        
        let leftLimit:CGFloat = 1.5 * 170 + 1 * 70 - (collectionView.width / 2) // 第2页
        let rightLimit = (CGFloat(modelAry.count) + CGFloat(2.5)) * CGFloat(170) + (CGFloat(modelAry.count) + CGFloat(2)) * CGFloat(70) - collectionView.width / 2 // 倒数第三页
        
        if contentOffX <= leftLimit { // 移至倒数第四页
            
            //            collectionView.scrollToItem(at: IndexPath.init(row: 4, section: 0), at: UICollectionViewScrollPosition(), animated: false)
            
            //            let x = (CGFloat(modelAry.count) + CGFloat(2.5)) * CGFloat(170) + (CGFloat(modelAry.count) + CGFloat(2)) * CGFloat(70) - collectionView.width / 2
            
            
            scrollView.setContentOffset(CGPoint.init(x: rightLimit - 170 - 70, y: 0), animated: false)
            
        }else if contentOffX >= rightLimit{ // 移至正数第三页
            
            //            collectionView.scrollToItem(at: IndexPath.init(row: 2, section: 0), at: UICollectionViewScrollPosition(), animated: false)
            
            scrollView.setContentOffset(CGPoint.init(x: leftLimit + 170 + 70, y: 0), animated: false)
        }
    }
    
     // MARK:  用户滚动结束后
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        debugPrint(scrollView.contentOffset.x)
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    // MARK:    系统自动滚动结束后
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        let contentOffX = scrollView.contentOffset.x
////        let page = Int(contentOffX / itemSizeW + 0.5)
//        
//        let leftLimit:CGFloat = 1.5 * 170 + 1 * 70 - (collectionView.width / 2) // 第2页
//        let rightLimit = (CGFloat(modelAry.count) + CGFloat(2.5)) * CGFloat(170) + (CGFloat(modelAry.count) + CGFloat(2)) * CGFloat(70) - collectionView.width / 2 // 倒数第三页
//    
//        if contentOffX <= leftLimit { // 移至倒数第四页
//            
////            collectionView.scrollToItem(at: IndexPath.init(row: 4, section: 0), at: UICollectionViewScrollPosition(), animated: false)
//            
////            let x = (CGFloat(modelAry.count) + CGFloat(2.5)) * CGFloat(170) + (CGFloat(modelAry.count) + CGFloat(2)) * CGFloat(70) - collectionView.width / 2
//            
//            
//            scrollView.setContentOffset(CGPoint.init(x: rightLimit - 170 - 70, y: 0), animated: false)
//            
//        }else if contentOffX >= rightLimit{ // 移至正数第三页
//
////            collectionView.scrollToItem(at: IndexPath.init(row: 2, section: 0), at: UICollectionViewScrollPosition(), animated: false)
//            
//            scrollView.setContentOffset(CGPoint.init(x: leftLimit + 170 + 70, y: 0), animated: false)
//        }
        
        
    }
    
}
