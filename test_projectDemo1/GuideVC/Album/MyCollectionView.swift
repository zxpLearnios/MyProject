//
//  MyCollectionView.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/7/21.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  暂时先不用

import UIKit

class MyCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    var totalCount = 0
    private let cellId = "MyCollectionViewCell"
    
    
    class func getSelf() -> MyCollectionView{
        let view = NSBundle.mainBundle().loadNibNamed("MyCollectionView", owner: nil, options: nil).last as! MyCollectionView
        // 改变布局
//        view.collectionViewLayout = MyCollectionViewLayout.init()
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 必须设置，区别与OC， 或在getSelf设置
        self.dataSource = self
        self.delegate = self
        
        // 数据不够一屏时，默认不滚动
        self.alwaysBounceVertical = true
        // 允许多选
        self.allowsMultipleSelection = true
        
        // 注册cell
         self.registerNib(UINib.init(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
        
        // 添加返回按钮
        let backBtn = UIButton.init()
        backBtn.setImage(UIImage(named: "album_delete_btn"), forState: .Normal)
        backBtn.width = 40
        backBtn.height = 20
        backBtn.center = CGPointMake(40, 30)
        
        backBtn.addTarget(self, action: #selector(backAction), forControlEvents: .TouchUpInside)
        self.addSubview(backBtn)
    }
    
    
    
    // 必须写，一确定cell的大小，否则就会用默认的; 每行展示3故 cell
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = (kwidth - 4 * 20)/3
        return CGSizeMake(width, width)
    }
    
    // MARK: UICollectionViewDelegate, UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalCount + 5
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! MyCollectionViewCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        debugPrint("点击了\(indexPath.item)")
    }

    // private 
    
    func backAction(btn:UIButton) {
//        self.
    }

}
