//
//  MySystemRequest.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/15.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit

class MySystemRequest: NSObject {

    let request = NSMutableURLRequest.init()
    let session = NSURLSession.sharedSession()
//    let task = NSURLSessionDataTask.init()
    let operationQueue = NSOperationQueue.init()
    
    
    private let queueName = "operationQueue_system_01"
    override init() {
        super.init()
        
        
    }
    
    private func defaultSets(){
        request.timeoutInterval = 30
        request.allHTTPHeaderFields = ["":""]
        
        operationQueue.name = queueName
        
    }
    
    func get(withPath path:String, params:[String:AnyObject], completeHandler:Selector)  {
        
        let url = NSURL.init(string: path)
        if url == nil {
            debugPrint("GET请求，url有误！")
            return
        }
        
        request.HTTPMethod = "GET"
        request.URL = url
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            
        })
        
        // 开始
        operationQueue.addOperationWithBlock { 
            task.resume()
        }
        
        
        
    }
    
    
    func cancleAllRequest()  {
            operationQueue.cancelAllOperations()
    }
    
    func cancleCurrentRequest() {
            
    }
    
    // ------------------------- private ---------------- //
    
    
    
}
