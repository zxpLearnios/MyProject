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
    fileprivate let cellId = "MyCollectionViewCell"
    
    
    class func getSelf() -> MyCollectionView{
        let view = Bundle.main.loadNibNamed("MyCollectionView", owner: nil, options: nil)?.last as! MyCollectionView
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
         self.register(UINib.init(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
        
        // 添加返回按钮
        let backBtn = UIButton.init()
        backBtn.setImage(UIImage(named: "album_delete_btn"), for: UIControlState())
        backBtn.width = 40
        backBtn.height = 20
        backBtn.center = CGPoint(x: 40, y: 30)
        
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.addSubview(backBtn)
    }
    
    
    
    // 必须写，一确定cell的大小，否则就会用默认的; 每行展示3故 cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (kwidth - 4 * 20)/3
        return CGSize(width: width, height: width)
    }
    
    // MARK: UICollectionViewDelegate, UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalCount + 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MyCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        debugPrint("点击了\(indexPath.item)")
    }

    // private 
    
    func backAction(_ btn:UIButton) {
//        self.
    }

}
