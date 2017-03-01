//
//  xxx.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 2017/2/23.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
/* 1. 图片浏览器里用到的UIscrollview，利用其强大的功能实现图片的缩放  
   2. UIScrollView有苹果自带的api，进行图片的缩放非常简单，只需设置scrollView.minimumZoomScale = 0.5; // 设置最小缩放系数scrollView.maximumZoomScale = 2.0; //设置最大缩放系数 
       及实现代理方法function viewForZoomingInScrollView和scrollViewDidZoom即可
    3. 它的tag值在cell里赋的
    4. 将之禁止与用户交互，这样将它加入cell后，此cell的TableView或COllectionView就可以被点击，可以相应自身的didSelectRowAt、didSelectItemAt了。
    5. 在drawRect里加单击、双击手势或者在touchBegan里根据单击的count数类判断是单击还是双击
 
 {
 layoutSubviews方法：这个方法，默认没有做任何事情，需要子类进行重写
 setNeedsLayout方法： 标记为需要重新布局，异步调用layoutIfNeeded刷新布局，不立即刷新，但layoutSubviews一定会被调用
   layoutIfNeeded方法：如果，有需要刷新的标记，立即调用layoutSubviews进行布局（如果没有标记，不会调用layoutSubviews）
 }
 
*/

import UIKit

@objc protocol MyPhotoBrowserScrollViewDelegate {
    @objc optional func didClickPhotoBrowserScrollView(_ scrollView:MyPhotoBrowserScrollView)
}

class MyPhotoBrowserScrollView: UIScrollView, UIScrollViewDelegate {
    
    var imgView = UIImageView()
    weak var photoBrowserScrollViewDelegate:MyPhotoBrowserScrollViewDelegate!
    private var originImageViewFrame = CGRect.zero // 记录图片原来的frame，以便在缩放后的恢复
    
    private let animateTime = 0.2
    
    var image:UIImage! {
        didSet{
            addImageView()
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.delegate = self
        self.minimumZoomScale = 0.5 //设置最小缩放系数
        self.maximumZoomScale = 2.0 //设置最大缩放系数
        
//        self.isMultipleTouchEnabled = true
//        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.clear
        self.isScrollEnabled = true
        
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 单击  双击 手势
        let tapDouble = UITapGestureRecognizer.init(target: self, action: #selector(doubleTapAction))
        tapDouble.numberOfTapsRequired = 2
        
        let tapSingle = UITapGestureRecognizer.init(target: self, action: #selector(singleTapAction))
        
        //这行很关键，意思是只有当没有检测到doubleTapGestureRecognizer 或者 检测doubleTapGestureRecognizer失败，singleTapGestureRecognizer才有效
        tapSingle.require(toFail: tapDouble)
        
        self.addGestureRecognizer(tapSingle)
        self.addGestureRecognizer(tapDouble)
    }
    
     // ------------------ public ---------------- //
    // MARK:  复原
    func recoveryZoomScale() {
        if self.zoomScale != 1{
            self.zoomScale = 1.0
        }
        self.contentSize = CGSize.zero
        imgView.frame = originImageViewFrame
    }
    
    
    // ------------------ private ---------------- //
    
    // MARK:  单击
    @objc private func singleTapAction(){
        
        if photoBrowserScrollViewDelegate != nil {
            photoBrowserScrollViewDelegate.didClickPhotoBrowserScrollView!(self)
        }
//        debugPrint("图片浏览器上面的scroller的单击手势：\(tapSingle)")
    }
    
    // MARK:  双击
    @objc private func doubleTapAction(){
        
        if self.zoomScale != 1 { // 处于放大或缩小状态时，都复原
            UIView.animate(withDuration: animateTime, animations: {
                self.zoomScale = 1
            })
            
        }else{ // 让其放大
            UIView.animate(withDuration: animateTime, animations: {
                self.zoomScale = self.maximumZoomScale
            })
        }
//        debugPrint("图片浏览器上面的scroller的双击手势：\(tapDouble)")
    }
    
    private func addImageView(){
        imgView.image = image
        
        var imgVW:CGFloat = 0
        var imgVH:CGFloat = 0
        
        // 根据图片尺寸确定ImgV的大小
        let imageW = image.size.width
        let imageH = image.size.height
        
        
        if imageW >= imageH { // 图片宽 >= 高
            
            if imageW > self.frame.width { // 图片比屏幕宽
                imgVW = self.frame.width
            }else{
                imgVW = imageW // 此时按原图展示
            }
            
            imgVH = imgVW / (imageW / imageH)
        }else{ // 图片宽 < 高
            
            if imageH > self.frame.height {  // 图片比屏幕高
                imgVH = self.frame.height
            }else{
                imgVH = imageH // 此时按原图展示
            }
            
            imgVW = imgVH / (imageH / imageW)
        }
        
        imgView.bounds = CGRect(x: 0,  y: 0, width: imgVW, height: imgVH)
        imgView.center = CGPoint.init(x: self.frame.width / 2, y: self.frame.height / 2)
        self.addSubview(imgView)
        
        originImageViewFrame = imgView.frame
    }
    
    
    // MARK:  单击、双击手势
//    private override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = ((touches as NSSet).anyObject()) as! UITouch
//        
//        let count = touch.tapCount
//        
//        if count == 1{
//            // 取消双击
//            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(doubleTapAction), object: nil)
//            // 开始单击 这里必须延迟一会
//            self.perform(#selector(singleTapAction), with: nil, afterDelay: 0.1)
//        }else if count == 2{
//            // 取消单击
//            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(singleTapAction), object: nil)
//             // 开始双击
//            self.perform(#selector(doubleTapAction), with: nil, afterDelay: 0)
//        }
//    }
    
    // ---------------------UIScrollViewDelegate--------------------
    // MARK:  当scrollView缩放时，调用该方法。在缩放过程中，缩放过程中动态计算图片的frame，会多次调
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let photoX:CGFloat = (self.frame.width - imgView.frame.width) / 2
        let photoY:CGFloat = (self.frame.height - imgView.frame.height) / 2
            
        var photoF:CGRect = imgView.frame
        
        if photoX > 0 {
            photoF.origin.x = photoX
        }else {
            photoF.origin.x = 0
        }
        
        if (photoY > 0) {
            photoF.origin.y = photoY
        }else {
            photoF.origin.y = 0
        }
        
        imgView.frame = photoF
        
    }
    
    // MARK:  返回将要缩放的UIView对象。要执行多次
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.isScrollEnabled = true
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.isUserInteractionEnabled = true
//        scrollView.setZoomScale(scale, animated: false)
    }
    
    
}
