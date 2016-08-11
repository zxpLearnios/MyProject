//
//  xx.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/8.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  加载gif的速度慢于UIImageView，但性能比它好；不知道为啥，swift中的webView加载本地gif时，四边总有间隙，故没法用

import UIKit


extension UIWebView{

    /**
     使用时，让自己的frame <= gif的frame以便可以填满
     */
    func loadGif(withGifName name:String) {
        
        let gifurl = NSBundle.mainBundle().URLForResource(name, withExtension: "gif")
        
        if  gifurl == nil {
            return
        }
        
        // 读取gif数据
        let gifData = NSData.init(contentsOfURL: gifurl!)
        
        //取消回弹效果
        self.scrollView.bounces = false
        self.userInteractionEnabled = false
        
        // 设置缩放模式
        self.scalesPageToFit = true
//        self.gapBetweenPages = 0
//        self.pageLength = 0
//        self.paginationMode = .Unpaginated
        
        // 用webView加载数据
        let textEncodingName = "" // "UTF-8"
        let baseUrl = NSURL.init(string: "")! // NSBundle.mainBundle().bundleURL
        self.loadData(gifData!, MIMEType: "image/gif", textEncodingName: textEncodingName, baseURL: baseUrl)
    
    }

}

