//
//  MyBaseNetWorkRequest.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/7/4.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  1. HTTP JSON 调用方式
//  采用HTTP协议传输，内容格式为Content-type: application/json; charset=UTF-8;
//  但Oauth认证接口除外，内容格式为Content-type: application/x-www-form-urlencoded; charset=UTF-8;
//  2. 【Swift中异常处理的三种方式    2.1 try : 正常处理,必须用到do {} catch {} ；  2.2 try! : 告诉系统一定没有异常,也就是说不用do catch来处理,开发中不建议用.一旦有异常,程序崩溃； 2.3 try? : 告诉系统可能有异常,也可能没有异常.如果没有异常,系统会自动将结果包装成一个可选类型给你,如果有异常,系统会返回nil.如果使用try?可以不是同do catch进行处理】
//  3. Alamofire 本质是基于`NSURLSession` ，使用GET类型请求的时候，参数会自动拼接在url后面；参数是放在在HTTP body里传递，url上看不到； 2，Alamofire的功能特性：
// 【
//（1）链式的请求/响应方法
//（2）URL / JSON / plist参数编码
//（3）上传类型支持：文件（File ）、数据（Data ）、流（Stream）以及MultipartFormData
//（4）支持文件下载，下载支持断点续传
//（5）支持使用NSURLCredential进行身份验证
//（6）HTTP响应验证
//（7）TLS Certificate and Public Key Pinning
//（8）Progress Closure & NSProgress】
//  4. 可以用个属性request来 接收 每次请求时（调用request方法进行请求时）返回的Request实例，以便在合适的地方取消相应的请求；取消所有请求得用manage的方法了，如5.；
//  5. upload download 此处不需要总的请求
//  6. 对于取消请求： 需要令 mainRequest =  manager.request(...) / Alamofire.upload(..) / Alamofire.download(...), 之后才可以调用取消网络请求的方法，即须调用Request对象的cancle()才可以取消请求的
//  7. 当operation有多个任务的时候会自动分配多个线程并发执行,
//如果只有一个任务，会自动在主线程同步执行


import UIKit
import Alamofire

enum Method: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

class MyBaseNetWorkRequest: NSObject {
    typealias  completeColsureType = ((result:AnyObject, code:String) -> Void) // 非optional即外界必须有相应的回调  ，由于请求返回的数据结果是个字典。    常如：{"BODY":"{\"RESULT\":false}","RESPONSE_STATUS":"OK","ELAPSE_TIME":"18","ERROR_CODE":null,"ERROR_MESSAGE":null}
    
    
    private var manager:Manager!
    
    /**  用于停止下载时，保存已下载的部分 */
    private var cancelledData: NSData?
    /** 下载请求对象 */
    private var downloadRequest: Request?
    /** 主请求对象 */
    private var mainRequest:Request?
    
    /** HTTP Headers */
    private let headers = Alamofire.Manager.defaultHTTPHeaders // 必须 是 [String: String]
//    let headers = [
//        "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
//        "Accept": "application/json",
//        "text/html; charset=utf-8": "Content-Type"
//    ]
    /** 目的地 下载的文件被保存的地址 */
    private let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
    // 设置请求的超时时间
    private let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    private let requestTimeOut = 30
    private let operationQueue = NSOperationQueue.init()
     private let queueName = "operationQueue_mybaserquest_001"
    
    override init() {
        super.init()
        
        // 1. 设置manager
        // 1.1
        //        manager = Alamofire.Manager.sharedInstance
        // 1.2
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        manager = Manager.init(configuration: config)
        
        operationQueue.name = queueName
        //设置最大并发数
//        operationQueue.maxConcurrentOperationCount = 2
        
        
    }
    
