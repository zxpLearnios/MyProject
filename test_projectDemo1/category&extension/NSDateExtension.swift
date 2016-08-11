//
//  NSDataExtension.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/7/6.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  日期扩展
/*
 iOS8.0开始,NSCalendar增加了一些更为简单的判断日期的方法,如:
 - (BOOL)isDateInToday:(NSDate *)date  等等等等
 */

import UIKit

class NSDateExtension: NSObject {

}

extension NSDate {

//    enum DateFormatter:String {
//        case one = "yyyy-MM-dd HH:mm:ss"
//        case two = "yyyy-MM-dd"
//        case three = "yyyy-MM HH:mm:ss"
//    }
    
    /**
      1. 比较from和现在时间的时间差值  m y h m s
     */
    static func compareFromdate(from:NSDate) -> NSDateComponents {
        // 日历
        let calendar = NSCalendar.currentCalendar()
        
        // 比较时间  swift 中 |或运算符的写法 如下： 
//         NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond; // OC的写法
        let unit = NSCalendarUnit(arrayLiteral: [.Month, .Year, .Hour, .Minute, .Second])
        
        return calendar.components(unit, fromDate: from, toDate: NSDate(), options: .WrapComponents)
    }
    
    /**
      2. 比较fromDate和toDate的时间差值 m d y h m s
     */
    static func compareFromdate(fromDate:NSDate, toDate:NSDate) -> NSDateComponents {
        // 日历
        let calendar = NSCalendar.currentCalendar()
        
        // 比较时间  swift 中 |或运算符的写法 如下：
        //         NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond; // OC的写法
        let unit = NSCalendarUnit(arrayLiteral: [.Month, .Day, .Year, .Hour, .Minute, .Second])
        
        return calendar.components(unit, fromDate: fromDate, toDate: toDate, options: .WrapComponents)
    }
    
    /**
     *  3. 将时间字符串转换为格式化后的时间 "yyyy-MM-dd HH:mm:ss"
     *  NSDateFormatter的格式化时间的时区默认系统当前时区
     *  NSDate存储的时间格式为UTC时间,默认会将NSDate时间以系统当前时区（北京时区)转为UTC标准时间
     *  每次输出时间都应该指定目的时区的    GMT：格林尼治时间  UTC：世界标准时间
     *  时差是相对的而时间绝对，时区转换中NSDate是不需要变化的因为时间没有变，只是显示的时间改变，只需要改变NSDateFormatter关于时间12进制与24进制转换的部分下次补上
     *  传入的时间字符串默认的是 系统默认的格林尼治时区，故由此字符串得出的NSDate比传入的时间字符串的实际值早8小时
     */
    static func formatDateString(dateStr:String, byFormatter:String) -> NSDate? {
//        let local = NSLocale.init(localeIdentifier: "zh_CN")// NSLocale  zh_cn
        let local = NSLocale.currentLocale()
        
        // 目的时间的时区
        let destinationTimeZone = NSTimeZone.init(name: "Asia/Shanghai") // America/Los_Angeles
        
        let formatter = NSDateFormatter.init()
        formatter.locale = local
        formatter.dateFormat = byFormatter
        formatter.timeZone = destinationTimeZone
        
        let newDate = formatter.dateFromString(dateStr)
        
        // 传入的时间字符串是 2015-10-09 10:10:10，
        return newDate // 2015-10-09 02:10:10 +0000
    }
    
    /**
     *  4. 日历获取在9.x之后的系统使用currentCalendar会出异常。在8.0之后使用系统新API。
     */
    static func getCurrentCalendar() -> NSCalendar { // calendarIdentifier
        let x = Selector.init("calendarIdentifier")
        
        if NSCalendar.respondsToSelector(x) {
           return NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)!
        }
    
        return NSCalendar.currentCalendar()
    }
   
    /**
     5. 时间是否比传入的时间早
     */
    func  isEarlierThanDate(ompareToDate thanDate:NSDate) -> Bool {
        
        if self.compare(thanDate) == .OrderedAscending {
            return true
        }else{
            return false
        }
    }
    
    /**
     6. 时间是否比传入的时间晚
     */
    func  islatterThanDate(ompareToDate thanDate:NSDate) -> Bool {
        
        if self.compare(thanDate) == .OrderedDescending {
            return true
        }else{
            return false
        }
    }
    
    
    
}