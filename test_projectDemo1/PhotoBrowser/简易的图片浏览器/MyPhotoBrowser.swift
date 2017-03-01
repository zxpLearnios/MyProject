////
////  MyPhotoBrowser.swift
////  test_projectDemo1
////
////  Created by Jingnan Zhang on 16/9/8.
////  Copyright © 2016年 Jingnan Zhang. All rights reserved.
////  图片浏览器   转换坐标系
//
//import UIKit
//
//class MyPhotoBrowseraa: UIView, UIScrollViewDelegate{
//    
//    var imageViews = [UIImageView]()
//    
//    var scrollerImageViews = [UIImageView]() // scroller里的
//    var currentScrollerImageView :UIImageView! // scroller里的
//    var currentTapImageView :UIImageView! // view里的
//    
//    var imgVScrollers = [UIScrollView]() // 存放和图片一样大小的scroller， 由于他的zoom属性之后用
//    var currentImgVScroller:UIScrollView!
//    
//    var scrollerCountLab:UILabel!
//    
//    var mainScroller:UIScrollView! // 点击view里的图片后，由此来滑动展示所有的图片
//    
//    private var scale:CGFloat = 0
//    
//    
//    var images = [UIImage](){
//        
//        didSet{
//            doInitImageViews()
//        }
//        
//    }
//    
//    
//    // MARK: 初始化
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = UIColor.lightGray
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    
//    // MARK: 根据图片来添加ImageView
//    private func doInitImageViews(){
//        
//        let imgWH:CGFloat = 60
//        let padding = (self.frame.size.width - 3*60) / 4
//        
//        for i in 0..<images.count {
//            // 注意此处最好不要用FI，因为swift float可以对float求余了，float(1)/Int(3) = 0.3333的
//            //            let FI = CGFloat(i)
//            
//            let imgV = UIImageView()
//            imgV.frame = CGRect(x: padding + (padding + imgWH) * CGFloat(i % 3) ,  y: 50 + ((padding + imgWH) * CGFloat(i / 3)), width: imgWH, height: imgWH)
//            imgV.image = images[i]
//            imgV.tag = i
//            
//            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
//            imgV.isUserInteractionEnabled = true
//            imgV.addGestureRecognizer(tap)
//            
//            imageViews.append(imgV)
//            self.addSubview(imgV)
//            
//        }
//        
//        
//    }
//    
//    
//    
//    // MARK: 点击view里的图片
//    @objc private func tapAction(_ tap:UITapGestureRecognizer) {
//        
//        let tapImgV = tap.view as! UIImageView
//        currentTapImageView = tapImgV
//        
//        
//        if mainScroller == nil {
//            mainScroller = UIScrollView.init(frame: kbounds)
//            mainScroller.isPagingEnabled = true
//            mainScroller.zoomScale = mainScroller.minimumZoomScale
//            
//            scrollerCountLab = UILabel()
//            scrollerCountLab.font = UIFont.systemFont(ofSize: 30)
//            scrollerCountLab.textColor = UIColor.red
//            scrollerCountLab.textAlignment = .center
//            scrollerCountLab.bounds =  CGRect(x: 0, y: 0, width: mainScroller.frame.width, height: 30)
//            scrollerCountLab.center = CGPoint(x: mainScroller.center.x, y: mainScroller.frame.height - 40)
//            
//        }
//        
//        // 0.
//        scrollerImageViews.removeAll()
//        //        if imgVScrollers.count != 0 {
//        //            imgVScrollers.removeAll()
//        //        }
//        
//        // 1.
//        mainScroller.contentSize = CGSize(width: mainScroller.frame.width * CGFloat(images.count), height: 0)
//        
//        // 2.
//        for subV in mainScroller.subviews {
//            subV.removeFromSuperview()
//        }
//        
//        // 2.1
//        var ary = [UIScrollView]()
//        let imgWH:CGFloat = 60
//        let padding = (self.frame.size.width - 3*60) / 4
//        
//        //        for i in 0..<images.count {
//        //            // 注意此处最好不要用FI，因为swift float可以对float求余了，float(1)/Int(3) = 0.3333的
//        //            //            let FI = CGFloat(i)
//        //
//        //            let imgVScroller = UIScrollView()
//        //            imgVScroller.delegate = self
//        //            imgVScroller.multipleTouchEnabled = true
//        //            imgVScroller.minimumZoomScale = 1.0
//        //            imgVScroller.maximumZoomScale = 2.5
//        //
//        //            imgVScroller.frame = CGRectMake(padding + (padding + imgWH) * CGFloat(i % 3) ,  50 + ((padding + imgWH) * CGFloat(i / 3)), imgWH, imgWH)
//        //            imgVScroller.tag = i
//        //            ary.append(imgVScroller)
//        //            scroller.addSubview(imgVScroller)
//        //        }
//        
//        
//        
//        // 3.
//        for i in 0..<images.count {
//            
//            let imgV = UIImageView()
//            imgV.tag = i
//            imgV.image = images[i]
//            
//            var imgVW:CGFloat = 0
//            var imgVH:CGFloat = 0
//            
//            // 根据图片尺寸确定ImgV的大小
//            let imageW = imgV.image!.size.width
//            let imageH = imgV.image!.size.height
//            
//            
//            if imageW >= imageH { // 图片宽 >= 高
//                
//                if imageW > mainScroller.frame.width { // 图片比屏幕宽
//                    imgVW = mainScroller.frame.width
//                }else{
//                    imgVW = imageW // 此时按原图展示
//                }
//                
//                imgVH = imgVW / (imageW / imageH)
//            }else{ // 图片宽 < 高
//                
//                if imageH > mainScroller.frame.height {  // 图片比屏幕高
//                    imgVH = mainScroller.frame.height
//                }else{
//                    imgVH = imageH // 此时按原图展示
//                }
//                
//                imgVW = imgVH / (imageH / imageW)
//            }
//            
//            imgV.bounds = CGRect(x: 0,  y: 0, width: imgVW, height: imgVH)
//            imgV.center = CGPoint(x: mainScroller.frame.width * CGFloat(i) + mainScroller.center.x, y: mainScroller.center.y)
//            
//            mainScroller.addSubview(imgV)
//            //
//            scrollerImageViews.append(imgV)
//            
//            if tapImgV.tag == imgV.tag { // scroller将要显示的图片
//                currentScrollerImageView = imgV
//            }
//            
//        }
//        
//        // 4
//        mainScroller.isPagingEnabled = true
//        mainScroller.delegate = self
//        mainScroller.isUserInteractionEnabled = true
//        mainScroller.backgroundColor = UIColor.white
//        // 滚动至需要显示的图片处
//        mainScroller.setContentOffset(CGPoint(x: kwidth * CGFloat(tapImgV.tag), y: 0), animated: false)
//        mainScroller.frame = kbounds
//        
//        kwindow?.addSubview(mainScroller)
//        mainScroller.superview!.addSubview(scrollerCountLab)
//        
//        
//        // 5. 手势
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapScrollerAction))
//        // 捏合
//        let pinch = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchScrollerAction))
//        
//        let rotate = UIRotationGestureRecognizer.init(target: self, action: #selector(rotateScrollerAction))
//        
//        mainScroller.addGestureRecognizer(tap)
//        mainScroller.addGestureRecognizer(pinch)
//        //        mainScroller.addGestureRecognizer(rotate)
//        
//    }
//    
//    
//    // MARK: 点击scroller上的图片
//    @objc private func tapScrollerAction(_ tap:UITapGestureRecognizer) {
//        mainScroller.isUserInteractionEnabled = false
//        // 转换坐标系
//        let currentScrollerImageViewFrame = mainScroller.convert(currentScrollerImageView.frame, to: self) //currentScrollerImageView.frame
//        currentScrollerImageView.removeFromSuperview()
//        
//        // 按照她在scroller上的位置加到view上一样的位置
//        
//        self.addSubview(currentScrollerImageView)
//        currentScrollerImageView.frame = CGRect(x: currentScrollerImageViewFrame.origin.x, y: currentScrollerImageViewFrame.origin.y, width: currentScrollerImageViewFrame.width, height: currentScrollerImageViewFrame.height)
//        
//        //        scroller.zoomToRect(CGRectMake(10, 10, 100, 100), animated: true)
//        //        self.scroller.setZoomScale(self.scroller.minimumZoomScale, animated: true)
//        
//        UIView.animate(withDuration: 1, animations: {
//            self.mainScroller.backgroundColor = UIColor.clear
//            self.currentScrollerImageView.frame = self.currentTapImageView.frame
//        }, completion: { (fl) in
//            self.scrollerCountLab.removeFromSuperview()
//            self.mainScroller.removeFromSuperview()
//            self.mainScroller.setZoomScale(self.mainScroller.minimumZoomScale, animated: false)
//            self.mainScroller.addSubview(self.currentScrollerImageView)
//        })
//        
//    }
//    
//    
//    
//    // MARK: 捏合scroller上的图片
//    @objc private func pinchScrollerAction(_ pinch:UIPinchGestureRecognizer){
//        debugPrint(pinch.scale)
//        
//        var scale = pinch.scale
//        
//        let currentScrollerImageViewW = currentScrollerImageView.frame.width
//        let currentScrollerImageViewH = currentScrollerImageView.frame.height
//        
//        let transform = currentTapImageView.transform
//        
//        switch pinch.state {
//            
//        case .changed:
//            
//            if self.scale == 0 {
//                currentScrollerImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
//            }else{
//                
//                if pinch.scale < 1 {
//                    let x = abs(self.scale - (1 - pinch.scale))
//                    currentScrollerImageView.transform = CGAffineTransform(scaleX: x, y: x)
//                }else{
//                    
//                    let x = self.scale + (pinch.scale - 1)
//                    currentScrollerImageView.transform = CGAffineTransform(scaleX: x, y: x)
//                }
//                
//            }
//        //            mainScroller.setZoomScale(scale, animated: false)
//        case .ended:
//            
//            if scale <= 0.5 { // 最小倍数
//                scale = 0.5
//            }else if scale >= 1.5 { // 最大倍数
//                scale = 1.5
//            }else{
//                
//            }
//            
//            self.scale = scale
//            
//            currentScrollerImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
//            
//            //            currentTapImageView.bounds = CGRect.init(x: 0, y: 0, width: currentScrollerImageViewW * scale, height: currentScrollerImageViewH * scale)
//            
//        default:
//            break
//        }
//        
//        
//        
//    }
//    
//    // MARK: 旋转scroller上的图片
//    @objc private func rotateScrollerAction(_ rotate:UIRotationGestureRecognizer){
//        
//        
//    }
//    
//    //    // MARK: scroller上的遮盖按钮的点击
//    //    @objc private func converBtnAction(btn:UIButton) {
//    //        scroller.userInteractionEnabled = false
//    //
//    //        let currentScrollerImageViewFrame = currentScrollerImageView.frame
//    //        currentScrollerImageView.removeFromSuperview()
//    //
//    //        // 安按照她在scroller上的位置加到view上一样的位置
//    //        self.addSubview(currentScrollerImageView)
//    //        currentScrollerImageView.frame = CGRectMake(0, currentScrollerImageViewFrame.origin.y, currentScrollerImageViewFrame.width, currentScrollerImageViewFrame.height)
//    //
//    ////        scroller.zoomToRect(CGRectMake(10, 10, 100, 100), animated: true)
//    ////        self.scroller.setZoomScale(self.scroller.minimumZoomScale, animated: true)
//    //
//    //        UIView.animateWithDuration(1, animations: {
//    //            self.scroller.backgroundColor = UIColor.clearColor()
//    //            self.currentScrollerImageView.frame = self.currentTapImageView.frame
//    //            }) { (fl) in
//    //            self.scrollerCountLab.removeFromSuperview()
//    //             self.scroller.removeFromSuperview()
//    //            self.scroller.addSubview(self.currentScrollerImageView)
//    //        }
//    //
//    //
//    //    }
//    
//    
//    // MARK: UIScrollViewDelegate
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        //        self.scrollViewDidEndScrollingAnimation(scrollView)
//        
//        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
//        scrollerCountLab.text = String(format: "%d/%d", page, images.count)
//        
//    }
//    
//    // 用户滚动结束后
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        self.scrollViewDidEndScrollingAnimation(scrollView)
//    }
//    
//    //   系统自动滚动结束后
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        
//        //        let lastPage = kUserDefaults.integerForKey("currentPage")
//        
//        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
//        
//        
//        //        if page != lastPage {
//        //            NSUserDefaults.standardUserDefaults().setInteger(page, forKey: "currentPage")
//        //            NSUserDefaults.standardUserDefaults().synchronize()
//        //            currentScrollerImageView.transform = CGAffineTransformIdentity
//        //
//        //        }
//        
//        // 更新scroller里的代码显示的ImgV以及所对应的view里的imgV
//        currentScrollerImageView = scrollerImageViews[page]
//        currentTapImageView = imageViews[page]
//        
//        scrollerCountLab.text = String(format: "%d/%d", page, images.count)
//        
//        //        let scaleImgV = imageViews[currentImgVScroller.tag]
//        //        scaleImgV.frame = CGRectMake(0, 0, 50, 50)
//        
//    }
//    
//    
//    // MARK: 
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        currentImgVScroller = scrollView
//    }
//    
//    // MARK:  需要
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        if mainScroller != scrollView {
//            return currentScrollerImageView
//        }
//        return nil
//    }
//    
//    
//}
//
//
//
//




//////////// 

//
//  MyPhotoBrowser.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/9/8.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  图片浏览器   转换坐标系
/*. 创建控制的同时要设置布局参数.
 
 2. self.collectionView也要重新创建.*/

import UIKit

class MyPhotoBrowser: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var imageViews = [UIImageView]() // 存放自己里展示的图片
    
    var currentTapImageView :UIImageView! // view里的
    
    var currentImgVScroller:MyPhotoBrowserScrollView! // 当前 存放图片的scroller
    var currentImgV:UIImageView! // 当前正在浏览的mainScroller里的图片
    
    var scrollerCountLab:UILabel!
    
    
    private let cellId = "MyPhotoBrowserCell"
    var images = [UIImage](){
        
        didSet{
        }
        
    }
    
    
    
    final class func initWithFlowLayout(_ flowLayout:UICollectionViewFlowLayout) -> MyPhotoBrowser {
        let vc = MyPhotoBrowser()
        vc.collectionView = UICollectionView.init(frame: kbounds, collectionViewLayout: flowLayout)
        vc.collectionView!.register(MyPhotoBrowserCell.self, forCellWithReuseIdentifier: vc.cellId)
        
        vc.view.backgroundColor = UIColor.lightGray
        return vc
    }
    
    // MARK: 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: 旋转scroller上的图片
    @objc private func rotateScrollerAction(_ rotate:UIRotationGestureRecognizer){
        
        
    }
    
    // MARK : UICollectionViewDelegate, UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MyPhotoBrowserCell
        
        cell.image = images[indexPath.item]
        return cell
    }
    
    
    // 点击collectionView时 缩小图片
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        if scrollerCountLab == nil {
            // 页码label
            scrollerCountLab = UILabel()
            scrollerCountLab.font = UIFont.systemFont(ofSize: 30)
            scrollerCountLab.textColor = UIColor.red
            scrollerCountLab.textAlignment = .center
            scrollerCountLab.bounds =  CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 30)
            scrollerCountLab.center = CGPoint(x: collectionView.center.x, y: collectionView.frame.height - 40)
            
        }
        
        
        // 1.
        collectionView.contentSize = CGSize(width: collectionView.frame.width * CGFloat(images.count), height: 0)
        
        // 4
        // 滚动至需要显示的图片处
        //    collectionView.setContentOffset(CGPoint(x: collectionView.frame.width * CGFloat(tapImgV.tag), y: 0), animated: false)
        
        
        // 先将collectionView 加到kwindow上
        view.addSubview(scrollerCountLab)
        
        
        // 当前页码
        //    scrollerCountLab.text = String(format: "%d/%d", tapImgV.tag, images.count)
        
        
        
        
        
        
        
        let cell = collectionView.cellForItem(at: indexPath) as! MyPhotoBrowserCell
        currentImgV = cell.imageView
        
        // 转换坐标系
        let frame = cell.convert(cell.imageView.frame, to: self.view)
        
        currentImgV.removeFromSuperview()
        
        // 按照她在scroller上的位置加到view上一样的位置
        self.view.addSubview(currentImgV)
        currentImgV.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height)
        
        
        UIView.animate(withDuration: 1, animations: {
            self.view.backgroundColor = UIColor.clear
            self.currentImgV.frame = self.currentTapImageView.frame
        }, completion: { (fl) in
            self.scrollerCountLab.removeFromSuperview()
            self.view.removeFromSuperview()
            self.view.addSubview(self.currentImgV)
        })
        
    }
    
    // MARK : UICollectionViewDelegateFlowLayout
    // 确定item的大小
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //        return kbounds.size
    //    }
    
    // 必须写，一确定cell的大小，否则就会用默认的; 每行展示3故 cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (kwidth - 4 * 20)/3
        return CGSize(width: width, height: width)
    }
    
    // MARK: UIScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 向上取整：ceil(<#T##Double#>) ，向下取整：floor(<#T##Double#>)
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width + 0.5)
        scrollerCountLab.text = String(format: "%d/%d", page, images.count)
        
    }
    
    // 用户滚动结束后
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    //   系统自动滚动结束后
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        let lastPage = kUserDefaults.integer(forKey: "currentPage")
        
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        // 恢复当前未显示页面 至原大小
        if page != lastPage {
            UserDefaults.standard.set(page, forKey: "currentPage")
            UserDefaults.standard.synchronize()
        }
        
        // 更新scroller里的代码显示的ImgV以及所对应的view里的imgV
        //        currentImgVScroller = imgVScrollers[page]
        currentTapImageView = imageViews[page]
        
        scrollerCountLab.text = String(format: "%d/%d", page, images.count)
        
    }
    
    
    
    
}



class MyPhotoBrowserCell: UICollectionViewCell {
    
    var image: UIImage! {
        didSet{
            addViews()
        }
    }
    
    var imageView = UIImageView()
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    
    func addViews(){
        imageView.frame = self.bounds
        self.contentView.addSubview(imageView)
        
        imageView.image = image
    }
    
    
    
    
}


