
//
//  MyPhotoBrowserCollectionView.swift
//  test_projectDemo1
//  

/**
 * 图片浏览器的对外部分，外部初始化之即可
 * 1. 功能：图片缩放、双击、单击
 * 2. 其他：动画展示显示与隐藏，弄一动画图片来实现展示时的放大效果之后再讲图片浏览器加到自己身上即可
 **/

class MyPhotoBrowserController: UIViewController, UIScrollViewDelegate, MyPhotoBrowserCollectionViewControllerDelegate{

    private var imageViews = [UIImageView]() // 自己里的
    private var currentTapImageView :UIImageView! // view里的
    private var browserVC:MyPhotoBrowserCollectionViewController! // 点击view里的图片后，由此来滑动展示所有的图片
    private let animateTime = 0.5

    var images = [UIImage](){
        didSet{
            doInitImageViews()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
    }
    

    // MARK: 根据图片来添加ImageView
    private func doInitImageViews(){

        let imgWH:CGFloat = 60
        let padding = (self.view.frame.size.width - 3*60) / 4

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
            self.view.addSubview(imgV)

        }


    }

    // MARK: 点击view里的图片
    @objc private func tapAction(_ tap:UITapGestureRecognizer) {

        let tapImgV = tap.view as! UIImageView
        // 当前点击的图片
        currentTapImageView = tapImgV
        let point = CGPoint(x: kwidth * CGFloat(tapImgV.tag), y: 0)
        addAnimateImageView(point)
    }

    // MARK:  添加动画放大的imageView, 动画结束后，再加图片浏览器即可
    private func addAnimateImageView(_ point:CGPoint){
        // 背景色由透明渐变为灰
        let bgView = UIView.init(frame: kbounds)
        bgView.backgroundColor = UIColor.clear
        
        let newImageV = UIImageView.init(image: currentTapImageView.image!)
        newImageV.frame = currentTapImageView.frame
        
        self.view.addSubview(bgView)
        self.view.addSubview(newImageV)
        newImageV.removeFromSuperview()
        
        // 映射frame
        let newImgVFrame = calculateIamgeViewWith(newImageV.image!)
        self.view.addSubview(newImageV)
        
        UIView.animate(withDuration: animateTime, animations: {
            bgView.backgroundColor = UIColor.lightGray // 和图片浏览器的cell的背景色一致
            newImageV.frame = newImgVFrame
        }, completion: { (fl) in
            bgView.removeFromSuperview()
            newImageV.removeFromSuperview()
            // 加图片浏览器
            self.showPhotoBrowserCollectionVCWithPoint(point)
        })
        
        
    }
    
    
    
    // MARK:  点击时来动画显示 图片浏览器的浏览
    // 展示
    private func showPhotoBrowserCollectionVCWithPoint(_ point:CGPoint){
        
        // 初始化并设置代理
        browserVC = MyPhotoBrowserCollectionViewController.initWithImages(images, contentOffset: point, tapImageView: currentTapImageView)
        browserVC.browserDelegate = self
        // 必须设置大小
        browserVC.view.frame = kbounds
        // 添加子控制器，保住其生命及
        self.view.addSubview(browserVC.view)
        self.addChildViewController(browserVC)
        
    }
    
    
    // MARK: MyPhotoBrowserCollectionViewDelegate
    // 此VC即相当于browserVC, 消失
    func didClickCell(_ cell: MyPhotoBrowserCollectionViewCell) {
        currentTapImageView = imageViews[cell.tag]
        
         cell.backgroundColor = UIColor.clear
//        browserVC.view.backgroundColor = UIColor.clear
        browserVC.view.isUserInteractionEnabled = false
        
        let  currentImgV = cell.imageView!
        
        // 转换坐标系
        let frame = cell.convert(currentImgV.frame, to: self.view)
        currentImgV.removeFromSuperview()
        
        // 有这两句，就有了 点击图片还原时可以看到其他所有图片的效果了；这两句不要放在最前面，以保证 前面的frame 的准确性
        browserVC.view.removeFromSuperview()
        browserVC.removeFromParentViewController()
        
        // 按照她在scroller上的位置加到view上一样的位置
        self.view.addSubview(currentImgV)
        currentImgV.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height)
        
        // 执行消失动画
        UIView.animate(withDuration: animateTime, animations: {
            
            currentImgV.frame = self.currentTapImageView.frame
            
        }, completion: { (fl) in
            cell.scrollView.addSubview(currentImgV)
            
            self.browserVC.countLab.removeFromSuperview()
            self.browserVC.view.isUserInteractionEnabled = true
            // 从父控制器里移除
            self.browserVC.view.removeFromSuperview()
            self.browserVC.removeFromParentViewController()
            
        })
        
    }
    
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

// -------------------------  private ------------------------------ //
    // MARK:  此法和MyPhotoBrowserScrollView 里的计算图片大小的是一样的
    private func calculateIamgeViewWith(_ image:UIImage) -> CGRect {
        
        var imageViewFrame = CGRect.zero
        var imgVW:CGFloat = 0
        var imgVH:CGFloat = 0
        
        // 根据图片尺寸确定ImgV的大小
        let imageW = image.size.width
        let imageH = image.size.height
        
        if imageW >= imageH { // 图片宽 >= 高
            
            if imageW > self.view.frame.width { // 图片比屏幕宽
                imgVW = self.view.frame.width
            }else{
                imgVW = imageW // 此时按原图展示
            }
            
            imgVH = imgVW / (imageW / imageH)
        }else{ // 图片宽 < 高
            
            if imageH > self.view.frame.height {  // 图片比屏幕高
                imgVH = self.view.frame.height
            }else{
                imgVH = imageH // 此时按原图展示
            }
            
            imgVW = imgVH / (imageH / imageW)
        }
        
        let bounds = CGRect(x: 0,  y: 0, width: imgVW, height: imgVH)
        let center = CGPoint.init(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        let x:CGFloat = center.x - bounds.width/2
        let y:CGFloat = center.y - bounds.height/2
        
        imageViewFrame = CGRect.init(x: x, y: y, width: bounds.width, height: bounds.height)
        
        return imageViewFrame
    }
    

    
}




