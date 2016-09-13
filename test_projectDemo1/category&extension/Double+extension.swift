//
//  Double+extension.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/9/13.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit

class Double_extension: NSObject {

}


extension Double {

    /**
     将传入的数字串  从右至左3位一空格
     */
    func formateObjToString(obj: Double) -> String {
        let formatter =  NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        //        NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt:123456789]];
        return formatter.stringFromNumber(NSNumber.init(double: obj))!
    }
    
    
}
