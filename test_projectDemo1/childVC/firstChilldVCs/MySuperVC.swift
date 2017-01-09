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
    
    convenience init(){
        self.init(nibName: "MySuperVC",bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // top和topscroller的高度一样
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 44, 0)
        
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        tableView.mj_header.ignoredScrollViewContentInsetTop = 20 // 调整刷新控件位置, 必须设置了contentInset.top后此属性才有用
        tableView.mj_header.beginRefreshing()
        
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
        tableView.mj_footer.isHidden = true // 开始时隐藏上拉
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) // kCATransitionFade  kCATransitionPush kCATransitionReveal kCATransitionMoveIn
        
        self.view.transitionWithType(AnimationType.RippleEffect.rawValue, withSubType: kCATransitionReveal, forView: self.view)
    }
    
    @objc fileprivate func refreshAction(){
        let time = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.tableView.mj_header.endRefreshing()
        }
        
        
    }
    
    @objc fileprivate func loadMoreData(){
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var  cell = tableView.dequeueReusableCell(withIdentifier: cellIdenty)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellIdenty)
            cell?.textLabel?.textAlignment = .center
        }
        cell?.textLabel?.text = "第\(indexPath.row)条数据"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIViewController.init()
        vc.view.backgroundColor = UIColor.red
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


