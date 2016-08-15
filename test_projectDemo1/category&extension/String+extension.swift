//
//  String+extension.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/15.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit


extension String{

    /**
     *  去掉前后所有的空格
     */
    static func deleteBlankFromHeadAndTail(primordailStr str:String) -> String {
        let newStr = str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        return newStr
    }

}
