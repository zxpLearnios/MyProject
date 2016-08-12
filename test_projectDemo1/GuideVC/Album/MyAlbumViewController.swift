//
//  MyAlbumViewController.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/7/22.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  展示相册的第一个图片及本相册的图片总数目

import UIKit
import  Photos

class MyAlbumViewController: UITableViewController {

    private let cellId = "MyAlbumTableViewCell"
    private var firstImgs = [UIImage]() // 每组相册的第一个图片
    private var totalCount = [Int]() // 所有组相册的图片总数
    private var totalImageAry = [[UIImage]]() // 里面存放相册组
    private var currentImgs = [UIImage]() //当前相册里的图片
    private var albumNames = [String]() // 相册名字
    private let notiName = "MyImagePickerController_post_"
    
//    private override init(style: UITableViewStyle) {
//        super.init(style: style)
//        
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    // 外部调用
//    class var sharedInstance: MyAlbumViewController {
//        struct Static {
//            static var onceToken: dispatch_once_t = 0
//            static var instance: MyAlbumViewController? = nil
//        }
//        dispatch_once(&Static.onceToken) {
//            Static.instance = MyAlbumViewController.init(style: .Plain)
//        }
//         kNotificationCenter.addObserver(Static.instance!, selector: #selector(handleNotification), name: Static.instance!.notiName, object: nil)
//        return Static.instance!
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        
        self.tableView.rowHeight = 50
        self.tableView.tableFooterView = UIView()
        
        // 右边按钮
        let backBtn = UIButton.init()
        backBtn.setImage(UIImage(named: "album_delete_btn"), forState: .Normal)
        backBtn.width = 20
        backBtn.height = 20
        
        backBtn.addTarget(self, action: #selector(backAction), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        
        
        getAssetsGroup()
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    func backAction()  {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 处理接受到的通知
//    @objc private func handleNotification(noti:NSNotification){
//        
//        let objDic = noti.object as! [String:AnyObject]
//        let imgs = objDic["firstImgs"] as! [UIImage]
//        let counts = objDic["countOfGroup"] as! [Int]
//        
//        totalCount = counts
//    
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return totalCount.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! MyAlbumTableViewCell
        cell.imgV.image = firstImgs[indexPath.row]
        cell.totalLab.text =  String(totalCount[indexPath.row])
        cell.albumNameLab.text = albumNames[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 把当前点击的相册里面所有图片传过去
        let vc = MyImagePickerController.getSelf(totalImageAry[indexPath.row])
        self.navigationController?.pushViewController( vc, animated: true)
    }
    
    //  private
    
    /**
     1. 查询所有的相册
     */
    private func getAssetsGroup(){
        
        // 遍历所有的自定义相册
        let collectionResult0:PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .AlbumRegular, options: nil)
        
        for i in 0..<collectionResult0.count {
            
            let collection = collectionResult0.objectAtIndex(i) as! PHAssetCollection
            
            searchAllImagesInCollection(collection)
        }
        
        // 获得相机胶卷的图片
        let collectionResult1 = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .AlbumRegular, options: nil)
        
        for i in 0..<collectionResult1.count {
            let collection = collectionResult1.objectAtIndex(i) as! PHAssetCollection
            if !(collection.localizedTitle ==  "Camera Roll") {
                continue
            }
            searchAllImagesInCollection(collection)
            
        }
        
        self.tableView.reloadData()
    }
    
    /**
     2. 查询某个相册里面的所有图片
     */
    private func searchAllImagesInCollection(collection: PHAssetCollection) {
        
        // 采取同步获取图片（只获得一次图片）
        let imageOptions = PHImageRequestOptions.init()
        imageOptions.synchronous = true
        
        if collection.localizedTitle != nil {
            albumNames.append(collection.localizedTitle!)
        }
        debugPrint("相册名字： \(collection.localizedTitle)")
        
        // 遍历这个相册中的所有图片
        let assetResult = PHAsset.fetchAssetsInAssetCollection(collection, options: nil)
        
        // 并行队列同步操作
        let myqueue = dispatch_queue_create("myqueue.album.testQueue", DISPATCH_QUEUE_CONCURRENT)
        
        dispatch_sync(myqueue, {
            for i  in 0..<assetResult.count {
                let asset = assetResult[i] as! PHAsset
                
                // 过滤非图片
                if asset.mediaType != .Image {
                    continue
                }
                
                // 图片原尺寸, 不用注释的代码，因为这样更快，不会死机(先固定此数，貌似越大越清晰，但越耗性能，启动越慢)
                let  targetSize = CGSizeMake(50, 50) // CGSizeMake(CGFloat(asset.pixelWidth), CGFloat(asset.pixelHeight))
                
                // 请求图片
                let imgManager = PHImageManager.defaultManager()
                imgManager.requestImageForAsset(asset, targetSize: targetSize, contentMode: .AspectFill, options: imageOptions, resultHandler: { (result, infoDic) in
                    
                    if result != nil{
//                        self.currentImgs.append(result!) // 总的图片，图片顺序为默认的即最先拍的在最前面
                        self.currentImgs.insert(result!, atIndex: 0) // 总的图片，图片顺序为距现在最近拍的图片放在最前面
                        
                    }
                })
            }
            
            // 得到当前相册的第一个图片、 图片总数
            if self.currentImgs.count != 0{
                self.totalImageAry.append(self.currentImgs)
                self.firstImgs.append(self.currentImgs.last!)
                self.totalCount.append(self.currentImgs.count)
            }
        })
        
        
        
    }

    
    deinit{
        kNotificationCenter.removeObserver(self)
    }
}