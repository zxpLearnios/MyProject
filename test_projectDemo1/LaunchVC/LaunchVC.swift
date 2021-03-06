//
//  LaunchVC.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/5/31.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//   启动控制器  使用UIDynamicAnimator  contentsOfFile加载本地图片

/* 
 0. 原来的情况： 若将LaunchScreen.SB变为LaunchImage，须将1‘ LaunchScreen.SB 的use as LaunchImage取消， 2’在target里选中LaunchImage Source 选择new（或自己已建的image。xcaset）里的Brand Assets往里放图片即可，3‘若要延长LaunchImage的显示时间，只需在首个显示的控制器里加入sleep(3)即可 4'可以将 Brand Assets重命名
 
 1. 新的情况：swift2 已经 不需要上面那种复杂的做法了，只需删除Main Interface,然后设置在target里选中LaunchImage Source 选择new（或自己已建的image。xcaset）里的Brand Assets往里放图片即可

2: 自定义的启动控制器时
      1. 调整target里的Main Interface 为自定义的控制器
      2. 之后再Appdelegate里设置其为rootviewController即可实现自定义启动控制器
      3. 若没有第二步的话，则启动之后的view总是有黑边 即边界处有些地方是黑的
 */


import UIKit

class LaunchVC: UIViewController {

    let imgV  = UIImageView.init()
    var  dy:UIDynamicAnimator!
    var  ga:UIGravityBehavior!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        sleep(5)
        imgV.frame = CGRect(x: 0, y: kheight * 0.75, width: 50, height: 20) //
        
        // 只加载一次 图像数据不会缓存(图片需拖入到 1.OC里Supporting Files文件夹中，  2. swift是***Tests（项目test）文件里，二不是.xcassets文件里)。因此对于较大的图片以及使用情况较少时，那就可以用该方法，降低内存消耗。.图片使用结束以后，直接释放掉，bu再继续占内存了。因此序列帧动画的内存问题用之就已经全部解决了。此法只会加载图片一次，故引导图用此法
//        imgV.animationImages = [UIImage]() // 帧动画图片
        
        
        imgV.image = UIImage(named: "流星") // 此法会将所加载的图片进行缓存
        self.view.addSubview(imgV)
        
        let fileName = Bundle.main.path(forResource: "contenImg", ofType: "png")
        let testImg = UIImage.init(contentsOfFile: fileName!)
        let testImgV = UIImageView.init(image: testImg)
        view.addSubview(testImgV)
        
        
        dy = UIDynamicAnimator.init(referenceView: self.view)
        ga = UIGravityBehavior.init(items: [imgV])
        ga.gravityDirection = CGVector(dx: 1, dy: -0.323)
        ga.magnitude = 3
        let time = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
             self.dy.addBehavior(self.ga)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 测试
//        hud.showSuccessText("成功彩色法尔", successImage: UIImage(named: "progress_circular")!)
    }
    

}
