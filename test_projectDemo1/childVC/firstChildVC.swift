//
//  firstChildVC.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/5/30.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  1. 左右item 可以换成自定义的按钮  2. 可以根据scroller的滚动情况缩放了

import UIKit

class firstChildVC: UIViewController, UIScrollViewDelegate, MyTopScrollViewDelegate{
  
   var childVCIndexs = [NSInteger]()
    var isTapButtonScroll = false // 是否是点击了按钮滚动的
    var currentTapIndex = -1 // 当前点击的按钮索引
    var lastOffsetX:CGFloat = 0.0 // 最新偏移量
    
    let topScroller = MyTopScrollView()
    let contentScroller = UIScrollView()
    
    var rtvc:MyCustomTVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "push", style: .done, target: self, action: #selector(leftItemAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "更多", style: .plain, target: self, action: #selector(rightAction))
        
        // 顶部scroller
        self.setupTopScroller()
        
        // 内容scroller
        self.setupContentScroller()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rtvc = (kwindow?.rootViewController as? MyCustomTVC)
//        rtvc.addPlusButton()
        
        rtvc.plusBtn.frame = CGRect(x: 100, y: 0, width: 50, height: 50)
        
//            rtvc.tabBar.addSubview(rtvc.plusBtn)
//
//        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
//        dispatch_after(time, dispatch_get_main_queue()) {
//            self.rtvc.addPlusButton()
//        }
        
    }
    
    // scroller
    fileprivate func setupTopScroller(){
        topScroller.topScrollViewDelegate = self
        topScroller.frame = CGRect(x: 0, y: 64, width: kwidth, height: 20)
        view.addSubview(topScroller)
        
    }
    fileprivate func setupContentScroller(){
        // 1. 内容scroller和topScroller底部必须有所靠近，否则没有穿透效果
        let y:CGFloat =  64
        contentScroller.delegate = self
        contentScroller.bounces = false
        contentScroller.isPagingEnabled = true
        contentScroller.showsHorizontalScrollIndicator = false
        contentScroller.frame = CGRect(x: 0, y: y, width: kwidth, height: kheight - y)
        contentScroller.contentSize = CGSize(width: kwidth * CGFloat(topScroller.titles.count), height: 0)
        self.view.addSubview(contentScroller)
        self.view.bringSubview(toFront: topScroller)
        
        // 2. 必须加为childVC, 默认加的第一个子控制器
        topScroller.layoutIfNeeded() // 主动layOutSubViews
       scrollViewDidEndScrollingAnimation(contentScroller)
    }
    

    // MARK: 左边按钮点击
    func leftItemAction()  {
        
        let vc = testVC()
        
        
        let firstSubVC = self.childViewControllers[0]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func rightAction(){
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    // MARK: MyTopScrollViewDelegate
    func didSelectButtonAtIndex(_ index: NSInteger) {
         isTapButtonScroll = true
        let newI = CGFloat(index)
        contentScroller.setContentOffset(CGPoint(x: kwidth * newI, y: 0), animated: true)
    }
   
    // MARK: UIScrollViewDelegate
    // 1. 滚动时
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isTapButtonScroll = false // 必须设置回来
    }
    // 2.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isTapButtonScroll { // 点击按钮滚动的, 不处理，即不缩放等
            return
        }else{
            if scrollView.contentOffset.x <= 0 || scrollView.contentOffset.x >= scrollView.contentSize.width {
                return
            }
            
            // 滑动时 改变topScroller的按钮的颜色
            let shang = Int(scrollView.contentOffset.x / kwidth) // 页数
            let progress = scrollView.contentOffset.x / kwidth - CGFloat(shang) // 0.0 -- 1.0
            
             /** 1. 第一种做法 **/
//            let scale = scrollView.contentOffset.x / kwidth
//
//            // 获得需要操作的左边按钮
//            let leftBtn = topScroller.buttons[shang]
//            
//            // 获得需要操作的右边按钮
//            let rightIndex = shang + 1
//            
//            // 右边比例
//            let rightScale = scale - CGFloat(shang)
//            // 左边比例
//            let  leftScale = 1 - rightScale
//            var rightBtn:MyTopicButton?
//            
//            if rightIndex == topScroller.buttons.count {
//                rightBtn = nil
//            }else{
//                rightBtn = topScroller.buttons[rightIndex]
//            }
            // 设置比例
//            leftBtn.scale = leftScale
//            rightBtn!.scale = rightScale
            
            /** 2. 第二种做法 **/
            let scale = scrollView.contentOffset.x / kwidth
            // 右边缩放比例
            let rightScale = scale - CGFloat(shang)
            // 左边缩放比例
            let  leftScale = 1 - rightScale
            
            // 判断用户滑动方向
            if lastOffsetX < scrollView.contentOffset.x { // 用户向左滑动
                lastOffsetX = scrollView.contentOffset.x
                if shang == topScroller.buttons.count - 1 { // 当前是最后一页
                    return
                }
                print("用户向左滑动,当前的页数：\(shang)")
                
                let leftBtn = topScroller.buttons[shang] // 当前选中的按钮
                let rightBtn = topScroller.buttons[shang + 1]
                
                leftBtn.scale = leftScale
                rightBtn.scale = rightScale
                
            }else{ // 用户向右滑动
                lastOffsetX = scrollView.contentOffset.x
                print("用户向右滑动,当前的页数：\(shang)")
                
                let leftBtn = topScroller.buttons[shang]
                let rightBtn = topScroller.buttons[shang + 1] // 当前选中的按钮
                
                leftBtn.scale = leftScale
                rightBtn.scale = rightScale
            }
            
            
        }
        
    }
    
    // 3. 用户滚动结束后
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        self.scrollViewDidEndScrollingAnimation(scrollView)
       
    }
    
    //  3.1 系统自动滚动结束后
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        
        let page = Int(offsetX/kwidth)
       
        if !isTapButtonScroll { // 非点击topic按钮时的滚动
            topScroller.topButtonAction(topScroller.buttons[page])
        }else{
            topScroller.topButtonAction(topScroller.buttons[page])
        }
        
        // 加子控制器
        self.creatChildViewController(page)
        
        // 让其他按钮回到最初的状态, 此处不需要，因为已经在按钮的select属性里处理了