    /**
      0. 总请求方法
     - parameter method:          请求方式
     - parameter path:            请求路径
     - parameter params:          请求参数
     - parameter paramsEncoding:  请求参数编码方式
     - parameter completeClosure: 请求完成后的回调
     */
    private func request(method:Method, path:String, params:[String:AnyObject], paramsEncoding:ParameterEncoding, completeClosure:completeColsureType) { // paramsT... 一个可变参数可以接受零个或多个值。
        
       
        
        // 2. 根据请求方式进行 相应的请求
        switch method {
            
        case .OPTIONS:
            
            break
        
        case .HEAD:
            
            break
            
        case .PATCH:
            break
        
        case .TRACE: 
            break
        case .CONNECT: 
            break
            
        case .GET:
            
            
           mainRequest = manager.request(.GET, path, parameters: params, encoding: paramsEncoding, headers: headers).responseJSON(completionHandler: { response in
                
                //                print(response.request)  // original URL request
                //                print(response.response) // URL response
                //                print(response.data)     // server data
                //                print(response.result)   // result of response serialization
                
                
//                switch response.result{
//                case .Success:
//                    
//                    break
//                case .Failure(let error):
//                    print("网络请求失败！！！\(error)")
//                    break
//                }
//                
//                completeClosure(result: response.result.value as! String, code: "")
                
                if let result = response.result.value as? String{
                    // 返回的数据的最外层往往是一个字典
                    
                    let data = result.dataUsingEncoding(NSUTF8StringEncoding)
                    if data != nil {
                        //  异常的处理、捕捉
                        
                        do{
                            let jsonObj = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                            
                            if let resultDic =  (jsonObj as? Dictionary<String,AnyObject>){ // 原数据是字典类型
                                completeClosure(result: resultDic, code: "")
                                
                            }else{ // 说明 原数据不是字典类型
                                if let resultAry =  (jsonObj as? [AnyObject]){
                                    completeClosure(result: resultAry, code: "")
                                }
                                
                            }
                            
                        }catch let error {
                            print(error)
                        }
                        
                    }
                    
                    
                }else{
                    print("请求成功，但返回的结果为空！")
                }

                
            })
            break
        case .POST:
            Alamofire.request(.POST, " ", parameters: ["foo": "bar"])
                .responseJSON { response in
                    
                    
            }
            break
        case .PUT:
            Alamofire.request(.PUT, " ", parameters: ["foo": "bar"])
                .responseJSON { response in
                    
                    
            }
            break
            
        case .DELETE:
            Alamofire.request(.DELETE, " ", parameters: ["foo": "bar"])
                .responseJSON { response in
                    
                    
            }
            break
        }
        
        
    }
    
    
    /**
     1. 外部调用的GET请求方法
     - parameter path:            请求路径
     - parameter params:          请求参数
     - parameter completeClosure: 请求完成后的回调\closure
     */
    func getRequestWithPath(path:String, params:[String:AnyObject]?, completeClosure:completeColsureType) {
        
        if params != nil && path.characters.count != 0 {
            request(.GET, path: path, params: params!, paramsEncoding: .JSON, completeClosure: completeClosure)
        }else{ // 提示 参数为空、请求路径为空
            
        }
        
        
    }
    
    /**
     1.1 外部调用的GET请求方法，需要将总请求方法里的completeSeltector也改为Selector类型即可，实现了外部的结果方法的参数任意
     - parameter completeSeltector: 请求完成后的回调函数
     */
    func getRequest(withPath path:String, params:[String:AnyObject]?, completeSeltector:Selector) { // Selector
//        completeSeltector("", code:"xx")
        print(completeSeltector.description)
        if params != nil && path.characters.count != 0 {
//            request(.GET, path: path, params: params!, completeSeltector: completeSeltector)
        }else{ // 提示 参数为空、请求路径为空
            
        }
        
        
    }
    
    
    //    ---------------------------   upload    ----------------------- //
    
