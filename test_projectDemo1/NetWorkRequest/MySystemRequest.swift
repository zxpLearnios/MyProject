//
//  MySystemRequest.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/15.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  1. 当operation有多个任务的时候会自动分配多个线程并发执行, 多线程的使用
//   如果只有一个任务，会自动在主线程同步执行

import UIKit



class MySystemRequest: NSObject {

    var request:URLRequest!
    let session = URLSession.shared
    
    fileprivate var  currentTask:URLSessionDataTask!
    let operationQueue = OperationQueue.init()
    
    fileprivate let queueName = "operationQueue_system_01"
    
//    private struct completeAction{
//        static let completeAction = Selector.init("result")
//    }
    typealias  SucceedAction = (_ responseObject:AnyObject, _ code:String) -> ()
    typealias  FailedAction = (_ error:String, _ code:String) -> ()
    typealias CompletedAction = (_ responseObject:AnyObject, _ code:String) -> ()
    
    struct  CompletedStruct {
        var successAction:SucceedAction?
        let failAction:FailedAction?
    }
    
    enum ErrorCode: Int {
    
        case
        /** 超时 */
        kTimeOutErrorCode = -1001,
        /** 网络错误 */
        kConnectError = -1,
        /** 返回的不是字典类型 */
        kRequestErrorCodeNull = 32000,
        /** 返回的字典是空 */
        kRequestErrorCodeException = 32100,
        /** 成功 */
        kHTTP_200 = 200,
        /** 错误请求，请求参数错误 */
        kHTTP_400 = 400,
        /** 授权、未登录 */
        kHTTP_401 = 401,
        /** 未找到资源 */
        kHTTP_404 = 404,
        /** 请求方法错误 */
        kHTTP_405 = 405,
        /** 服务器内容错误 */
        kHTTP_500 = 500
    
    }
    
    enum RequestMethod:String {
        case get = "GET", post = "POST", delete = "DELETE", insert = "INSERT"
    }
    
    override init() {
        super.init()
        defaultSets()
    }
    
    fileprivate func defaultSets(){
        // 1.
        request.timeoutInterval = 30
        request.allHTTPHeaderFields = ["":""]
        // 缓存模式
        request.cachePolicy = .reloadIgnoringLocalCacheData
        // 设置http头部
        request.allHTTPHeaderFields = ["":""]
        
        // 2.
        operationQueue.name = queueName
        // 最大并发数量
        operationQueue.maxConcurrentOperationCount = 2
        
        
    }
    
    /**
     总的请求方法
     
     - parameter path:            路径
     - parameter params:          参数
     - parameter completeHandler: 回调
     */
    func request(byMethod method:RequestMethod, withPath path:String, params:[String:AnyObject], completeHandler: CompletedAction) ->  URLSessionTask? {
    
        
        // 1. 请求方式
        switch method {
            
        case .get:
            request.httpMethod = RequestMethod.get.rawValue
        case .post:
            request.httpMethod = RequestMethod.post.rawValue
        case .delete:
            request.httpMethod = RequestMethod.delete.rawValue
        case .insert:
            request.httpMethod = RequestMethod.insert.rawValue
            
            
        }

        
        // 2. url地址
        let url = URL.init(string: path)
        if url == nil {
            debugPrint("\(method)请求，url有误！")
            return nil
        }
        request.url = url
        
        // 3. task
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            // 5. 判断请求失败或成功
            //            let result = String.init(data: data!, encoding: NSUTF8StringEncoding)
            
            if  false { // 失败
                
                //                getFailResult(error!, code: "")
            }else{ // 成功
                //              let successObj = getSuccessResutlt(response!, code: "")
            }
            
            // 3.1 失败、成功都  回调
            //            completeHandler(responseObject: response!, code: "")
            
        })
        
        currentTask = task
        
        // 4. 开始
        // 创建NSOperation， 将操作加入其中，再将此NSOperation加入NSOperationQueue
        let operation = BlockOperation.init {
              task.resume()
        }
        operationQueue.addOperation(operation)
        operation.start()
        
        //B等A执行完才执行, 设置操作依赖
//        operation.addDependency(operationA) // operation等operationA执行完才执行
        
        // 4.1 开始
//        operationQueue.addOperationWithBlock {
//            task.resume()
//        }
        
        
        return currentTask
    }
    
    // MARK: get请求
    func get(withPath path:String, params:[String:AnyObject], completeHandler:CompletedAction)  {
        
        // 调用总请求
        request(byMethod: .get, withPath: path, params: params, completeHandler: completeHandler)
        
    }
    
    // MARK: 获取请求结果 成功的
    func getSuccessResutlt(_ responseObject:AnyObject, code:String) -> [String: AnyObject] {
        // 转换为字典
        
        let dic = responseObject as! [String: AnyObject]
        return dic
        
    }
    
     // MARK: 获取请求结果 失败的
    func getFailResult(_ error:String, code:String) {
        // 主要是对错误信息的处理
        
    }
    
    
    // MARK: 取消所有请求
    func cancleAllRequest()  {
        operationQueue.cancelAllOperations()
        
    }
    
    // MARK: 取消当前请求
    func cancleCurrentRequest() {
        currentTask.cancel()
    }
    
    // ------------------------- private ---------------- //
    
    
    
}
