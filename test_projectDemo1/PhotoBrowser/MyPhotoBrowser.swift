//
//  MyPhotoBrowser.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/9/8.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit

class MyPhotoBrowser: UIView, UIScrollViewDelegate{

    var imageViews = [UIImageView]()
    var scrollerImageViews = [UIImageView]()
    
    var scroller:UIScrollView!
    
    
    var currentImageView :UIImageView!
    var tapImageView :UIImageView!
    
    
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
    
    @objc private func tapAction(tap:UITapGestureRecognizer) {
        
        let tapImgV = tap.view as! UIImageView
        tapImageView = tapImgV
        
       let imgWH = kwidth
        
        if scroller == nil {
            
            scroller = UIScrollView.init(frame: kbounds)
            scroller.pagingEnabled = true
            scroller.zoomScale = scroller.minimumZoomScale
           
            
        }
        
        scrollerImageViews.removeAll()
        // 1.
        scroller.contentSize = CGSizeMake(imgWH * CGFloat(images.count), 0)
        
        // 2. 
        for subV in scroller.subviews {
            subV.removeFromSuperview()
        }
        
        // 3.
        for i in 0..<images.count {
            
            let imgV = UIImageView()
            imgV.frame = CGRectMake(imgWH * CGFloat(i),  100, imgWH, imgWH)
            imgV.tag = i
            imgV.image = images[i]
            
            let coverBtn = UIButton()
            coverBtn.frame = CGRectMake(scroller.frame.width * CGFloat(i),  0, scroller.frame.width, scroller.frame.height)
            coverBtn.addTarget(self, action:  #selector(converBtnAction), forControlEvents: .TouchUpInside)
            
            scroller.addSubview(imgV)
            scroller.addSubview(coverBtn)
            scrollerImageViews.append(imgV)
            
            if tapImgV.tag == imgV.tag {
                currentImageView = imgV
            }
            
        }
        
        // 4
        scroller.delegate = self
         scroller.userInteractionEnabled = true
        scroller.backgroundColor = UIColor.whiteColor()
        scroller.setContentOffset(CGPointMake(kwidth * CGFloat(tapImgV.tag), 0), animated: false)
        scroller.frame = kbounds
        kwindow?.addSubview(scroller)
        
     
    
    }
    
    
    @objc private func converBtnAction(btn:UIButton) {
        scroller.userInteractionEnabled = false
        
        let currentImageViewFrame = currentImageView.frame
        
        currentImageView.removeFromSuperview()
        self.addSubview(currentImageView)
        currentImageView.frame = CGRectMake(0, currentImageViewFrame.origin.y, currentImageViewFrame.width, currentImageViewFrame.height)
        
//        scroller.zoomToRect(CGRectMake(10, 10, 100, 100), animated: true)
//        self.scroller.setZoomScale(self.scroller.minimumZoomScale, animated: true)
    
        UIView.animateWithDuration(1, animations: { 
            self.scroller.backgroundColor = UIColor.clearColor()
            self.currentImageView.frame = self.tapImageView.frame
            }) { (fl) in
             self.scroller.removeFromSuperview()
            self.scroller.addSubview(self.currentImageView)
        }
        
    
        
//        let ani = CABasicAnimation.init(keyPath: "bounds")
//        ani.duration = 1
//        ani.delegate = self
//        
//        ani.toValue = NSValue.init(CGRect: currentImageView.bounds)
//
//        let layer = currentImageView.layer // imageViews[Int(currentIndex)].layer
//        layer.addAnimation(ani, forKey: "ani_k")
        
        
    }
    
        
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag {
            let layer =  currentImageView.layer
            layer.removeAllAnimations()
            
            scroller.backgroundColor = UIColor.clearColor()
            scroller.removeFromSuperview()
        }
        
    }
    
    
    func currentImageFrame(currentIndex:Int) -> CGRect {
        let cImg = imageViews[currentIndex]
         return convertRect(cImg.frame, fromView: self)
    }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
    }
    
    
    // 用户滚动结束后
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        self.scrollViewDidEndScrollingAnimation(scrollView)
        
    }
    
    //   系统自动滚动结束后
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        currentImageView = scrollerImageViews[page]
        tapImageView = imageViews[page]
    }
    
    
}



//class MyPBScroller: UIScrollView {
//    
//    weak var relationalView:MyPhotoBrowser!
//    
//    var imageViews = [UIImageView]()
//    
//    var currentImageView = UIImageView()
//    
//    var images = [UIImage](){
//        
//        didSet{
//            doInitImageViews()
//        }
//        
//    }
//    
//    convenience init(withRelationalView view:MyPhotoBrowser){
//        self.init()
//        self.showsHorizontalScrollIndicator = false
//        self.pagingEnabled = true
//        self.relationalView = view
//    }
//    
//    var currentIndex:CGFloat = -1{
//        didSet{
//            self.setContentOffset(CGPointMake(currentIndex * self.frame.size.width, 0), animated: false)
//        }
//    }
//    
//    
//    
//    private func doInitImageViews(){
//        
//        let imgWH:CGFloat = self.frame.width
//
//        self.contentSize = CGSizeMake(imgWH * CGFloat(images.count), 0)
//        
//        for i in 0..<images.count {
//            
//            let imgV = UIImageView()
//            imgV.frame = CGRectMake(imgWH * CGFloat(i),  100, imgWH, imgWH)
//            imgV.tag = i
//            imgV.image = images[i]
//            
//            let coverBtn = UIButton()
//            coverBtn.frame = CGRectMake(self.frame.width * CGFloat(i),  0, self.frame.width, self.frame.height)
//            coverBtn.addTarget(self, action:  #selector(tapAction), forControlEvents: .TouchUpInside)
//            
//            imageViews.append(imgV)
//            self.addSubview(imgV)
//            self.addSubview(coverBtn)
//        }
//        
//        
//    }
//    
//    @objc private func tapAction(btn:UIButton) {
//        
////        UIView.animateWithDuration(0.25, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 1, options: .CurveLinear, animations: { 
////                self.alpha = 0
////            
////            }, completion: nil)
//        
//        self.backgroundColor = UIColor.clearColor()
//        self.zoomToRect(<#T##rect: CGRect##CGRect#>, animated: <#T##Bool#>)
//        
////        let ani = CABasicAnimation.init(keyPath: "frame")
////        ani.duration = 1
////        ani.delegate = self
////        let toframe = self.relationalView.currentImageFrame(Int(currentIndex))
////        ani.toValue = NSValue.init(CGRect: toframe)
////        
////        let layer = self.layer // imageViews[Int(currentIndex)].layer
////        layer.addAnimation(ani, forKey: "ani_k")
//        
//    }
//    
//    
//    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
//        if flag {
//            let layer =  imageViews[Int(currentIndex)].layer
//            layer.removeAllAnimations()
//            
//            self.removeFromSuperview()
//        }
//        
//    }
//    
//}




