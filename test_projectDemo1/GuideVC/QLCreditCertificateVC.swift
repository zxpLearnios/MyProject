//
//  QLCreditCertificateVC.swift
//  QTimelyLoan
//
//  Created by Jingnan Zhang on 16/9/20.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  

import UIKit

class QLCreditCertificateVC: UITableViewController {

    
    var isForLow = false // 是否用于低风险
    private let cellid = "QLCreditCertificateCell"
    private let headCellid = "QLCreditCertificateHeadCell"
    
    private let rows = [[2, 5], [2, 4, 2]]
    private let isMustEdits = [[true, false], [true, true,false]]
    private let fontTexts = [["\u{e60a}", "\u{e60b}"], ["\u{e60a}", "\u{e60a}", "\u{e60b}"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup(){
//        self.view.backgroundColor = kviewBgColor
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0)
        self.tableView.registerNib(UINib.init(nibName: headCellid, bundle: nil), forCellReuseIdentifier: headCellid)
        
        self.tableView.registerNib(UINib.init(nibName: cellid, bundle: nil), forCellReuseIdentifier: cellid)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (isForLow) ? 2 : 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isForLow {
           return rows[0][section]
        }
        return rows[1][section]
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
             let cell = tableView.dequeueReusableCellWithIdentifier(headCellid, forIndexPath: indexPath)
//            if isForLow {
////                cell.isMustEdit = isMustEdits[0][indexPath.section]
////                cell.iconLab.text = fontTexts[0][indexPath.section]
//            }else{
////                cell.isMustEdit = isMustEdits[1][indexPath.section]
////                cell.iconLab.text = fontTexts[1][indexPath.section]
//            }
            
            
              return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellid, forIndexPath: indexPath)
        if isForLow {
//            cell.separateLab.hidden = (indexPath.row == rows[0][indexPath.section] - 1) ? true : false
        }else{
//            cell.separateLab.hidden = (indexPath.row == rows[1][indexPath.section] - 1) ? true : false
        }
        
        return cell
      
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        }
        return  110
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 20
    }
    // 有之就不会出现 header悬浮了, 此时未设置颜色，故header的颜色与当前view的背景色一样
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        return header
    }
    
}
