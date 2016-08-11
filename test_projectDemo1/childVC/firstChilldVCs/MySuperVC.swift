//
//  MySuperVC.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/6/3.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  必须加为首页的子控制器！

import UIKit
import MJRefresh

class MySuperVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let cellIdenty = "cellId"
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // top和topscroller的高度一样
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 44, 0)
        
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        tableView.mj_header.ignoredScrollViewContentInsetTop = 20 // 调整刷新控件位置, 必须设置了contentInset.top后此属性才有用
        tableView.mj_header.beginRefreshing()
        
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
        tableView.mj_footer.hidden = true // 开始时隐藏上拉
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated) // kCATransitionFade  kCATransitionPush kCATransitionReveal kCATransitionMoveIn
        
        self.view.transitionWithType(AnimationType.RippleEffect.rawValue, withSubType: kCATransitionReveal, forView: self.view)
    }
    
    @objc private func refreshAction(){
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.tableView.mj_header.endRefreshing()
        }
        
        
    }
    
    @objc private func loadMoreData(){
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var  cell = tableView.dequeueReusableCellWithIdentifier(cellIdenty)
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: cellIdenty)
            cell?.textLabel?.textAlignment = .Center
        }
        cell?.textLabel?.text = "第\(indexPath.row)条数据"
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = UIViewController.init()
        vc.view.backgroundColor = UIColor.redColor()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