   // 上传NSData、NSUrl、stream（流：NSInputStream输入流、NSOutputStream输出流）
    /**
     2. 外部调用 上传单个文件
     - parameter fileUrl:        要上传的本地文件的路径, 即NSBundle.mainBundle().URLForResource("xxx.xx", withExtension: nil)
     - parameter andRequestPath: 需要将文件上传的目的地 地址
     - parameter scriptName      服务器脚本字段名
     */
    func uploadOneFile(withFileUrl fileUrl: NSURL, andUploadPath path: String, scriptName name: String) {
        // Alamofire manager
        manager.upload(.POST, path, file: fileUrl).progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
            
            // 此处显示进度
            dispatch_async(dispatch_get_main_queue()) {
                debugPrint("Total bytes written on main queue: \(totalBytesWritten)")
            }
        }.validate().responseJSON { (response) in
            
        }
        
    }
    
    /**
     2.1 外部调用 上传多个文件、数字、字符串皆可，类似于网页上Form表单里的文件提交
     - urls             要上传的本地文件的路径数组,url = NSBundle.mainBundle().URLForResource("hangge", withExtension: "png")
     - parameter names  ==  urls  的个数
     - parameter path:  需要将文件上传的地址
     */
    func uploadMoreFileByMutiData(fileURLs urls: [AnyObject], scriptNames names: [String], andUploadPath path: String) {
        
        if urls.count != names.count {
            print("names  !=  urls，二者须有相同的数量！")
            return
        }
//        let header = ["x":"x"]
        
        // Alamofire manager
        manager.upload(.POST, path, multipartFormData: { multipartFormData in
            
            let count = urls.count
            // 设置 上传文件
            for i in 0..<count{
                let  url = urls[i]
                if url is NSURL{
                    multipartFormData.appendBodyPart(fileURL: url as! NSURL, name: names[i])
                }else if url is NSData {
                    multipartFormData.appendBodyPart(data: url as! NSData, name: names[i])
                }
                
                
            }
//            multipartFormData.appendBodyPart(data: file1Data!, name: "file1", // data
//                fileName: "h.png", mimeType: "image/png") // 图片
//            multipartFormData.appendBodyPart(fileURL: file2URL!, name: "file2") // 文件, 即NSBundle.mainBundle().URLForResource("hangge", withExtension: "png")
            
            }, encodingCompletion: { encodingResult in
                switch encodingResult {
                    // PHP返回的json,Obj-C无法解析, 如下提示：Error Domain=NSCocoaErrorDomain Code=3840 \"Invalid value around character 0.\" UserInfo={NSDebugDescription=Invalid value around character 0.}
                case .Success(let request, let isStreamingFromDisk, let streamFileURL):
                    
                    request.responseJSON { response in
                        debugPrint("成功了\(response)")
                    }
                case .Failure(let encodingError):
                    debugPrint("出错了\(encodingError)")
                }
            }
        )
        
    }
    
    /**
     2.2 使用文件流的形式上传文件
     - parameter name: 文件的全名，带后缀，须在NSBundle下
     */
    func uploadOneFileByStream(urlPath path: String, fileTotalName name: String) {
        
        let fileURL = NSBundle.mainBundle().URLForResource(name, withExtension: nil)
        // Alamofire manager
        manager.upload(.POST, path, file: fileURL!)
        
    }
    
    /**
     2.3 上传多个文件, 暂时无用
     - parameter url:       上传地址
     - parameter fileUrls:  需要上传的文件
     - parameter fileNames:
     - parameter name:      服务器的脚本名
     */
    func uploadMoreFile(withUrlString url: String, fileUrls: [NSURL], fileNames: [NSURL], name:String) {
        
        // 将需要上传的文件写入body中
        // Alamofire manager
        manager.upload(.POST, url, multipartFormData: { multipartFormData in
            
            
            }, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let request, _, _):
                    request.responseJSON { response in
                        debugPrint(response)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
        
    }
    
    /**
     2.4 上传用户图像，
     - parameter path:        上传的url地址
     - parameter imageArrays: 需要上传的图片
     - parameter params:      其他参数，如：用户ID
     */
    func uploadUserAvatar(withPath path: String, imageArrays: [UIImage], params:[String:AnyObject]) {
        
        // 将需要上传的文件写入body中
        
        // Alamofire manager
        manager.upload(.POST, path, multipartFormData: { multipartFormData in
            
            for image in imageArrays {
                let data = UIImageJPEGRepresentation(image, 1.0)
//                UIImagePNGRepresentation(image) // 此法对引用的图片处理后要比UIImageJPEGRepresentation处理后的大，后者可对图片压缩质量进行控制，如：0.5
                let imageName = String(NSDate()) + ".png"
                multipartFormData.appendBodyPart(data: data!, name: "name", fileName: imageName, mimeType: "image/png")
            }
            
            // 这里就是绑定参数的地方
            for (key, value) in params {
                assert(value is String, "参数必须能够转换为NSData的类型，比如String")
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key )
            }
            
            
            }, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let request, _, _):
                    request.responseJSON { response in
                        debugPrint(response)
                    }
                case .Failure(let encodingError):
                    debugPrint(encodingError)
                }
            }
        )
        
    }

    
    //    ---------------------------   download    ----------------------- //
    // 下载： 图片、音频、视频、文件，还可以设置下载请求时的头部信息
    /**
     3. 用默认的保存地址进行下载，无下载进度；下载下来保存到用户文档目录下（Documnets目录）,文件名不变
     - parameter path: 资源路径
     */
    func downloadWithResourcePath(path:String) {
        // Alamofire manager
        Alamofire.download(.GET, path) { temporaryURL, response in
            
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let pathComponent = response.suggestedFilename
            
            // 下载后的文件 保存路径
            let directoryPath = directoryURL.URLByAppendingPathComponent(pathComponent!)
            print(directoryPath)
            
            return directoryPath
        }
    }
    
    /**
     3.1  类似于3.2  但无下载进度;下载下来保存到用户文档目录下（Documnets目录）,文件名不变
     */
    func downloadWithDefaultDownloadDestination(resourcePath:String) {
         // 下载后的文件保存路径
        let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        
        //Alamofire manager
        Alamofire.download(.GET, resourcePath, destination: destination)
    }
    
    /**
     3.2 用默认的保存地址进行下载，有下载进度；下载下来保存到用户文档目录下（Documnets目录）,文件名不变
     */
    func downloadResource(resourcePath:String) {
        let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        
        //Alamofire manager
        Alamofire.download(.GET, resourcePath, destination: destination)
            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                print(totalBytesRead)
                
                // This closure is NOT called on the main queue for performance
                // reasons. To update your ui, dispatch to the main queue.
                dispatch_async(dispatch_get_main_queue()) {
                    print("Total bytes read on main queue: \(totalBytesRead)")
                }
            }
            .response { (resuest, response, data, error) in
                if let error = error {
                    print("Failed with error: \(error)")
                } else {
                    print("Downloaded file successfully")
                }
        }
        
    }
    
    /**
     3.3 用默认的保存地址进行下载，下载下来保存到用户文档目录下（Documnets目录）, 参数少功能小,下载失败时获取resumeData；还有点问题
     */
    func downloadResourceWithPath(resourcePath:String) {
        
        //Alamofire manager
        Alamofire.download(.GET, resourcePath, destination: destination)
            .response { (request, response, data, error) in
                if let data = data, resumeDataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                {
                    print("Resume Data: \(resumeDataString)")
                } else {
                    print("Resume Data was empty")
                }
        }
    }
    
    /**
     *  3.4 断点续传的下载（下载大文件时用），下载下来保存到用户文档目录下（Documnets目录
     *  下载的东西会先缓存在沙盒的tmp下，叫CFNetWork...，下载完成后，此缓存自动消失且文件保存在设置好的目录下
     */
    func downloadResourceByResumeData(resourcePath path:String) {
        
        var download:Request!
        
        // 0. 根据数据是否缓存过 进行断点下载与否
        if cancelledData != nil { // 上面数据有过下载了
            download = Alamofire.download(resumeData: cancelledData!, destination: destination)
        }else{
            download = Alamofire.download(.GET, path, destination: destination)
        }
        
        // 1. 下载进度
        download.progress {  bytesRead, totalBytesRead, totalBytesExpectedToRead in
            
            // This closure is NOT called on the main queue for performance
            // reasons. To update your ui, dispatch to the main queue.
            dispatch_async(dispatch_get_main_queue()) {
                debugPrint("Total bytes read on main queue: \(totalBytesRead)")
            }

        }
        
        // 2. 对已下载的数据 在下载取消时进行及时的缓存
        download.response { request, response, data, error in
            
            if let error = error { // 下载失败
                
                debugPrint("下载中断了，因为\(error)")
                self.cancelledData = data  // 意外终止的话，把已下载的数据储存起来
//                if error.code == NSURLErrorCancelled { // NSURLErrorUnknown NSURLErrorUnknown NSURLErrorNetworkConnectionLost NSURLErrorTimedOut
//                    self.cancelledData = data  // 意外终止的话，把已下载的数据储存起来
//                } else {
//                    print("Failed to download file: \(response) \(error)")
//                }
                
            } else { // 下载成功
                print("Successfully downloaded file: \(response)")
            }
            
        }
        
        // -2. 和上面的作用一样
//        downloadRequest = Alamofire.download(resumeData: NSData(), destination: destination)
//        downloadRequest?.response(completionHandler: downloadResponse)
    }
    
    /**  3.5 下载停止响应（不管成功或者失败 */
    private func downloadResponse(request: NSURLRequest?, response: NSHTTPURLResponse?,
                                  data: NSData?, error:NSError?) {
        if let error = error {
            if error.code == NSURLErrorCancelled {
                self.cancelledData = data //意外终止的话，把已下载的数据储存起来
            } else {
                print("Failed to download file: \(response) \(error)")
            }
        } else {
            print("Successfully downloaded file: \(response)")
        }
    }
    
    
    /**
     3.6 保存到用户文档目录下（Documnets目录下的savePath文件下，文件名为saveName），saveName最好根据资源类型加上后缀
     - parameter path:     资源路径
     - parameter savePath: 保存路径
     - parameter saveName: 保存后的名字
     */
    func downloadResource(withPath path:String, savePath:String, saveName:String)  {
        Alamofire.download(.GET, path) {
            temporaryURL, response in
            
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory,
                                                            inDomains: .UserDomainMask)[0]
            
            let folder = directoryURL.URLByAppendingPathComponent(savePath, isDirectory: true)
            
            // 判断文件夹是否存在，不存在则创建
            let exist = fileManager.fileExistsAtPath(folder.path!)
            if !exist {
                try! fileManager.createDirectoryAtURL(folder, withIntermediateDirectories: true,
                                                      attributes: nil)
            }
            
            return folder.URLByAppendingPathComponent(saveName)
        }
        
        
    }
    
    
