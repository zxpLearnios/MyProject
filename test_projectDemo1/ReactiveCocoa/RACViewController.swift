//
//  RACViewController.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 2017/5/16.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  reactive rac 的使用
//  1. RAC能使注册监听和监听后的须做的处理放在一起，实现了高聚合、低耦合
//  2. 在viewDidLoad里，监听之后，只有textField或按钮被点击了就会触发回调，实现实时更新即热响应

import UIKit

import ReactiveCocoa
import ReactiveSwift
import Result

class RACViewController: UIViewController {

    @IBOutlet weak var accountField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var accountLab: UILabel!
    
      /**signal：输出   obser：输入*/
    let (signal, obser) = Signal<Any, NoError>.pipe() // 信号管道
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. 监听文本框
        // 监听输入时的文字
        weak var wself = self // 在closure外的弱引用
//            { [weak self] in  Mylog("这是closure内的弱引用") }
        
//        accountField.reactive.continuousTextValues.observeValues { (text) in
//            wself?.accountLab.text = text
//            MyLog("输入的账号为：%@", text ?? "")
//        }
//        
//        // 
//        pwdField.reactive.controlEvents(.editingChanged).observeValues { textField in
//        
//            MyLog(textField.text)
//        }
//        
//        // 2. 监听按钮的点击
        loginBtn.reactive.controlEvents(.touchUpInside).observeValues { _  in
            wself?.view.endEditing(true)
            MyLog("按钮了登录点击")
            
            // 测试代理
            wself?.obser.send(value: "点击按钮后发送信息")
        }
        
        // 3. 监听label
//        let nameStr = accountLab.reactive.signal(for: #selector(signalFromLabel))
        
        // 4. 
        
        let time = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time) {
            
            //        wself?.createSignalMehods()
            //        wself?.signZip()
//            wself?.testScheduler()
            
            // 测试代理
//            wself?.testDelegate()
//            wself?.testNoti()
//            wself?.testKVO()
            wself?.testIterator()
        }
        
        
        
    }
    
    
    // MARK: - 0.创建信号的方法
    func createSignalMehods() {
        // 1.通过信号发生器创建(冷信号)
//        let producer = SignalProducer<String, NoError>.init { (observer, _) in
//            MyLog("新的订阅，启动操作")
//            observer.send(value: "Hello")
//            observer.send(value: "World")
//        }
//        
//        let subscriber1 = Observer<String, NoError>(value: { print("观察者1接收到值 \($0)") })
//        let subscriber2 = Observer<String, NoError>(value: { print("观察者2接收到值 \($0)") })
//        
//        MyLog("观察者1订阅信号发生器")
//        producer.start(subscriber1)
        
//        MyLog("观察者2订阅信号发生器")
//        producer.start(subscriber2)
        
        
        //注意：发生器将再次启动工作
        
        // 2.通过管道创建（热信号）
//        let (signalA, observerA) = Signal<String, NoError>.pipe()
//        let (signalB, observerB) = Signal<String, NoError>.pipe()
//        
//        
//        // 合并信号
//        Signal.combineLatest(signalA, signalB).observeValues { (value) in
//            MyLog( "收到的值\(value.0) + \(value.1)")
//        }
//    
//        
//        observerA.send(value: "1")
//        observerA.sendCompleted()
//        
//        observerB.send(value: "2")
//        observerB.sendCompleted()
    }
    
    // MARK: - 1.信号联合
    func signZip() {
        let (signalA, observerA) = Signal<String, NoError>.pipe()
        let (signalB, observerB) = Signal<String, NoError>.pipe()
        
        Signal.zip(signalA, signalB).observeValues { (value) in
            MyLog( "收到的值\(value.0) + \(value.1)")
        }
        
        signalA.zip(with: signalB).observeValues { (value) in
            
        }
        observerA.send(value: "1")
        observerA.sendCompleted()
        observerB.send(value: "2")
        observerB.sendCompleted()
        
    }
    
    // MARK: - 2.Scheduler(调度器)
    func testScheduler() {
        // 主线程上延时0.3秒调用
        QueueScheduler.main.schedule(after: Date.init(timeIntervalSinceNow: 0.3)) {
            MyLog("主线程调用")
        }
        
        QueueScheduler.init().schedule(after: Date.init(timeIntervalSinceNow: 0.3)){
            MyLog("子线程调用")
        }
        
    }
    
    
    // MARK: - 3.Delegate
    func testDelegate() {
        signal.observeValues { (value) in
            MyLog("测试代理--\(value)")
        }
    }
    
    
    // MARK: - 4.通知
    func testNoti() {
        // 4.1 普通的通知方法
//        NotificationCenter.default.reactive.notifications(forName: Notification.Name(rawValue: "home")).observeValues { (value) in
//            debugPrint((value.object as? AnyObject) ?? "")
//        }
//        
//        let dicInfo = ["name": "测试通知", "value": "通知的内容"]
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "home"), object: dicInfo)
        
        // 4.2 键盘的通知
//        NotificationCenter.default.reactive.notifications(forName: Notification.Name(rawValue: "UIKeyboardWillShowNotification" ), object: nil).observeValues { (value) in
//            MyLog("键盘弹起")
//        }
//        NotificationCenter.default.reactive.notifications(forName: Notification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil).observeValues { (value) in
//            MyLog("键盘收起")
//        }
    }
    
    // MARK: - 5.KVO
    func testKVO() {
        let result = self.view.reactive.values(forKeyPath: "bounds")
        result.start { [weak self](rect) in
            MyLog(self?.view ?? "")
            MyLog(rect)
        }
    }
    
    // MARK: - 6.迭代器
    func testIterator() {
        
        
        let array:[String] = ["name","name2"]
        var arrayIterator =  array.makeIterator()
        
        // 1. 数组的迭代器
//        while let temp = arrayIterator.next() {
//            MyLog(temp)
//        }
        
        // 1.1. swift 系统自带的遍历
//        array.forEach { (value) in
//            MyLog(value)
//        }

//
        let dict:[String: String] = ["key":"name", "key1":"name1"]
        var dictIterator =  dict.makeIterator()
        
        // 3. 字典的迭代器
        while let temp = dictIterator.next() {
            MyLog(temp)
        }
        
//        // 3.1 swift 系统自带的遍历
        dict.forEach { (key, value) in
            MyLog("\(key) + \(value)")
        }
        
        
    }
    
    
}


