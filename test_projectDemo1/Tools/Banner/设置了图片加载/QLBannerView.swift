//
//  GGBannerView.swift
//  QTimelyLoan
//
//  Created by Jingnan Zhang on 16/9/30.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//   分页显示样式
//  1. 外部注意设置此view的frame时，防止由xib导致的frame不正确问题  2. 初始化后，先设置图片数组，再设置其他的！3. 设置图片数组和样式后，过一段时间再次改变原来设置的数组和样式依然正确 4. 外部xib使用之时，特别注意 设置控制器的self.automaticallyAdjustsScrollViewInsets = false  5. 外部使用时，不能也无须对图片数组做限制，即传过来数组为0个也可以
// Runloop.current 获取当前线程的runloop；Runloop.main 获取主线程的runloop

import UIKit
import Kingfisher

@objc protocol QLBannerViewDelegate {
    @objc optional func bannerView(bannerView view:QLBannerView, didSelectAtIndex index:Int)
}



enum QLBannerViewscrollDirection:NSInteger {
    case qlBannerScrollVertical = 0, qlBannerScrollHorizontal
}

enum QLBannerViewPageContolAliment:NSInteger {
    case qlBannerViewPageContolAlimentleft = 0, qlBannerViewPageContolAlimentCenter, qlBannerViewPageContolAlimentRight
}



class QLBannerView: UIView, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    var bannerDelegate:QLBannerViewDelegate!
    
    private let kImgManager = KingfisherManager.shared // 图片管理员
    private var placeholderImg:UIImage! // 占位图
    
    private var bannerCollectionView:UICollectionView!
