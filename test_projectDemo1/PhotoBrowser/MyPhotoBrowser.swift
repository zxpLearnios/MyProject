//
//  MyPhotoBrowser.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/9/8.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  图片浏览器

import UIKit

class MyPhotoBrowser: UIView, UIScrollViewDelegate{

    var imageViews = [UIImageView]()
    
    var scrollerImageViews = [UIImageView]() // scroller里的
    var currentScrollerImageView :UIImageView! // scroller里的
    var currentTapImageView :UIImageView! // view里的
    
    var scrollerCountLab:UILabel!
    
     var scroller:UIScrollView!
    
     private var scale:CGFloat = 0
    
    var images = [UIImage](){
        
        didSet{
            doInitImageViews()
        }
        
    }
    
    
    // MARK: 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGrayColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    // MARK: 根据图片来添加ImageView
    private func doInitImageViews(){
    
        let imgWH:CGFloat = 60
        let padding = (self.frame.size.width - 3*60) / 4
        
        for i in 0..<images.count {
            // 注意此处最好不要用FI，因为swift float可以对float求余了，float(1)/Int(3) = 0.3333的
//            let FI = CGFloat(i)
            
            let imgV = UIImageView()
            imgV.frame = CGRectMake(padding + (padding + imgWH) * CGFloat(i % 3) ,  50 + ((padding + imgWH) * CGFloat(i / 3)), imgWH, imgWH)
            imgV.image = images[i]
            imgV.tag = i
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
            imgV.userInteractionEnabled = true
            imgV.addGestureRecognizer(tap)
            
            imageViews.append(imgV)
            self.addSubview(imgV)
            
        }
        
        
    }
    
    // MARK: 点击view里的图片
    @objc private func tapAction(tap:UITapGestureRecognizer) {
        
        let tapImgV = tap.view as! UIImageView
        currentTapImageView = tapImgV
        
      
        if scroller == nil {
            scroller = UIScrollView.init(frame: kbounds)
            scroller.pagingEnabled = true
            scroller.zoomScale = scroller.minimumZoomScale
         
            scrollerCountLab = UILabel()
            scrollerCountLab.font = UIFont.systemFontOfSize(30)
            scrollerCountLab.textColor = UIColor.redColor()
            scrollerCountLab.textAlignment = .Center
            scrollerCountLab.bounds =  CGRectMake(0, 0, scroller.frame.width, 30)
            scrollerCountLab.center = CGPointMake(scroller.center.x, scroller.frame.height - 40)
            
        }
        
        // 0.
        scrollerImageViews.removeAll()
        
        // 1.
        scroller.contentSize = CGSizeMake(scroller.frame.width * CGFloat(images.count), 0)
        
        // 2. 
        for subV in scroller.subviews {
            subV.removeFromSuperview()
        }
        
        // 3.
        for i in 0..<images.count {
            
            let imgV = UIImageView()
            imgV.tag = i
            imgV.image = images[i]
            
            var imgVW:CGFloat = 0
            var imgVH:CGFloat = 0
            
            // 根据图片尺寸确定ImgV的大小
            let imageW = imgV.image!.size.width
            let imageH = imgV.image!.size.height
            
            if imageW >= imageH { // 图片宽 >= 高
                
                if imageW > scroller.frame.width { // 图片比屏幕宽
                    imgVW = scroller.frame.width
                }else{
                    imgVW = imageW // 此时按原图展示
                }
                
                imgVH = imgVW / (imageW / imageH)
            }else{ // 图片宽 < 高
                
                if imageH > scroller.frame.height {  // 图片比屏幕高
                    imgVH = scroller.frame.height
                }else{
                    imgVH = imageH // 此时按原图展示
                }
                
                imgVW = imgVH / (imageH / imageW)
            }
            
            imgV.bounds = CGRectMake(0,  0, imgVW, imgVH)
            imgV.center = CGPointMake(scroller.frame.width * CGFloat(i) + scroller.center.x, scroller.center.y)
            
//            let coverBtn = UIButton()
//            coverBtn.frame = CGRectMake(scroller.frame.width * CGFloat(i),  0, scroller.frame.width, scroller.frame.height)
//            coverBtn.addTarget(self, action:  #selector(converBtnAction), forControlEvents: .TouchUpInside)
            
            scroller.addSubview(imgV)
//            scroller.addSubview(coverBtn)
            scrollerImageViews.append(imgV)
            
            if tapImgV.tag == imgV.tag { // scroller将要显示的图片
                currentScrollerImageView = imgV
            }
            
        }
        
        // 4
        scroller.pagingEnabled = true
        scroller.delegate = self
         scroller.userInteractionEnabled = true
        scroller.backgroundColor = UIColor.whiteColor()
        // 滚动至需要显示的图片处
        scroller.setContentOffset(CGPointMake(kwidth * CGFloat(tapImgV.tag), 0), animated: false)
        scroller.frame = kbounds
        
        kwindow?.addSubview(scroller)
        scroller.superview!.addSubview(scrollerCountLab)
    
        // 5. 手势
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapScrollerAction))
        // 捏合
        let pinch = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchScrollerAction))
        
        let rotate = UIRotationGestureRecognizer.init(target: self, action: #selector(rotateScrollerAction))
        
        scroller.addGestureRecognizer(tap)
        scroller.addGestureRecognizer(pinch)
        scroller.addGestureRecognizer(rotate)
        
    }
    
    
    // MARK: 点击scroller上的图片
    @objc private func tapScrollerAction(tap:UITapGestureRecognizer) {
        scroller.userInteractionEnabled = false
        
        let currentScrollerImageViewFrame = currentScrollerImageView.frame
        currentScrollerImageView.removeFromSuperview()
        
        // 安按照她在scroller上的位置加到view上一样的位置
        self.addSubview(currentScrollerImageView)
        currentScrollerImageView.frame = CGRectMake(0, currentScrollerImageViewFrame.origin.y, currentScrollerImageViewFrame.width, currentScrollerImageViewFrame.height)
        
        //        scroller.zoomToRect(CGRectMake(10, 10, 100, 100), animated: true)
        //        self.scroller.setZoomScale(self.scroller.minimumZoomScale, animated: true)
        
        UIView.animateWithDuration(1, animations: {
            self.scroller.backgroundColor = UIColor.clearColor()
            self.currentScrollerImageView.frame = self.currentTapImageView.frame
        }) { (fl) in
            self.scrollerCountLab.removeFromSuperview()
            self.scroller.removeFromSuperview()
            self.scroller.addSubview(self.currentScrollerImageView)
        }

    }
    
   
    
    // MARK: 捏合scroller上的图片
    @objc private func pinchScrollerAction(pinch:UIPinchGestureRecognizer){
            debugPrint(pinch.scale)
    
        var scale = pinch.scale
        
        let currentScrollerImageViewW = currentScrollerImageView.frame.width
        let currentScrollerImageViewH = currentScrollerImageView.frame.height
        
        let transform = currentTapImageView.transform
        
        switch pinch.state {
            
        case .Changed:
            
            if self.scale == 0 {
                currentScrollerImageView.transform = CGAffineTransformMakeScale(scale, scale)
            }else{
                
                if pinch.scale < 1 {
                    let x = abs(self.scale - (1 - pinch.scale))
                    currentScrollerImageView.transform = CGAffineTransformMakeScale(x, x)
                }else{
                    
                    let x = self.scale + (pinch.scale - 1)
                    currentScrollerImageView.transform = CGAffineTransformMakeScale(x, x)
                }
                
            }
            
        case .Ended:
            
            if scale <= 0.5 { // 最小倍数
                scale = 0.5
            }else if scale >= 1.5 { // 最大倍数
                scale = 1.5
            }else{
                
            }
            
            self.scale = scale
            
            currentScrollerImageView.transform = CGAffineTransformMakeScale(scale, scale)
            
//            currentTapImageView.bounds = CGRectMake(0, 0, currentScrollerImageViewW * scale, currentScrollerImageViewH * scale)
            
        default:
            break
        }
        
        
        
    }
    
    // MARK: 旋转scroller上的图片
    @objc private func rotateScrollerAction(rotate:UIRotationGestureRecognizer){
    
        
    }
    
