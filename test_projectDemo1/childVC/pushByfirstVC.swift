//
//  pushByfirstVC.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/5/30.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit
import PullToRefreshKit


class pushByfirstVC: UITableViewController {
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "pushByFirstVC"
        self.tableView.separatorStyle = .None
        
        
//        self.tableView.setUpHeaderRefresh { 
//            
//        }
//        self.tableView.beginHeaderRefreshing()
    }
    
       
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
}
