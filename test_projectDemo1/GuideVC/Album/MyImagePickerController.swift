//
//  MyImagePickerController.swift
//  CameraAndAlbum_swfit
//
//  Created by Jingnan Zhang on 16/7/21.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  1. 展示所有的图片

import UIKit
import AssetsLibrary // iOS8以下用
import Photos  // >= ios8用

class MyImagePickerController:UICollectionViewController, UICollectionViewDelegateFlowLayout{

    fileprivate let cellId = "MyCollectionViewCell"
    fileprivate var totalGroups = [PHFetchResult<AnyObject>]() // 存相册的数组
    fileprivate var totalImages = [UIImage]() // 图片总数组
    fileprivate var firstImgs = [UIImage]() // 每个相册的第一个图片
    fileprivate var countOfGroup = [Int]() // 存放 每组相册的图片总数
    
    fileprivate let notiName = "MyImagePickerController_post_"
    fileprivate var images:[UIImage]? // 在MyAlbumViewController里点击了具体的相册后，进入此控制器以展示此相册所有的图片
    
    class func  getSelf(_ currentImages:[UIImage]?) -> MyImagePickerController{
        
        let name = "MyImagePickerController"
        let sb = UIStoryboard.init(name: name, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: name) as! MyImagePickerController
        vc.images = currentImages
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 数据不够一屏时，默认不滚动
        self.collectionView?.alwaysBounceVertical = true
        // 允许多选
        self.collectionView?.allowsMultipleSelection = true
        
        
        // 注册cell
        self.collectionView?.register(UINib.init(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
        
        addBackBtn()
        
        if images == nil { // 需要展示所有相册里的所有图片
            self.getAssetsGroup()
//            let fm = NSFileManager.defaultManager()
//            if !fm.fileExistsAtPath(kBundleDocumentPath()) {
//
//                
//            }else{
//                // 文件已存在，直接读取
//                if fm.isReadableFileAtPath(kBundleDocumentPath()) { // 可以读取
//                    let ary = NSArray.init(contentsOfFile: kBundleDocumentPath())
//                    totalImages = (ary as! Array)
//                }else{ // 无权读取
//                    
//                }
//            }

        }else{
            // 直接更新点击对应的相册里的所有图片
            
            
        }
        
        
        
    }

    fileprivate func addBackBtn(){
        
        // 添加返回按钮
        let backBtn = UIButton.init()
        backBtn.setImage(UIImage(named: "album_delete_btn"), for: UIControlState())
        backBtn.width = 20
        backBtn.height = 20
        backBtn.center = CGPoint(x: kwidth - 40, y: 30)
        
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.view.addSubview(backBtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: backBtn)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        if  images != nil { // 点击具体的相册进入此控制器，即从MyAlbumViewController进入
//            let dic = ["firstImgs":firstImgs, "countOfGroup":countOfGroup]
//            kNotificationCenter.postNotificationName(notiName, object: dic)
//        }
        let result = (totalImages as NSArray).write(toFile: totalImagesSavePath, atomically: true)
        if !result {
            debugPrint("存储图片失败！")
        }
    }
    
    // 1. 通过ALAssetsLibrary的实例方法得到ALAssetsGroup类数组
    /**
      1. 查询所有的相册
     */
    fileprivate func getAssetsGroup(){
        
//        let pl = PHPhotoLibrary.sharedPhotoLibrary()
//        let  status = PHPhotoLibrary.authorizationStatus()
//        
//        
//        if status == .Denied {
//            debugPrint("请到【设置-隐私-照片】打开访问开关")
//        } else if status == .Restricted {
//            debugPrint("无法访问相册")
//        } else {
//            // 保存相片的标识
//            var assetId = ""
//            
//            pl.performChanges({ 
//                // 保存相片到相机胶卷，并返回标识
//                if #available(iOS 9.0, *) {
//                    assetId = "dgdfv"
//                } else {
//                    
//                }
//                
//                }, completionHandler: { (success, error) in
//                    if !success {
//                        debugPrint("保存失败：\(error)")
//                        return
//                    }
//                    // 根据标识获得相片对象
//                    let asset = PHAsset.fetchAssetsWithLocalIdentifiers([assetId], options: nil).last
//                    // 拿到自定义的相册对象
//                    let collection = [self collection];
//                    if (collection == nil) return;
//                    
//            })
        
        // 遍历所有的自定义相册
        let collectionResult0:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        
        for i in 0..<collectionResult0.count {
            
            let collection = collectionResult0.object(at: i) 
            
            searchAllImagesInCollection(collection)
            
        }
        
        // 获得相机胶卷的图片
        let collectionResult1 = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        
        for i in 0..<collectionResult1.count {
            let collection = collectionResult1.object(at: i) 
            if !(collection.localizedTitle ==  "Camera Roll") {
                continue
            }
            searchAllImagesInCollection(collection)
            
        }
        
        // 获取存相册的 总数组
        totalGroups.append(collectionResult0 as! PHFetchResult<AnyObject>)
        totalGroups.append(collectionResult1 as! PHFetchResult<AnyObject>)
        
        
        
        self.collectionView?.reloadData()
    }
    
    // 2. ALAsset类根据相册获取该相册下所有图片，通过ALAssetsGroup的实例方法得到ALAsset类数组。
    /**
     2. 查询某个相册里面的所有图片
     */
    fileprivate func searchAllImagesInCollection(_ collection: PHAssetCollection) {
    
//        var assets = [ALAsset]()
//        dispatch_async(dispatch_get_main_queue()) {
//            group.enumerateAssetsWithOptions(.Reverse) { (asset, index, stop) in
//                
//                if asset != nil {
//                    
//                    // 过滤非图片
//                    if asset.valueForProperty(ALAssetPropertyType) as! String == ALAssetTypePhoto {
//                        assets.append(asset)
//                        
////                        let representation = asset.defaultRepresentation()
////                        // 获取资源图片的长宽
////                        let size = representation.dimensions
////                        // 获取资源图片的高清图
////                        let resolutionImage = representation.fullResolutionImage()
////                        //   获取资源图片的小图
////                        let smallImage = asset.thumbnail() // 图片的小图
////                        // 获取资源图片的全屏图
////                        let fullScreenImage = representation.fullScreenImage()
////                        
////                        // 获取资源图片的名字
////                        let  filename = representation.filename()
////                        
////                        
////                        // 缩放倍数
////                        let scale = representation.scale()
////                        // 图片资源容量大小
////                        let totalSize = representation.size()
////                        // 图片资源原数据
////                        let data = representation.metadata()
////                        // 旋转方向
////                        let direction = representation.orientation()
////                        
////                        // 资源图片url地址，该地址和ALAsset通过ALAssetPropertyAssetURL获取的url地址是一样的
////                        
////                        let  imageUrl = representation.url()
////                        // 资源图片uti，唯一标示符
////                        let tag = representation.UTI()
//                        
//                        
//                        
//                        // 打印图片的详细信息
//                        debugPrint("图片：\(asset.defaultRepresentation())")
//                    }
//                    
//                }
//                
//            }
        
//        }
//        self.totalImages += assets// 图片总数组
//        self.totalCount += assets.count // 图片总数
//     return assets
        
        var currentImgs = [UIImage]()
        // 采取同步获取图片（只获得一次图片）
        let imageOptions = PHImageRequestOptions.init()
        imageOptions.isSynchronous = true
        
        debugPrint("相册名字： \(collection.localizedTitle)")
        
        // 遍历这个相册中的所有图片
        let assetResult = PHAsset.fetchAssets(in: collection, options: nil)
        
        // 并行队列同步操作
        let myqueue = DispatchQueue(label: "myImagePicker.album.testQueue", attributes: DispatchQueue.Attributes.concurrent)
        
        myqueue.sync(execute: {
         for i  in 0..<assetResult.count {
            let asset = assetResult[i] 
            
            // 过滤非图片
            if asset.mediaType != .image {
                continue
            }
            
            // 图片原尺寸, 不用注释的代码，因为这样更快，不会死机(先固定此数，貌似越大越清晰,但越耗性能，启动越慢)
            let  targetSize = CGSize(width: 50, height: 50) // CGSizeMake(CGFloat(asset.pixelWidth), CGFloat(asset.pixelHeight))
            
            // 请求图片
            let imgManager = PHImageManager.default()
            
            imgManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: imageOptions, resultHandler: { (result, infoDic) in
                
                if result != nil{
//                    currentImgs.append(result!) // 总的图片，图片顺序为默认的即最先拍的在最前面
                    currentImgs.insert(result!, at: 0) // 总的图片，图片顺序为距现在最近拍的图片放在最前面
                    
//                    self.totalImages.append(result!) // 总的图片，图片顺序为默认的即最先拍的在最前面
                    self.totalImages.insert(result!, at: 0) // 总的图片，图片顺序为距现在最近拍的图片放在最前面
                }
            })
            
         }
            
            // 得到当前相册的第一个图片、 图片总数
            if currentImgs.count != 0{
//                self.firstImgs.append(currentImgs.last!)
                self.firstImgs.append(currentImgs.first!)
                
                self.countOfGroup.append(currentImgs.count)
            }
        })
        
    }
    
    
    // 必须写，一确定cell的大小，否则就会用默认的; 每行展示3故 cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (kwidth - 4 * 20)/3
        return CGSize(width: width, height: width)
    }
    
    // MARK: UICollectionViewDelegate, UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var  count = 0
        if images == nil {
            count = totalImages.count
        }else{
            count = images!.count
        }
        return count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MyCollectionViewCell
        
        if images == nil {
            cell.image = totalImages[indexPath.item]
        }else{
            cell.image = images![indexPath.item]
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        debugPrint("点击了\(indexPath.item)")
    }
    
    // ------------------------  private  ----------------------------- //
    
    // 右边的关闭按钮
    func backAction(_ btn:UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    
}


/*
 
 ALAsset类也可以通过valueForProperty方法查看不同属性的值，如：ALAssetPropertyType，asset的类型，有三种ALAssetTypePhoto, ALAssetTypeVideo or ALAssetTypeUnknown。
 另外还可以通过该方法获取ALAssetPropertyLocation（照片位置），ALAssetPropertyDuration（视频时间），ALAssetPropertyDate（照片拍摄日期）等。
 可以通过thumbnail方法就是获取该照片。
 
 */
