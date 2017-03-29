//
//  MySystemRequest.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/15.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
/*  1. 当operation有多个任务的时候会自动分配多个线程并发执行, 如果只有一个任务，会自动在主线程同步执行     2. iOS开发之网络错误分层处理，参考http://blog.csdn.net/moxi_wang/article/details/52638752   3. 使用URLSession的对象，调用其对象方法使用URLRequest来进行请求、上传、下载
    4. URLSession的设置： 
        4.1 默认会话（Default Sessions）使用了持久的磁盘缓存，并且将证书存入用户的钥匙串中。
        4.2 临时会话（Ephemeral Session）没有向磁盘中存入任何数据，与该会话相关的证书、缓存等都会存在RAM中。因此当你的App临时会话无效时，证书以及缓存等数据就会被清除掉。
        4.3 后台会话（Background sessions）除了使用一个单独的线程来处理会话之外，与默认会话类似。不过要使用后台会话要有一些限制条件，比如会话必须提供事件交付的代理方法、只有HTTP和HTTPS协议支持后台会话、总是伴随着重定向。
            【仅仅在上传文件时才支持后台会话，当你上传二进制对象或者数据流时是不支持后台会话的。】
            当App进入后台时，后台传输就会被初始化。（需要注意的是iOS8和OS X 10.10之前的版本中后台会话是不支持数据任务（data task）的）。

*/

/**
 在使用iOS的URL加载系统时，手机端和服务器端端连接可能会出现各种各样的错误，大致可以分为3种：
 
 1、操作系统错误：数据包没有到达指定的目标导致。这类错误iOS中用NSError对象包装起来了，这类错误可以用Apple 提供的Reachability来检测到。可能导致操作系统错误的原因：
     1.1 没有网络:如果设备没有数据网络连接，那么连接很快会被 拒绝或者失败。
     1.2 无法路由到目标主机，设备可能连接网络了，但是连接的目标可能处于隔离的网络中或者掉线状态。
     1.3 没有应用监听目标端口，客户端把数据发送到目的主机指定的端口号，如果服务器没有监听这个端口号(TCP/UDP服务端需要监听指定的端口号)或者需要连接的任务太多，则请求会被拒绝。
     1.4 主机域名无法解析，域名的解析并不一定成功的（笔者公司某款APP第一次用的时候域名DNS解析就容易失败）
     1.5 主机域名错误，域名写错了肯定找不到目标服务器的，我在正确域名tb.ataw.cn改为/tb.ataw1.cn则会报错：
     Error Domain=NSURLErrorDomain Code=-1003 “未能找到使用指定主机名的服务器。” UserInfo={NSUnderlyingError=0x174448040 {Error Domain=kCFErrorDomainCFNetwork Code=-1003 “(null)” UserInfo={_kCFStreamErrorCodeKey=50331647, _kCFStreamErrorDomainKey=6147616992}}, NSErrorFailingURLStringKey=http://tb.ataw1.cn/app/UserLogin, NSErrorFailingURLKey=http://tb.ataw1.cn/app/UserLogin, _kCFStreamErrorDomainKey=6147616992, _kCFStreamErrorCodeKey=50331647, NSLocalizedDescription=未能找到使用指定主机名的服务器。}
 
 2、HTTP错误：由HTTP请求、HTTP服务器或者应用服务器的问题造成，这种类型的错误通常通过HTTP响应头的状态码发送给客户端。HTTP错误的类型和原因：
     2.1 信息性质的100级别，来自HTTP服务器的信息，表示请求的处理将会继续，但是有警告（笔者目前还没遇到过）
     2.2 成功的200级别，表示请求成功了，但是返回的数据不同代表了不同的结果，例如204表示请求成功，但是不会向客户端返回负载。
     2.3 重定向需要的300级别，表示客户端必须执行某个操作才能继续请求，因为需要的资源已经移动了，URL加载系统会自动处理重定向而无需通知代码，如果需要自定义处理 重定向，应该是用异步请求。
     2.4 客户端错误的400级别，表示客户端发出了服务器无法处理的错误数据，需要注意你URL后面的路径、请求的参数格式、请求头的设置等,例如，我把正确路径http://tb.ataw.cn/app/UserLogin 写成http://tb.ataw.cn/app/UserLogin1，则会报错：
     { URL: http://tb.ataw.cn/app/UserLogin1 } { status code: 404, headers {
     Server=Microsoft-IIS/7.5;
     Content-Type=text/html; charset=utf-8;
     X-Powered-By=ASP.NET;
     Date=Fri, 23 Sep 2016 06:41:27 GMT;
     Content-Length=3431;
     Cache-Control=private;
     X-AspNet-Version=4.0.30319;
     } }
     
     2.5 下游错误的500级别，表示服务器与下游服务器之间出现了错误，客户段就会收到500级别的错误，这时候通常都是后台开发的事情了，移动端告知他们修改。
 
 3、应用错误：应用产生的错误（这一层的错误是我们开发中必须打交道的，客户端可以根据服务端返回负载中的状态码来进行业务逻辑处理），这些错误是运行在服务层之上的业务逻辑和应用造成的，这一层中的状态码是可以自定义的，所以需要和后台人员沟通好以便不同情况好处理业务逻辑。常见，例如，服务端的代码异常（笔者公司这种问题还蛮多的），这种错误一般服务端人员会给返回给客户端的负载状态码子段赋值500，例如，当我们登录成功时，后台返回的负载中状态码为200，如果登陆账号密码错误，则后台人员会返回一个不同的状态码。注意：这一层的状态码后台人员是可以任意定义的，所以开发中一定要沟通好哪个状态码对应什么状态。
 
 */

