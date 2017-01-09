//
//  MyGifWebView.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/8.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  1. 自从iOS8开始,Apple引入了WKWebView欲代替UIWebView。相比而言,WKWebView消耗内从更少,功能也更加强大
//  2.

import UIKit
import WebKit


class MyGifWebView: UIWebView {

    // MARK: 单例, static:表示类用
    fileprivate static let webView = MyGifWebView()
    static let shareInstance:MyGifWebView = {
        return webView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
}