//    ---------------------------  Authentication(用户权限认证) ----------------------- //
    // 自签名的HTTPS的数据
    /**
     *  4.
     */
    
    
    
    
    //    ---------------------------   private    ----------------------- //
    /** 5.  取消下载 */
    private func cancleDownload()  {
//        self.downloadRequest?.cancel()
    }
    
    /** 6. 取消所有请求 */
    func cancleAllRequest() {
        debugPrint("取消所有网络请求！")
        mainRequest?.cancel()
        
//        mainRequest?.suspend() // 暂停底层任务和调度队列
//        manager.session.finishTasksAndInvalidate() // finishTasksAndInvalidate: 会执行完当前的请求，之后不再建新请求，看看SDK; invalidateAndCancel:
    }
    
    deinit{
//        cancelledData = nil
    }
    
    /**
      7. JPEG方式 压缩图片
     - parameter image:     要压缩的图片
     - parameter sizeLimit: 压缩后的图片最大为？M ，外界直接传入几M即可
     - returns: 压缩后的图片二进制数据
     */
    func compressImage(image: UIImage, imageSizeLimit sizeLimit:Double) -> NSData? {
        let compressScale:[CGFloat] = [0.5, 0.1, 0.05, 0.01, 0.001] // 不同的压缩纬度
        var imageData:NSData?
        
        for i in 0..<compressScale.count {
            imageData = UIImageJPEGRepresentation(image, compressScale[i])
            
            if imageData != nil{
                // 如果图片压缩后大小符合要求，则返回图片
                if Double(imageData!.length) < sizeLimit * (1024.0 * 1024.0)  {
                    return imageData
                }
            }else{
                debugPrint("JPEG方式 压缩图片后， 出错了！")
            }
            
        }
        
        // 图片 按前几个数压缩后，都太大了，故此时按0.0001压缩，之后返回图片
        imageData = UIImageJPEGRepresentation(image, 0.0001)
        return imageData
    }
    
    /**
     8.  手动实现图片压缩，按照大小进行比例压缩，改变了图片的尺寸； 可以再调用 6. 对此中得到的图片进行压缩，返回压缩后的图片二进制数据
     - parameter scale: 压缩比例， 如由100*100压缩为10*10，则scale = 0.1
     */
    func compressImage(image: UIImage, scale: CGFloat) -> UIImage {
    
        var newImage:UIImage!
        let imageSize = CGSizeMake(image.size.width * scale, image.size.height * scale)
        
        if (image.size.width != imageSize.width || image.size.height != imageSize.height){
    
            UIGraphicsBeginImageContext(imageSize)
            let imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height)
            image.drawInRect(imageRect)
            
            newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }else{
            newImage = image
        
        }
        return newImage
    }
    
   
}