/**
 计算机网络中五层协议分别是（从下向上）：
     1) 物理层
     2）数据链路层
     3）网络层
     4）传输层
     5）应用层
 其功能分别是：
     1）物理层主要负责在物理线路上传输原始的二进制数据；
     2）数据链路层主要负责在通信的实体间建立数据链路连接；
     3）网络层主要负责创建逻辑链路，以及实现数据包的分片和重组，实现拥塞控制、网络互连等功能；
     4）传输曾负责向用户提供端到端的通信服务，实现流量控制以及差错控制；
     5）应用层为应用程序提供了网络服务。
    一般来说，物理层和数据链路层是由计算机硬件（如网卡）实现的，网络层和传输层由操作系统软件实现，而应用层由应用程序或用户创建实现。
 
 */

/** NSURLSession使用参考：http://www.cnblogs.com/mddblog/p/5215453.html
 
 // 2. 图片下载方式3 使用NSURLSession下载，需要设置其缓存模式为  临时会话\不缓存
 
 // 设置会话的缓存模式
 NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
 NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
 
 NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
 
 if (error) {
 NSLog(@"合影下载错误： %@", error);
 return ;
 }
 // 文件的路径,   必须加后缀名字，不然的话，copyItemAtPath或removeItemAtPath都会失败
 NSString *fullPath = [[Const documentPath] stringByAppendingString: @"img.png"];
 
 NSError *fileCopyError;
 NSError *fileDeletError;
 if (location) {
 // 剪切文件
 // 第一个参数：要剪切的文件在哪里     第二个参数：文件要要保存到哪里
 //            [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL URLWithString:fullPath] error: &er];
 
 if ([[Const fileManager] fileExistsAtPath:fullPath]) {
 [[Const fileManager] removeItemAtPath:fullPath error:&fileDeletError];
 }
 
 
 // 也会将Temp下面的文件移动
 [[Const fileManager] copyItemAtPath:location.path toPath: fullPath error:&fileCopyError];
 
 if (fileCopyError == nil) {
 NSLog(@"file save success");
 
 _takePhotoView.hidden = YES;
 _uploadBtn.hidden = YES;
 _uploadView.hidden = NO;
 dispatch_async(dispatch_get_main_queue(), ^{
 _imgV.image = [UIImage imageWithContentsOfFile:fullPath];
 });
 
 } else {
 NSLog(@"file save error: %@", fileCopyError);
 }
 }
 
 
 
 }];
 
 [downloadTask resume];
 
 */


import UIKit



class MySystemRequest: NSObject {

    var request:URLRequest!
    // 由此来配置URLSession
    private let sessionConfiguration = URLSessionConfiguration.default
    private let session = URLSession.init(configuration: sessionConfiguration)
    
    private var  currentTask:URLSessionDataTask!
    private let operationQueue = OperationQueue.init()
    
    private let queueName = "operationQueue_system_01"
    
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
    
    private func defaultSets(){
        // 1.
        request.timeoutInterval = 30
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
            
            // 网络错误分层处理
            // 5.1 系统错误的处理
            if error != nil {
                
            }
            
            // 5.2 HTTP错误处理
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 300 {
            
            }else if httpResponse.statusCode == 400 {
                
            }else if httpResponse.statusCode == 500 {
                
            }
            
            // 5.3
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
    
    
    // MARK:  上传1.  urlStr:请求地址  data:上传的二进制数据
    func upload(_ urlStr:String, withData data:Data?) {
        
        let url = URL.init(string: urlStr)!
        let request = URLRequest.init(url: url)
        
        
        _ = session.uploadTask(with: request, from: data, completionHandler: { (data, response, error) in
            
        })
    }
    
    
     // MARK:  上传2.  urlStr:请求地址 filePath:上传的文件
    func upload(_ urlStr:String, withFilePath file:String) {
    
        let url = URL.init(string: urlStr)!
        let request = URLRequest.init(url: url)
        
        let filePath =  URL.init(fileURLWithPath: file)
        
        
        _ = session.uploadTask(with: request, fromFile: filePath, completionHandler: { data, response, error in
            
        })
    }
    
    
    // MARK:  下载
    func download(_ urlStr:String) {
        let path = URL.init(string: urlStr)!
        
        _ = session.downloadTask(with: path, completionHandler: { (url, response, error) in
            
        })
        
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
