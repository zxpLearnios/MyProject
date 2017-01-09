//
//  MyVideoPlayerView.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/6/20.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  AVPlayer  MPMoviePlayerController

import UIKit
import AVFoundation
import MediaPlayer

class MyVideoPlayerView: UIView {
    
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var currentTimeLab: UILabel!
    @IBOutlet weak var totalTimeLab: UILabel!
    
    var ishow = false // 是否显示底部view
    
    @IBOutlet weak var buttomView: MyLoadProgressView!
    
    @IBOutlet weak var loadProgressView: UIProgressView! // 缓冲进度
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! // 菊花进度
   
    fileprivate var  avPlayer:AVPlayer!, playerLayer:AVPlayerLayer!, avPlayItem:AVPlayerItem!, avObserver:AnyObject!, mmPlayer:MPMoviePlayerController!
    fileprivate var loadedTimeRanges = "loadedTimeRanges", status = "status", timer:Timer?, totalBuffer:Float64 = 0 // 默认值
    // http://v1.mukewang.com/19954d8f-e2c2-4c0a-b8c1-a4c826b5ca8b/L.mp4 http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4
    fileprivate let vedioStr = "http://v1.mukewang.com/19954d8f-e2c2-4c0a-b8c1-a4c826b5ca8b/L.mp4",
    voiceStr = "http://m2.music.126.net/feplW2VPVs9Y8lE_I08BQQ==/1386484166585821.mp3"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // 0.
        slider.setThumbImage(UIImage(named: "thumbImage"), for: UIControlState())
        slider.setMinimumTrackImage(UIImage(named: "MinimumTrackImage"), for: UIControlState())
//        slider.setMaximumTrackImage(UIImage(named: "MaxmumTrackImage"), forState: .Normal)
        
        
        
        // 2. AVPlayer 因为开始就初始化了播放器，故一开始就会加载而不是在播放时
        let str = vedioStr  // voiceStr  vedioStr
        let onlineUrl = URL.init(string: str)
        avPlayItem = AVPlayerItem.init(url: onlineUrl!)
        
//         let str = NSBundle.mainBundle().pathForResource("本地视频.mov", ofType: nil)! // 本地视频
//        avPlayItem = AVPlayerItem.init(URL: NSURL.init(fileURLWithPath: str)) // 本地视频
        
        avPlayer = AVPlayer.init(playerItem: avPlayItem) // 播放网络音频
        
        playerLayer = AVPlayerLayer.init(player: avPlayer)
        playerLayer.videoGravity = AVLayerVideoGravityResize // 使播放layer填满整个view
        self.layer.insertSublayer(playerLayer, below: buttomView.layer)
        
        
        // 2.1  MPMoviePlayerController
        
//        mmPlayer = MPMoviePlayerController.init(contentURL: onlineUrl!)
//        mmPlayer.scalingMode = .Fill // 填满整个vie
//        self.buttomView.hidden = true // 此时底部view无用了，因为它自带了进度slider
//        self.insertSubview(mmPlayer.view, belowSubview: buttomView)
       
        
        // 3. 监听播放器的进度
        // 方法传入一个CMTime结构体，每到一定时间都会回调一次，包括开始和结束播放
        // 如果block里面的操作耗时太长，下次不一定会收到回调，所以尽量减少block的操作耗时
        // 方法会返回一个观察者对象，当播放完毕时需要移除这个观察者
        