//        let currentBtn = topScroller.buttons[page]
//        for btn in topScroller.buttons {
//            if btn != currentBtn {
//                btn.scale = 0
//            }
//        }
    }
    
   
    
    // 创建子控制器, 实际中肯定是初始化了n个控制器，然后在合适的时候加为子控制器
    fileprivate func creatChildViewController(_ page:NSInteger){
        let newIndex = CGFloat(page)
        
        if childVCIndexs.count == 0 { // 默认加的子控制器
            let childVC = MySuperVC()
            childVC.view.frame = contentScroller.bounds
            contentScroller.addSubview(childVC.view)
            self.addChildViewController(childVC)
            
            childVCIndexs.append(page) //  childVCIndexs.append(0)
            
        }else{ // 之后加的子控制器
            
            // 1.
            let find = childVCIndexs.index(of: page)
            if find == nil {
                let childVC = MySuperVC()
                childVC.view.frame = CGRect(x: kwidth*newIndex, y: 0, width: kwidth, height: contentScroller.frame.height)
                contentScroller.addSubview(childVC.view)
                self.addChildViewController(childVC)
                
                childVCIndexs.append(page)
                
            }
            
            // == 1.
//            for _ in childVCIndexs {
//                let find = childVCIndexs.indexOf(page)
//                if find == nil {
//                    let childVC = MySuperVC()
//                    childVC.view.frame = CGRectMake(kwidth*newIndex, 0, kwidth, contentScroller.frame.height)
//                    contentScroller.addSubview(childVC.view)
//                    self.addChildViewController(childVC)
//                    
//                    childVCIndexs.append(page)
//
//                }
//            }
        }
        
    }
    
}
