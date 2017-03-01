//
//  MyPhotoBrowserCollectionView.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 2017/2/24.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  1. 展示图片浏览器，图片浏览器最主要的部分，实现图片的缩放、旋转  2. 由于外部将其加为子控制器、故其viewDidLoad方法不会调用了，但viewWillAppear会调用   3. 用来数组的成员直接替换，即直接拿到某处的成员直接赋新值即可

import UIKit

@objc protocol MyPhotoBrowserCollectionViewControllerDelegate {
    @objc optional func didClickCell(_ cell:MyPhotoBrowserCollectionViewCell)
}

class MyPhotoBrowserCollectionViewController: UICollectionViewController, MyPhotoBrowserScrollViewDelegate {

    weak var browserDelegate:MyPhotoBrowserCollectionViewControllerDelegate!
    var images = [UIImage]()
    var countLab = UILabel() // 页码
    
    private var contentOffset = CGPoint()
    private let cellId = "MyPhotoBrowserCollectionViewCell"
    private var currentCell = MyPhotoBrowserCollectionViewCell() // 记录当前点击的cell
    
    private let key = "currentPage_key",  animateTime = 0.5

    private var tagAry:[NSInteger]!
    private var scrollerAry:[MyPhotoBrowserScrollView]! // 由于cell的常用问题，会导致某处时的cell消失时已经无法在通过collectionView.cellForItem(at: <#T##IndexPath#>) 来获取cell了，自然也获取不到cell里的scroller来让其复原了；故此时用之将所有的scroller都存起来，这样就可以在collectionView滚动结束时将所有位显示的cell里的scroller复原，解决了scroller的缩放状态错乱
    
    private  var  lastPage = -1 // 之前的页面

    
    class var flowLayout: UICollectionViewFlowLayout {
        let fl = UICollectionViewFlowLayout()
        fl.scrollDirection = .horizontal
        fl.itemSize = kbounds.size
        fl.minimumLineSpacing = 0
        return fl
    }
    
    /**
     * 获取 CollectionView
     */
    private class var collectionV:UICollectionView {
        let view = UICollectionView.init(frame: kbounds, collectionViewLayout: MyPhotoBrowserCollectionViewController.flowLayout)
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = true
        view.backgroundColor = UIColor.white
        view.bounces = false
        
        return view
    }
    
    /**
     * 初始化方法
     */
    final class func initWithImages(_ images:[UIImage], contentOffset:CGPoint, tapImageView imgV:UIImageView) -> MyPhotoBrowserCollectionViewController {
        
        let vc = MyPhotoBrowserCollectionViewController()
        vc.contentOffset = contentOffset
        
        vc.tagAry = Array.init(repeating: -1, count: images.count)
        
        let subScroller = MyPhotoBrowserScrollView()
        vc.scrollerAry = Array.init(repeating: subScroller, count: images.count)
        
        // 必须重新初始化一个新的collectionView来使用
        vc.collectionView = collectionV
        
        // 先给图片数组赋值
        vc.images = images
        
         // 添加页码
        vc.addViews()
        return vc
    }
    
    
    /**
     *  添加页码
     */
    private func addViews(){
        
        // 页码label
        countLab.font = UIFont.systemFont(ofSize: 30)
        countLab.textColor = UIColor.red
        countLab.textAlignment = .center
        countLab.bounds =  CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        countLab.center = CGPoint(x: self.view.center.x, y: self.view.frame.height - 40)
        
        kwindow?.addSubview(countLab)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView?.register(MyPhotoBrowserCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        // 滚动至需要显示的图片处
        self.collectionView!.setContentOffset(contentOffset, animated: false)
        // 必须主动调用，以便首次展示时给lastPage赋正确的值
        scrollViewDidEndScrollingAnimation(self.collectionView!)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    // MARK : MyPhotoBrowserScrollViewDelegate
    func didClickPhotoBrowserScrollView(_ scrollView: MyPhotoBrowserScrollView) {
        let indexPath = IndexPath.init(row: scrollView.tag, section: 0)
        
        // 此时由于cell里加入了scroller且scroller可以与用户交互，故collectionView已经不能与用户交互了，故这里主动调用之
        collectionView(self.collectionView!, didSelectItemAt: indexPath)
        
    }
    
    // MARK : UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MyPhotoBrowserCollectionViewCell
        cell.tag = indexPath.item // 以便传给代理时根据cell的tag来获取一个缩放至原来的哪个图片那里
        cell.image = images[indexPath.item]
        
        cell.scrollView.tag = indexPath.item
        // 设置cell里的scroller的代理为自己
        cell.scrollView.photoBrowserScrollViewDelegate = self
        
        if tagAry.count == 0 {
            tagAry[cell.tag] = cell.tag
            scrollerAry[cell.tag] = cell.scrollView
//            scrollerAry.append(cell.scrollView)
        }else{
            if !tagAry.contains(cell.tag) {
                tagAry[cell.tag] = cell.tag
                scrollerAry[cell.tag] = cell.scrollView
//                scrollerAry.append(cell.scrollView)
            }
        }
        
        return cell
    }
    
    /**
    * 点击collectionView时 缩小图片
    */
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentCell = collectionView.cellForItem(at: indexPath) as! MyPhotoBrowserCollectionViewCell
        if browserDelegate != nil {
            browserDelegate.didClickCell!(currentCell)
        }
        
        
    }

    // MARK: UIScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width + 0.5)
        countLab.text = String(format: "%d/%d", page, images.count)
        
    }
    
    // 用户滚动结束后
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    //   系统自动滚动结束后
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width + 0.5)
        
        if lastPage == -1 { // 首次
            lastPage = page
        }else{ // 非首次
            if lastPage == page {
                
            }else{
                
                // 这句不行，因为由于cell是循环使用的，故有时会得不到需要位置的cell
//                let lastCell = self.collectionView!.cellForItem(at: IndexPath.init(row: lastPage, section: 0)) as? MyPhotoBrowserCollectionViewCell
//                lastCell?.scrollView.recoveryZoomScale()
                
                let lastScroller = scrollerAry[lastPage]
                lastScroller.recoveryZoomScale()

                lastPage = page
            }
        }
        
        countLab.text = String(format: "%d/%d", page, images.count)
        
    }


}


/**
 *  由于cell里加了个和自身一样大小的scroller，故此时将此cell加入collectionView时，collectionView是不能被点击的，故在scroller里写了代理。 看MyPhotoBrowserScrollView
 */
class MyPhotoBrowserCollectionViewCell: UICollectionViewCell {
    
    private  var  scroller:MyPhotoBrowserScrollView!
    
    var imageView: UIImageView! {
        return scroller.imgView
    }
    
    // 必须在设置完image后获取之
    var scrollView:MyPhotoBrowserScrollView {
        return scroller
    }
    
    
    var image: UIImage! {
        didSet{
            addViews()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 背景色
        self.contentView.backgroundColor = UIColor.lightGray
    }
    
    
    func addViews(){
        if scroller == nil{
            scroller = MyPhotoBrowserScrollView()
            scroller.frame = self.bounds
         
            self.contentView.addSubview(scroller)
        }
        scroller.image = image
    }
    
    
}