        self.avObserver = self.avPlayer.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1), queue: DispatchQueue.main) { (time) in
            let preCurrentTime = String(format: "%02.0f",CMTimeGetSeconds(self.avPlayItem.currentTime())) // 取0位小数
            let preTotalTime = String(format: "%02.f",self.avPlayItem.duration.seconds)
            
            let currentTime = Int(preCurrentTime)!
            let totalTime = Int(preTotalTime)! - 1
            
            // 总时间label
            self.totalTimeLab.text = self.getFormatedTimeWithIntSeconds(totalTime)
            
        } as AnyObject!
        
        // 4. 媒体加载状态
        avPlayItem.addObserver(self, forKeyPath: status, options: .new, context: nil)
        avPlayItem.addObserver(self, forKeyPath: loadedTimeRanges, options: .new, context: nil)
        
        // 5.隐藏底部view
        UIView.animate(withDuration: 0.25, animations: {
            self.buttomView.transform = CGAffineTransform(translationX: 0, y: 40)
        }) 
    }
    
    // MARK:   slider滑动时 avPlayItem.duration.seconds 总长度
    @IBAction func valueChangedAction(_ sender: UISlider) {
        let currentTime  = avPlayItem.duration.seconds * Double(slider.value)
        self.currentTimeLab.text = self.getFormatedTimeWithIntSeconds(Int(currentTime))
    }
    // MARK:  点击slider时
    @IBAction func touchDownAction(_ sender: UISlider) {
        avPlayer.pause()
        self.stopTimer()
        
    }
    
    // MARK:  点击slider结束时
    @IBAction func insideAction(_ sender: UISlider) {
        
        self.startTimer()
        // 3. 设置播放器播放进度 CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC)
        let currentTime  = avPlayItem.duration.seconds * Double(slider.value)
        let  timeInterval = TimeInterval.init(currentTime)
        avPlayer.seek(to: CMTime.init(seconds: timeInterval, preferredTimescale: 1), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler: { (finished) in
            
        }) 
        avPlayer.play()
    }
    
    
    
    
    // MARK: 开启定时器
    fileprivate func startTimer(){
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeCurrentTime), userInfo: nil, repeats: true)
        
    }
    
    // MARK: 关闭定时器
    fileprivate func stopTimer(){
        timer!.invalidate()
        timer = nil
    }
    
    // MARK:  定时器, 改变slider的值
    @objc fileprivate func changeCurrentTime(){
        // 1.
        slider.value += Float(1/avPlayItem.duration.seconds)
        
        // 2.
        let currentTime  = avPlayItem.duration.seconds * Double(slider.value)
        self.currentTimeLab.text = self.getFormatedTimeWithIntSeconds(Int(currentTime))
        
       
    }
    
    // MARK: 播放按钮事件
    @IBAction func playAction(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            avPlayer.play()
//            mmPlayer.play()
            // 5. 定时器
            self.startTimer()
        }else{
            avPlayer.pause()
            self.stopTimer()
        }
        
    }
    
    // MARK: 旋转屏幕
    @IBAction func rotationAction(_ btn: UIButton) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !ishow {
            UIView.animate(withDuration: 0.25, animations: {
                self.buttomView.transform = CGAffineTransform.identity
            }) 
            ishow = true
        }else{
            UIView.animate(withDuration: 0.25, animations: {
                self.buttomView.transform = CGAffineTransform(translationX: 0, y: 40)
            }) 
            ishow = false
        }
        
    }
    
    // MARK: KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == status {
            switch avPlayer.status { //  
            case .unknown:
                print("KVO：未知状态，此时不能播放")
            case .readyToPlay:
                 print("KVO：准备完毕，可以播放")
                
            case .failed:
                print("KVO：加载失败，网络或者服务器出现问题")
            }
        }
        
        if keyPath == loadedTimeRanges {
            let  loadAry = avPlayItem.loadedTimeRanges
            let  timeRange = loadAry.first?.timeRangeValue //本次缓冲的时间范围
            totalBuffer = CMTimeGetSeconds(timeRange!.start) + CMTimeGetSeconds(timeRange!.duration) //缓冲总长度
            
            // 绘制缓冲进度
            loadProgressView.setProgress(Float(totalBuffer), animated: true)
    
            if totalBuffer > 0 {
                activityIndicator.stopAnimating()
            }
            
        }
    }
    
    
    // MARK: ***************  private  *******************//
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = self.bounds
//         mmPlayer.view.frame = self.bounds
    }
    
    deinit{
        avPlayer.removeTimeObserver(avObserver)
    }
    
    // MARK: private
    /**  传一个INt型的总秒数，得到hh:mm:ss的字符串 */
    fileprivate func getFormatedTimeWithIntSeconds(_ totalTime:Int) -> String {
        var hour = ""
        var minuter = ""
        var seconds = ""
        
        var shang = 0
        var yushu = 0
        
        let str = "00:"
        
        shang = totalTime / 3600
        
        
        if shang == 0 { // <1小时
            hour = str
            shang = totalTime / 60
            
            if shang == 0 { // <1分钟
                minuter = str
                seconds = String(format: ":%02d",totalTime) // 取2位，不足的补0
            }else{
                yushu = totalTime % 60
                minuter = String(format: "%02d:",shang)
                seconds = String(format: "%02d",yushu)
            }
            
        }else{ // >1小时
            hour = String(format: "%02d:",shang)
            
            yushu  = totalTime % 3600
            
            if yushu < 60 { // 不足1分钟
                minuter = str
                seconds = String(format: "%02d",yushu)
            }else{
                shang = yushu / 60
                yushu = yushu % 60
                
                minuter = String(format: "%02d:",shang)
                seconds = String(format: "%02d",yushu)
            }
            
        }
        
        return hour + minuter + seconds

    }
}