//    // MARK: scroller上的遮盖按钮的点击
//    @objc private func converBtnAction(btn:UIButton) {
//        scroller.userInteractionEnabled = false
//        
//        let currentScrollerImageViewFrame = currentScrollerImageView.frame
//        currentScrollerImageView.removeFromSuperview()
//        
//        // 安按照她在scroller上的位置加到view上一样的位置
//        self.addSubview(currentScrollerImageView)
//        currentScrollerImageView.frame = CGRectMake(0, currentScrollerImageViewFrame.origin.y, currentScrollerImageViewFrame.width, currentScrollerImageViewFrame.height)
//        
////        scroller.zoomToRect(CGRectMake(10, 10, 100, 100), animated: true)
////        self.scroller.setZoomScale(self.scroller.minimumZoomScale, animated: true)
//    
//        UIView.animateWithDuration(1, animations: { 
//            self.scroller.backgroundColor = UIColor.clearColor()
//            self.currentScrollerImageView.frame = self.currentTapImageView.frame
//            }) { (fl) in
//            self.scrollerCountLab.removeFromSuperview()
//             self.scroller.removeFromSuperview()
//            self.scroller.addSubview(self.currentScrollerImageView)
//        }
//        
//        
//    }
    
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //        self.scrollViewDidEndScrollingAnimation(scrollView)
        
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        scrollerCountLab.text = String(format: "%d/%d", page, images.count)
        
       
    }
    
    // 用户滚动结束后
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    //   系统自动滚动结束后
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        
//        let lastPage = kUserDefaults.integerForKey("currentPage")
        
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        
//        if page != lastPage {
//            NSUserDefaults.standardUserDefaults().setInteger(page, forKey: "currentPage")
//            NSUserDefaults.standardUserDefaults().synchronize()
//            currentScrollerImageView.transform = CGAffineTransformIdentity
//            
//        }
        
        // 更新scroller里的代码显示的ImgV以及所对应的view里的imgV
        currentScrollerImageView = scrollerImageViews[page]
        currentTapImageView = imageViews[page]
        
        scrollerCountLab.text = String(format: "%d/%d", page, images.count)
        
    }
    
    
}




