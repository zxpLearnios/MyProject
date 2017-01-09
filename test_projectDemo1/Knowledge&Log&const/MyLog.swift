//
//  MyLog.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/7/6.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  1. 在开发过程中，我们可以用 NSLog 肆无忌惮地向终端输出各种信息；正式版本可不能这样了，不然用户手机的 Console 会被你的 Log 塞满，不仅影响性能，可能还会暴露不必要的一些开发信息。

import UIKit

func MyLog(_ items: Any...) {
    #if DEBUG
        debugPrint(items)
    #else
//        print(items)
    #endif
}





