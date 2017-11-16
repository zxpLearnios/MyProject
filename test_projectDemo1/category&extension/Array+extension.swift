
//
//  Array+extension.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/8/2.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  1. sortInPlace 的使用    2.

import UIKit

// 测试模型数据按时间进行排序
class TestSortOfModel: NSObject {
    
    var name:String?
    var creatTime:String?
    
    // 外加属性，以便使用
    var creatDate:Date?
    
    class func  getTestSortOfModels(withParams params:[[String:String]]) -> [TestSortOfModel]{
        var ary = [TestSortOfModel]()
        for dic in params {
            let model = TestSortOfModel.init(dic: dic as [String : AnyObject])
            ary.append(model)
        }
        return ary
    }
    
    convenience init(dic:[String:AnyObject]) {
        self.init()
        self.name = dic["name"] as? String
        self.creatTime = dic["creatTime"] as? String
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        self.creatDate = df.date(from: self.creatTime!)
    }
    
    
    
}


extension Array {
    
    
    /**
     1. 快速排序, 传入起点位置、结束点位置, 里面可以有相等的数字
     * 整型、浮点型皆可，但OC里，只能对整型数组进行排序，否则，无法实现效果的。OC数组里存的是NSNumber对象，在转为float是会出现精度偏差
     * 升序、 倒序
     */
    func quickSort(_ array:inout [CGFloat], left:Int, right:Int, isAscending:Bool){
        
        
        if left > right {
            return
        }
        
        var base, temp :CGFloat // 值
        var i , j:Int // 位置
        i = left
        j = right
        
        base = array[left]
        
        if isAscending { // 升序
            
            while i != j {
                // 顺序很重要，要先从右边开始找
                while array[j] >= base && i < j {
                    j -= 1
                }
                // /再找左边的
                while array[i] <= base && i < j {
                    i += 1
                }
                // 交换两个数在数组中的位置
                if i < j {
                    
                    temp = array[i]
                    
                    array[i] = array[j]
                    
                    array[j] = temp
                    
                }
                
            }
            // 确定第left位置处的值，此时是升序，故它是最小值
            // 确定第i位置处的值，此时是升序，故它肯定 >= 第left位置处的值
            
            // 此时 i = j,最终将基准数归位
            array[left] = array[i]
            array[i] = base
            
        }else{ // 降序
            while i < j {
                
                while array[j] <= base && i < j {
                    j -= 1
                }
                
                while array[i] >= base && i < j {
                    i += 1
                }
                
                if i < j {
                    
                    temp = array[j]
                    
                    array[j] = array[i]
                    
                    array[i] = temp
                    
                }
                
            }
            
            array[left] = array[j]
            array[j] = base
            
        }
        
        quickSort(&array, left: left, right: i - 1, isAscending: isAscending) // /继续处理左边的，这里是一个递归的过程
        quickSort(&array, left: i + 1, right: right, isAscending: isAscending) // /继续处理左边的，这里是一个递归的过程
        
    }
    
    /**
     * 2. 二分插入排序, 里面可以有相等的数字
     */
    func binarySort(_ array : inout Array<CGFloat>, isAscending:Bool){
        
        var low, mid, high : Int
        var base : CGFloat
        
        if isAscending { // 升序
            for i in 1 ... array.count - 1{
                
                low = 0
                
                high = i - 1
                
                base = array[i]
                
                while low <= high {
                    
                    mid = (low + high)/2
                    
                    if array[mid] >= base{
                        low = mid + 1
                    }else if array[mid] <= base{
                        high = mid - 1
                    }
                    
                }
                
                var j = i - 1
                while j >= high + 1 {
                    array[j + 1] = array[j]
                    j -= 1
                }
                
                array[high + 1] = base
                
            }

        }else{ // 降序
            for i in 1 ... array.count - 1{
                
                low = 0
                high = i - 1
                base = array[i]
                
                while low <= high {
                    
                    mid = (low + high)/2
                    
                    if array[mid] <= base{
                        low = mid + 1
                    }else if array[mid] >= base{
                        high = mid - 1
                    }
                    
                }
                
                var j = i - 1
                while j >= high + 1 {
                    array[j + 1] = array[j]
                    j -= 1
                }
                
                array[high + 1] = base
                
            }
        }
       
        
        
    }
    
    
   
    /**
     排序模型数组，按模型里的时间先后排序; 可以按模型里的某一属性排序
     */
    func bubbleSortByDate(modelArray models: [TestSortOfModel]) -> [TestSortOfModel] {
        var newAry = models
        
        newAry.sort { (ml0, ml1) -> Bool in
            if ml0.creatDate!.isEarlierThanDate(compareToDate: ml1.creatDate!) {
                return true  // 表示排序
            }
            return false
            
        }
        return newAry
        
    }
    
    /**
     *   3.冒泡排序, 时间先后排序
     */
    func bubbleSortByDate(_ array:[TestSortOfModel]) -> [TestSortOfModel] {
        var modelAry = array
        for i in 0..<modelAry.count { // 总的比较（循环）次数
            
            for j in 0 ..< (modelAry.count - 1 - i) { // 每次比较（循环）中共需要比较的次数
                
                let subModel0 = modelAry[j]
                let subModel1 = modelAry[j+1]
                if  subModel0.creatDate!.isEarlierThanDate(compareToDate:subModel1.creatDate!) {
                    
                }else{
                    modelAry[j+1] = subModel0
                    modelAry[j] = subModel1
                }
                
                
            }
            
            
        }
        
        return modelAry
    }
    
    

}