//    private var pageControl:UIPageControl!
    private var pageControl:QLProgressView!
    private var timer: Timer!
    private var flowLayout: UICollectionViewFlowLayout!
    private var isFirst = true // 是否是首次 ,主要用于设置了对齐方式后的情况
    
    //*************************************************************//
    
    /**  自动换页时间间隔，0s 时则不自动滚动 default is 0s*/
    var timeInterval = 0.0 {
        didSet{
            if timeInterval > 0  {
                removeTimer()
                addTimer()
            }
        }
    }
    
    /**  只需在外部设置userScrollEnabled即可控制，一张图片时是否可以无限滚动,故这里不再新加变量*/
    /** 是否支持手势滑动.   默认 YES */
    var userScrollEnabled = true {
        didSet{
            self.bannerCollectionView.isScrollEnabled = self.userScrollEnabled
        }
    }
    /**  滚动方向，默认水平方向 */
    var scrollDirection = QLBannerViewscrollDirection.qlBannerScrollHorizontal {
        didSet{
            self.flowLayout.scrollDirection = UICollectionViewScrollDirection.init(rawValue: scrollDirection.rawValue)!
            bannerCollectionView.reloadData()
        }
    }
    /** pageControl的对齐方式, 默认居中 */
    var pageControlAliment = QLBannerViewPageContolAliment.qlBannerViewPageContolAlimentCenter{
        
        didSet{
            isFirst = false
            self.setNeedsDisplay() // 以使pageControl的位置正确
        }
    }
    
    /** 是否显示分页控件 */
    var  showPageControl = true{
        didSet{
            //此时 用 透明度，因为hiden不起作用
            if pageControl != nil {
                self.pageControl.alpha = showPageControl ? 1: 0
                pageControl.removeFromSuperview()
            }
        }
    }
    // 肯定是要么为本地图片，要么为网络图片.外部直接赋数组即可
    /** 图片数组 本地图片 */
    var localImages = [UIImage]() {
        didSet{
            self.isFromLocal = true
            configImages(localImages)
            
        }
    }
    /** 图片数组 网络图片 */
    var imageUrls = [String](){
        didSet{
            self.isFromLocal = false
            configImages(imageUrls as [AnyObject])
            
        }
    }
    
    /** 一张图时 是否隐藏pagecontrol，默认为NO */
    var  hidesForSinglePage = false
    
    /** cell的长度\宽度 */
    var unitLength:CGFloat {
        return (scrollDirection == .qlBannerScrollHorizontal) ? self.frame.width : self.frame.height;
    }
    
    /** collectionView的偏移 */
    var offsetLength:CGFloat{
         return (scrollDirection == .qlBannerScrollHorizontal) ? self.bannerCollectionView.contentOffset.x : self.bannerCollectionView.contentOffset.y
    }
    
    /** collectionView旧的偏移 */
    var oldOffsetLength:CGFloat = 0
    
    /** collectionView的内容长度 */
    var contentLength:CGFloat {
    return (scrollDirection == .qlBannerScrollHorizontal) ? self.bannerCollectionView.contentSize.width : self.bannerCollectionView.contentSize.height
    }
    /** 重试次数 */
    var networkFailedRetryCount = 5
    /** 默认：NO, 是否来自本地 在cellFor时用，外部设置好图片数组后就设置好它的值 */
    var isFromLocal = false
    
    
    private let cellid = "banner_cell"
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        doInit()
//    }
//
//    // MARK: 初始化
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        doInit()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if isFirst {
            doInit()
            return
        }
        
        let size = pageControl.frame.size // CGSizeZero
        var x:CGFloat = 0
        let y = self.bounds.maxY - 15
        
        if (self.isFromLocal) {
            //                size = pageControl.sizeForNumberOfPages(localImages.count)
        } else {
            //                size = pageControl.sizeForNumberOfPages(imageUrls.count)
        }
        
        switch pageControlAliment {
            
        case .qlBannerViewPageContolAlimentleft: // 居左
            x = 15
            pageControl.center = CGPoint(x: size.width * 0.5 + x, y: y)
            
        case .qlBannerViewPageContolAlimentRight: // 居右
            x = self.frame.width - size.width * 0.5 - 15
            pageControl.center = CGPoint(x: x, y: y)
            
        default: // 居中
            x = self.frame.width * 0.5
            pageControl.center = CGPoint(x: x, y: y)
        }

    }
    
    // MARK: 一些初始设置
    private func doInit(){
        placeholderImg = UIImage(named: "bg_banner")
    }
    
    
    // MARK: 外部调用 暂停、开始
    func stop() {
//        performSelectorOnMainThread(#selector(removeTimer), withObject: nil, waitUntilDone: false)
        removeTimer()
    }
    
    func start()  {
//        performSelectorOnMainThread(#selector(addTimer), withObject: nil, waitUntilDone: false)
         addTimer()
    }
    
    
    // MARK: 外部设置完图片数组后，即调用此法
    private func configImages(_ images: [AnyObject]){
        if images.count == 0 { // 传过来的本地图片数组或网络图片数组为0时，显示这个imageView
            let zeroImgV = UIImageView.init(frame: self.bounds)
            zeroImgV.image = UIImage(named: "bg_banner")
            self.addSubview(zeroImgV)
            return
        }
        
        
        
        initSubviews() // 安装子控件, 此时，图片数组，已经数组好
        
        pageControl.numberOfPages = images.count
        
        bannerCollectionView.reloadData()
    }
    
    
    private func initSubviews(){
        setupCollectionView()
        
        // 2.添加pagecontrol
        setupPageControl()
        
        // 3. 默认添加的动画样式的pageController
//        if (self.isFromLocal) {
//            pageControl.sizeForNumberOfPages(localImages.count)
//            
//        }else{
//            pageControl.sizeForNumberOfPages(imageUrls.count)
//        }
        
        // 默认pagecontrol居中
        let y = self.bounds.maxY - 15
        pageControl.center = CGPoint(x: self.frame.width * 0.5, y: y)
        
        // 4. 默认加动画样式的
        self.addSubview(pageControl)
    }
    
    // MARK: 设置
    private func setupCollectionView(){
        //流水布局
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.frame.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal // 默认是水平滚动
        
        
        //显示图片的collectionView
        bannerCollectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: flowLayout)
        bannerCollectionView.backgroundColor = UIColor.clear
        bannerCollectionView.isPagingEnabled = true
        
        bannerCollectionView.showsHorizontalScrollIndicator = false
        bannerCollectionView.showsVerticalScrollIndicator = false
        
        bannerCollectionView.register(QLBannerCollectionViewCell.self, forCellWithReuseIdentifier: cellid)
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        
       self.addSubview(bannerCollectionView)
        
    }
    
    // MARK: 设置pageControl
    private func setupPageControl(){
        
        if pageControl == nil {
//            pageControl = UIPageControl.init()
//            pageControl.currentPage = 0
            pageControl = QLProgressView()
            
            if isFromLocal {
                pageControl.numberOfPages = localImages.count
            } else {
                pageControl.numberOfPages = imageUrls.count
            }
//            pageControl.currentPageIndicatorTintColor = UIColor.brownColor()
//            pageControl.pageIndicatorTintColor = UIColor.grayColor()
            
            pageControl.borderColor = kButtonBgColor.cgColor // pageControl里圆点的颜色
            
        }
    }
    
    // MARK: 定时器方法
    @objc private func changePage(){
        var  offSet = CGPoint.zero
        
        var  newOffSetLength = self.offsetLength + self.unitLength // 累加而已
        
        //在换页到最后一个的时候多加一点距离，触发回到第一个图片的事件,即index=self.imagAry.count
        if newOffSetLength == self.contentLength - self.unitLength {
            newOffSetLength += 1
        }
        
        if scrollDirection == .qlBannerScrollHorizontal {
            offSet = CGPoint(x: newOffSetLength, y: 0)
        }else{
            offSet = CGPoint(x: 0,y: newOffSetLength)
        }
        
        bannerCollectionView.setContentOffset(offSet, animated: true)
        

    }
    
    
    
    // MARK: collectionView delegate
    // 不要这会包，collectionViewCell高度必须<= ...的错
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.isFromLocal) {
            return localImages.count + 1
        } else {
            return imageUrls.count + 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var  itemIndex = 0 // 因为 rows = self.imageAry.count + 1
        
        if isFromLocal { // 来自本地
            itemIndex = indexPath.item % localImages.count // 用item和row一样
//            pageControl.currentPage = (indexPath.row == localImages.count) ? 0 : indexPath.row
            pageControl.currentIndex = (indexPath.row == localImages.count) ? 0 : indexPath.row
        } else {   // 来自网络的图片
            itemIndex = indexPath.item % imageUrls.count
//            pageControl.currentPage = (indexPath.row == imageUrls.count) ? 0 : indexPath.row
            pageControl.currentIndex =  (indexPath.row == imageUrls.count) ? 0 : indexPath.row
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! QLBannerCollectionViewCell
        
        loadImageForImageView(cell.imageView, atIndex: itemIndex)
        
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        removeTimer()
        
        let time = DispatchTime.now() + Double(Int64(timeInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.addTimer()
        }
        
        if self.bannerDelegate != nil {
//            self.bannerDelegate.bannerView!(bannerView: self, didSelectAtIndex: pageControl.currentPage)
            self.bannerDelegate.bannerView!(bannerView: self, didSelectAtIndex: pageControl.currentIndex)
        }
        

    }
    
    
    // MARK:  添加定时器
    @objc private func addTimer(){
        
        if timeInterval == 0 { // 必须要,确保滚动正常，滑动结束后会调此法,具体看下
            return
        }
        
        // 此处判断传过来的图片数是否为0,为0则不加定时器
        if isFromLocal{
            if localImages.count == 0 {
                return
            }
        }else{
            if imageUrls.count == 0 {
                return
            }
        }
        
        
        if timer == nil {
            DispatchQueue.main.async(execute: {
                self.timer = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.changePage), userInfo: nil, repeats: true)
                 // 要此句，会导致，进入其他页面在进入含banner页时，有点小bug
                RunLoop.main.add(self.timer, forMode: .commonModes)
            })
        }
        
    }
    
    // MARK:  移除定时
    @objc private func removeTimer(){
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    
    
    // MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
         let collectionView =  scrollView as! UICollectionView
        
         switch (self.scrollDirection) {
            
         case .qlBannerScrollVertical:  //竖直滚动
            let  offsetY = collectionView.contentOffset.y
            
            // 2.求出页码/ 控制分页
            let  pageDouble = offsetY / collectionView.frame.size.height
            var  pageInt = 0
            if self.isFromLocal {
                pageInt = Int(pageDouble + 0.5) % (self.localImages.count)
            } else {
                pageInt = Int(pageDouble + 0.5) % (self.imageUrls.count)
            }
//            self.pageControl.currentPage = pageInt
            pageControl.currentIndex = pageInt
            //            (int)round(里面放double型)
            
            
         case .qlBannerScrollHorizontal:  //水平滚动
            let  offsetX = collectionView.contentOffset.x
            // 2.求出页码/ 控制分页
            let  pageDouble = offsetX / collectionView.frame.size.width
            var  pageInt = 0
            
            if (self.isFromLocal) {
                pageInt = Int(pageDouble + 0.5) % (self.localImages.count)
            }else{
                pageInt = Int(pageDouble + 0.5) % (self.imageUrls.count)
            }
            
//            self.pageControl.currentPage = pageInt
            pageControl.currentIndex = pageInt
            
        }
        
        if (self.oldOffsetLength > self.offsetLength) { // 右拖\下拖，oldOffset还是0 而offset<0,此时立即将当前的cell变为第self.imageArray.count个cell
            if (self.offsetLength < 0)
            {
                if (self.isFromLocal) {
                    collectionView.scrollToItem(at: IndexPath.init(row: localImages.count, section: 0), at: UICollectionViewScrollPosition(), animated: false)
                    
                } else {
                    collectionView.scrollToItem(at: IndexPath.init(row: imageUrls.count, section: 0), at: UICollectionViewScrollPosition(), animated: false)
                    
                }
            }
        }else{ // 最后一页，此时currentPage为0，即最后一页刚要出现时，立即将当前的cell变为第0个cell
            if (self.offsetLength > self.contentLength - self.unitLength) { // 到index = self.imageAry.count ，
                
                collectionView.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: UICollectionViewScrollPosition(), animated: false)
            }
        }
        
        self.oldOffsetLength = self.offsetLength
    }
    

    
    // MARK: 缓存图片
    private func loadImageForImageView(_ imageView:UIImageView, atIndex index:NSInteger){
        
        if (self.isFromLocal) { // 传的是本地图片
            let  obj = self.localImages[index]
            imageView.image = obj

        }else{ // 传的是网络的图片， url或string

            let urlStr = self.imageUrls[index]
            var url:URL!
            url = URL.init(string: urlStr)
            
            

            // 从缓存中获取图片，若无则下载并缓存
            let isImgCace = kImgManager.cache.isImageCached(forKey: urlStr) //kImgManager.cache.isImageCachedForKey(urlStr)
            
            if isImgCace.cached { // 说明图片已缓存过    Subscript下标
//                imageView.image = kImgManager.cache.retrieveImageInMemoryCacheForKey(urlStr) // 内存里
                
                imageView.image = kImgManager.cache.retrieveImageInDiskCache(forKey: urlStr) // 默认缓存到磁盘里
                
            } else { // 图片没有被缓存
                //先取消 再设置
                imageView.kf.cancelDownloadTask()
                
                
                imageView.kf.indicator?.startAnimatingView()
//                imageView.kf_showIndicatorWhenLoading = true // 显示菊花
                // 网络再次连接时会自动去加载图片
                imageView.kf.setImage(with: url, placeholder: placeholderImg, options: nil, progressBlock: { (receivedSize, totalSize) in
                    
                }, completionHandler: { image, error, cacheType, imageURL in
                    debugPrint("\(imageURL)缓存完毕！， 缓存类型为\(cacheType)")
                })
                
                
                
            }
        }
        

        
    }
    
    
    // MARK:  清除缓存  默认缓存在磁盘disk里
    func clearTmpPictures(){
        kImgManager.cache.clearDiskCache()
        kImgManager.cache.clearMemoryCache()
    }
    
    deinit{
        debugPrint("banner deInit了")
    }
}