// -----------------------  8. 下拉、上拉加载数据 --------------------- //
// 加载数据 模式
// 1. 获取消息列表, index:消息类型 , 下拉、上拉
//    func getMsgList(index:Int, isLoadMoreData:Bool)  {
//
//        var  msgType = MsgType.LendingNotice // index == 0
//
//        if index  == 1{
//            msgType = .OverdueNotice
//        }else if index == 2{
//            msgType = .BackWarnNotice
//        }
//
//        var loadPage = 0
//        if !isLoadMoreData {
//            loadPage = 1
//        }else{
//            loadPage = page
//        }
//
//        request.informationListWith(msgtype: msgType, pageno: loadPage, successClosure: { (bodyObject) in
//            if bodyObject.isKindOfClass(NSError){
//                return
//            }
//
//            let dic = bodyObject as! [String:AnyObject]
//            let listAry = dic["list"] as! [[String:AnyObject]]
//
//            if isLoadMoreData { // 在加载更多数据
//                self.vc.messageArr += listAry
//
//                if listAry.count == 0{ // 无过多数据， 可以是page 恢复
//                    self.vc.tableView.endFooterRefreshingWithNoMoreData()
//                    self.page -= 1
//                    return
//                }
//            }else{
//                self.vc.messageArr = listAry
//            }
//
//
//            self.vc.tableView.reloadData()
//
//            self.vc.tableView.endHeaderRefreshing()
//            if self.vc.messageArr.count < self.countLimit{
//                self.vc.tableView.endFooterRefreshingWithNoMoreData()
//            }else{
//                self.vc.tableView.endFooterRefreshing()
//            }
//
//        }) { (error) in
//            self.vc.tableView.endHeaderRefreshing()
//            if self.vc.messageArr.count % self.countLimit == self.countLimit{
//                self.vc.tableView.endFooterRefreshing()
//            }else{
//                self.vc.tableView.endFooterRefreshingWithNoMoreData()
//            }
//            if isLoadMoreData {
//                self.page -= 1
//            }
//        }
//
//        debugPrint("当前消息Page==\(page)")
//
//    }
//
//    // 2. 标记已读消息
//    func markingHaveReadMsg(withMid mid:String) {
//        request.tagInformationWith(mid: mid, successClosure: { (bodyObject) in
//            if bodyObject.isKindOfClass(NSError){
//                return
//            }
//
//        }) { (error) in
//            print("标记已读失败\(error)")
//        }
//    }
//
//    // 3. 刷新
//    func setupHeaderAndFooter()  {
//        vc.tableView.setUpHeaderRefresh { [weak self] in
//            self?.page = 1 // 恢复
//            self!.getMsgList(self!.vc.index, isLoadMoreData: false)
//
//        }
//        vc.tableView.beginHeaderRefreshing()
//
//
//        vc.tableView.setUpFooterRefresh { [weak self] in
//
//            self!.page += 1
//            self!.getMsgList(self!.vc.index, isLoadMoreData: true)
//        }
//
//    }

