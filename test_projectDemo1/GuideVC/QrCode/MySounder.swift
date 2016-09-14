//
//  MySounder.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/9/14.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  播放音频

import UIKit
import AudioToolbox

class MySounder: NSObject {
    
    // 1000-2000 之间数字时就是播放系统声音
    class func playSystemSound(soundID id:UInt32){
        let  soundID:SystemSoundID =  id // 1007
        AudioServicesPlaySystemSound(soundID)
    }
    
    
    class func playQrCodeScanCompleteSound(){
        //声音地址
        let path = NSBundle.mainBundle().pathForResource("scanQrCodeCompleteSound", ofType: "wav")
        //建立的systemSoundID对象
        var soundID : SystemSoundID = 0
        let baseURL = NSURL.fileURLWithPath(path!)
        //赋值
        AudioServicesCreateSystemSoundID(baseURL, &soundID)
        //播放声音
        AudioServicesPlaySystemSound(soundID)
    }
}
