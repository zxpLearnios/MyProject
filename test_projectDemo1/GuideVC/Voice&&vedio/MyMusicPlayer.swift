//
//  MyMusicPlayer.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/6/16.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  播放音频
//  1. AVPlayer、AVAudioPlayer 播放本地都可以（不需要AVPlayerItem）；2.AVPlayer播放远程音频，必须是打开就播放的那种；
//  3.

import UIKit
import AVFoundation

class MyMusicPlayer: AVPlayer {

    fileprivate var  musicPlayer:AVAudioPlayer!, voicePlayer:AVPlayer!, playeItem:AVPlayerItem!
    
    
    override init() {
        super.init()
        // 1.
        let str = "http://m2.music.126.net/feplW2VPVs9Y8lE_I08BQQ==/1386484166585821.mp3" // http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4
        let onlineUrl = URL.init(string: str)
        playeItem = AVPlayerItem.init(url: onlineUrl!)
        voicePlayer = AVPlayer.init(url: onlineUrl!) // 播放网络音频
        
        // 2.
        let path = Bundle.main.path(forResource: "背叛情歌.mp3", ofType: nil)
        let localUrl = URL(fileURLWithPath: path!)
//        musicPlayer = try! AVAudioPlayer.init(contentsOfURL: localUrl) // 播放本地音频
//        voicePlayer = AVPlayer( localUrl) // 播放本地音频
    }
    
    override func play() {
        super.play()
//        musicPlayer.play()
        voicePlayer.play()
    }
    
    override func pause() {
        super.pause()
//        musicPlayer.pause()
        voicePlayer.pause()
    }
    
//    class func playLocalMusicResource(){
//        let url = NSBundle.mainBundle().pathForResource("背叛情歌.mp3", ofType: nil)
//        musicPlayer = try! AVAudioPlayer.init(contentsOfURL: NSURL.fileURLWithPath(url!))
//    }
}
