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
    
//    var imgVScrollers = [UIScrollView]() // 存放和图片一样大小的scroller， 由于他的zoom属性之后用
    var currentImgVScroller:UIScrollView!
    
    var scrollerCountLab:UILabel!
    
     var scroller:UIScrollView!
    
     fileprivate var scale:CGFloat = 0
    
    var images = [UIImage](){
        
        didSet{
            doInitImageViews()
        }
        
    }
    
    
    // MARK: 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    // MARK: 根据图片来添加ImageView
    fileprivate func doInitImageViews(){
    
        let imgWH:CGFloat = 60
        let padding = (self.frame.size.width - 3*60) / 4
        
        for i in 0..<images.count {
            // 注意此处最好不要用FI，因为swift float可以对float求余了，float(1)/Int(3) = 0.3333的
//            let FI = CGFloat(i)
            
            let imgV = UIImageView()
            imgV.frame = CGRect(x: padding + (padding + imgWH) * CGFloat(i % 3) ,  y: 50 + ((padding + imgWH) * CGFloat(i / 3)), width: imgWH, height: imgWH)
            imgV.image = images[i]
            imgV.tag = i
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
            imgV.isUserInteractionEnabled = true
            imgV.addGestureRecognizer(tap)
            
            imageViews.append(imgV)
            self.addSubview(imgV)
            
        }
        
        
    }
    
    // 和图片一样大小的scroller
    fileprivate  var imgVScrollers = [UIScrollView]()
    
    // MARK: 点击view里的图片
    @objc fileprivate func tapAction(_ tap:UITapGestureRecognizer) {
        
        let tapImgV = tap.view as! UIImageView
        currentTapImageView = tapImgV
        
      
        if scroller == nil {
            scroller = UIScrollView.init(frame: kbounds)
            scroller.isPagingEnabled = true
            scroller.zoomScale = scroller.minimumZoomScale
         
            scrollerCountLab = UILabel()
            scrollerCountLab.font = UIFont.systemFont(ofSize: 30)
            scrollerCountLab.textColor = UIColor.red
            scrollerCountLab.textAlignment = .center
            scrollerCountLab.bounds =  CGRect(x: 0, y: 0, width: scroller.frame.width, height: 30)
            scrollerCountLab.center = CGPoint(x: scroller.center.x, y: scroller.frame.height - 40)
           
        }
        
        // 0.
        scrollerImageViews.removeAll()
//        if imgVScrollers.count != 0 {
//            imgVScrollers.removeAll()
//        }
        
        // 1.
        scroller.contentSize = CGSize(width: scroller.frame.width * CGFloat(images.count), height: 0)
        
        // 2. 
        for subV in scroller.subviews {
            subV.removeFromSuperview()
        }
        
        // 2.1
        var ary = [UIScrollView]()
        let imgWH:CGFloat = 60
        let padding = (self.frame.size.width - 3*60) / 4
        
//        for i in 0..<images.count {
//            // 注意此处最好不要用FI，因为swift float可以对float求余了，float(1)/Int(3) = 0.3333的
//            //            let FI = CGFloat(i)
//            
//            let imgVScroller = UIScrollView()
//            imgVScroller.delegate = self
//            imgVScroller.multipleTouchEnabled = true
//            imgVScroller.minimumZoomScale = 1.0
//            imgVScroller.maximumZoomScale = 2.5
//            
//            imgVScroller.frame = CGRectMake(padding + (padding + imgWH) * CGFloat(i % 3) ,  50 + ((padding + imgWH) * CGFloat(i / 3)), imgWH, imgWH)
//            imgVScroller.tag = i
//            ary.append(imgVScroller)
//            scroller.addSubview(imgVScroller)
//        }
        
        
        
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
            
            imgV.bounds = CGRect(x: 0,  y: 0, width: imgVW, height: imgVH)
            imgV.center = CGPoint(x: scroller.frame.width * CGFloat(i) + scroller.center.x, y: scroller.center.y)
            
            
            
            
            scroller.addSubview(imgV)
            
            scrollerImageViews.append(imgV)
            
            if tapImgV.tag == imgV.tag { // scroller将要显示的图片
                currentScrollerImageView = imgV
            }
            
        }
        
        // 4
        scroller.isPagingEnabled = true
        scroller.delegate = self
         scroller.isUserInteractionEnabled = true
        scroller.backgroundColor = UIColor.white
        // 滚动至需要显示的图片处
        scroller.setContentOffset(CGPoint(x: kwidth * CGFloat(tapImgV.tag), y: 0), animated: false)
        scroller.frame = kbounds
        
        kwindow?.addSubview(scroller)
        scroller.superview!.addSubview(scrollerCountLab)
    
        
        // 5. 手势
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapScrollerAction))
        // 捏合
        let pinch = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchScrollerAction))
        
        let rotate = UIRotationGestureRecognizer.init(target: self, action: #selector(rotateScrollerAction))
        
        scroller.addGestureRecognizer(tap)
//        scroller.addGestureRecognizer(pinch)
//        scroller.addGestureRecognizer(rotate)
        
    }
    
    
    // MARK: 点击scroller上的图片
    @objc fileprivate func tapScrollerAction(_ tap:UITapGestureRecognizer) {
        scroller.isUserInteractionEnabled = false
        
        let currentScrollerImageViewFrame = currentScrollerImageView.frame
        currentScrollerImageView.removeFromSuperview()
        
        // 安按照她在scroller上的位置加到view上一样的位置
        self.addSubview(currentScrollerImageView)
        currentScrollerImageView.frame = CGRect(x: 0, y: currentScrollerImageViewFrame.origin.y, width: currentScrollerImageViewFrame.width, height: currentScrollerImageViewFrame.height)
        
        //        scroller.zoomToRect(CGRectMake(10, 10, 100, 100), animated: true)
        //        self.scroller.setZoomScale(self.scroller.minimumZoomScale, animated: true)
        
        UIView.animate(withDuration: 1, animations: {
            self.scroller.backgroundColor = UIColor.clear
            self.currentScrollerImageView.frame = self.currentTapImageView.frame
        }, completion: { (fl) in
            self.scrollerCountLab.removeFromSuperview()
            self.scroller.removeFromSuperview()
            self.scroller.addSubview(self.currentScrollerImageView)
        }) 

    }
    
   
    
    // MARK: 捏合scroller上的图片
    @objc fileprivate func pinchScrollerAction(_ pinch:UIPinchGestureRecognizer){
            debugPrint(pinch.scale)
    
        var scale = pinch.scale
        
        let currentScrollerImageViewW = currentScrollerImageView.frame.width
        let currentScrollerImageViewH = currentScrollerImageView.frame.height
        
        let transform = currentTapImageView.transform
        
        switch pinch.state {
            
        case .changed:
            
            if self.scale == 0 {
                currentScrollerImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            }else{
                
                if pinch.scale < 1 {
                    let x = abs(self.scale - (1 - pinch.scale))
                    currentScrollerImageView.transform = CGAffineTransform(scaleX: x, y: x)
                }else{
                    
                    let x = self.scale + (pinch.scale - 1)
                    currentScrollerImageView.transform = CGAffineTransform(scaleX: x, y: x)
                }
                
            }
//            scroller.setZoomScale(scale, animated: false)
        case .ended:
            
            if scale <= 0.5 { // 最小倍数
                scale = 0.5
            }else if scale >= 1.5 { // 最大倍数
                scale = 1.5
            }else{
                
            }
            
            self.scale = scale
            
            currentScrollerImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
//            currentTapImageView.bounds = CGRectMake(0, 0, currentScrollerImageViewW * scale, currentScrollerImageViewH * scale)
            
        default:
            break
        }
        
        
        
    }
    
    // MARK: 旋转scroller上的图片
    @objc fileprivate func rotateScrollerAction(_ rotate:UIRotationGestureRecognizer){
    
        
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        self.scrollViewDidEndScrollingAnimation(scrollView)
        
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        scrollerCountLab.text = String(format: "%d/%d", page, images.count)
        
       
    }
    
    // 用户滚动结束后
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    //   系统自动滚动结束后
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
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
        
//        let scaleImgV = imageViews[currentImgVScroller.tag]
//        scaleImgV.frame = CGRectMake(0, 0, 50, 50)
        
    }
    
    
    // MARK: 
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        currentImgVScroller = scrollView
    }
    
    // MARK:  需要
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scroller != scrollView {
            return currentScrollerImageView
        }
        return nil
    }

    
}