/*   总的请求示例
 
 func loadPOSTRequestWith(operationPath operationPath:String, params:NSDictionary?,successAction:QLResSuccessClosure,failAction:QLResFailClosure) -> Void {
 
 resSuccessClosure = successAction
 resFailClosure = failAction
 
 _operationPath = operationPath
 _paramDict = params
 
 UIApplication.sharedApplication().networkActivityIndicatorVisible = true
 if self._showHUD{
 khud.showLoadingProgress()
 }
 
 let url = QLAPIURL
 
 Alamofire.request(.POST, url+_operationPath!, parameters: (_paramDict as! [String : AnyObject]),encoding:.JSON).responseJSON { response in
 
 UIApplication.sharedApplication().networkActivityIndicatorVisible = false
 if self._showHUD {
 khud.hidden(0.0)
 }
 self._showHUD = true
 
 switch response.result {
 case Result.Success:
 
 //把得到的JSON数据转为字典
 let jsonObject = response.result.value as? NSDictionary
 
 if jsonObject==nil || !jsonObject!.isKindOfClass(NSDictionary)
 {
 if self.resSuccessClosure != nil {
 // self.resSuccessClosure!(bodyObject:"")
 let error:NSError = NSError.init(domain:"", code: 0, userInfo: nil)
 self.resSuccessClosure!(bodyObject:error)
 }
 Config.showAlert(withMessage:"请求数据格式有误！")
 return
 }
 
 // 请求成功回调：
 if self.resSuccessClosure != nil {
 let resStatus = jsonObject![RESPONSESTATUS] as? String
 if resStatus != nil && resStatus!.uppercaseString != "OK"{
 //说明有错误,给提示,并回调Error
 let errorMsg = jsonObject![ERRORMESSAGE] as? String
 var errorStr:String = ""
 if errorMsg != nil { errorStr = errorMsg! }
 
 Config.showAlert(withMessage:errorStr)
 
 let error:NSError = NSError.init(domain:errorStr, code: 0, userInfo: nil)
 self.resSuccessClosure!(bodyObject:error)
 
 return
 }
 
 
 let bodyObj = jsonObject![BODY] as? String
 if bodyObj != nil {
 let bodyDict = try! NSJSONSerialization
 .JSONObjectWithData(bodyObj!.dataUsingEncoding(NSUTF8StringEncoding)!, options:NSJSONReadingOptions.AllowFragments) as! Dictionary<String,AnyObject>
 self.resSuccessClosure!(bodyObject:bodyDict)
 }
 else{
 //                            let error:NSError = NSError.init(domain: "", code: 0, userInfo: nil)
 //                            self.resSuccessClosure!(bodyObject:error)
 
 self.resSuccessClosure!(bodyObject:"")
 }
 }
 
 break
 
 case Result.Failure(let error):
 print(error)
 khud.showPromptText(error.localizedDescription)
 // 请求失败回调：
 if (self.resFailClosure != nil){
 self.resFailClosure!(error:error)
 }
 
 break
 
 }
 
 }
 }
 */


class  downloadRequest:NSObject {

    // 用于停止下载时，保存已下载的部分
    private var cancelledData: NSData?
    // 下载请求对象
    private var downloadRequest: Request?
    
    
    private override init() {
        
    }
    
    convenience  init(request:Request) {
        self.init()
        
        downloadRequest!.response(completionHandler: downloadResponse) //下载停止响应
    }
    
    // 下载停止响应（不管成功或者失败）
    private func downloadResponse(request: NSURLRequest?, response: NSHTTPURLResponse?,
                          data: NSData?, error:NSError?) {
        if let error = error {
            if error.code == NSURLErrorCancelled {
                self.cancelledData = data //意外终止的话，把已下载的数据储存起来
            } else {
                print("Failed to download file: \(response) \(error)")
            }
        } else {
            print("Successfully downloaded file: \(response)")
        }
    }
    
    
    func cancleDownload()  {
        self.downloadRequest?.cancel()
    }
    
}

