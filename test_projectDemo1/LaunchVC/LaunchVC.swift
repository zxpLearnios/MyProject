//
//  LaunchVC.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/5/31.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//   启动控制器

// -1. { 若将LaunchScreen.SB变为LaunchImage，须将1‘ LaunchScreen.SB 的use as LaunchImage取消， 2’在target里选中LaunchImage Source 选择new（或自己已建的image。xcaset）里的Brand Assets往里放图片即可，3‘若要延长LaunchImage的显示时间，只需在首个显示的控制器里加入sleep(3)即可 4'可以将 Brand Assets重命名}
//  0:{ 自定义的启动控制器, 1. 自己加的控制器xib、SB都不能成为启动控制器，只能用LaunchScreen.SB、Main.SB
//      2. 调整target的启动控制器没用    3. 需要设置自定义的启动控制器为启动时的画面且为rootviewController
//      4. 使用UIDynamicAnimator  }

import UIKit

class LaunchVC: UIViewController {

    let imgV  = UIImageView.init()
    var  dy:UIDynamicAnimator!
    var  ga:UIGravityBehavior!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        sleep(5)
        imgV.frame = CGRectMake(0, kheight * 0.75, 50, 20) //
//        imgV.image = UIImage.init(contentsOfFile: "xx.png") // 此法只会加载图片一次，故引导图用此法
        imgV.image = UIImage(named: "流星") // 此法会将所加载的图片进行缓存
        self.view.addSubview(imgV)
        
        
        dy = UIDynamicAnimator.init(referenceView: self.view)
        ga = UIGravityBehavior.init(items: [imgV])
        ga.gravityDirection = CGVectorMake(1, -0.323)
        ga.magnitude = 3
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
             self.dy.addBehavior(self.ga)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 测试
//        hud.showSuccessText("成功彩色法尔", successImage: UIImage(named: "progress_circular")!)
    }

}
