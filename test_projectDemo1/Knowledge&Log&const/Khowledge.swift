//
//  khowledge.swift
//  test_projectDemo1
//
//  Created by Jingnan Zhang on 16/7/6.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  swift的一些知识
//   耗时操作不要直接放在init里，除非初始化后，后面不再用此对象，则是可以写在init里的。

import UIKit

final class Khowledge: NSObject {
    
    /* 1.
     public internal(set) var JSONDictionary: [String : AnyObject] = [:]
     public internal(set) var isKeyPresent = false  
     */
    
    private(set) var isKeyPresent = false // 对外部只读，对内可读写
    override init() {
        // 2. map 映射  filter
        var numbers = [1,2,3,4]
        
        numbers.sort()
        let result = numbers.map { $0 + 2 }
        print(result)  // [3,4,5,6]
        
        let stringResult = numbers.map { "No. \($0)" }
        print(stringResult) // ["No. 1", "No. 2", "No. 3", "No. 4"]
        
        let result0 = numbers.filter { $0 >= 2} // 数组中>=2 的元素

        // 3. flatMap
        let result1 = numbers.flatMap { $0 + 2 }
         print(result1) //  = [3,4,5,6]
        
        // 4.  flatMap 与 map的区别
        let numbersCompound = [[1,2,3],[4,5,6]];
        let res = numbersCompound.map { $0.map{ $0 + 2 } }
        print(res) // [[3, 4, 5], [6, 7, 8]]
        
        let flatRes = numbersCompound.flatMap { $0.map{ $0 + 2 } }
        print(flatRes)  // [3, 4, 5, 6, 7, 8]
        
        let optionalArray: [String?] = ["AA", nil, "BB", "CC"];
        var optionalResult = optionalArray.flatMap{ $0 } // flatMap 调用后类型变成了[String], ["AA", "BB", "CC"]，flatMap 实现了过滤掉nil值
        let mapOptionalRes = optionalArray.map{$0} // map 后 ，[Optional("AA"), nil, Optional("BB"), Optional("CC")]
        
        
        // 5. 多线程 队列
        
        // object 参数传入nil
//        let aniThread = NSThread.init(target: self, selector: #selector(), object: "第一种线程，需自行启动")
        //        NSThread.detachNewThreadSelector(#selector(judgeIsSelected), toTarget: self, withObject: "第二种线程，自动启动")
        //        self.performSelectorInBackground(#selector(judgeIsSelected), withObject: "第三种线程，隐式创建/在后台线程中执行===在子线程中执行")
//        aniThread.name = "判断选中与否的线程"
//        aniThread.start()
        
        // 串行队列
//        let queue0 = dispatch_queue_create("tk.bourne.testQueue", nil);
//        let queue1 = dispatch_queue_create("tk.bourne.testQueue", DISPATCH_QUEUE_SERIAL)
//        // 并行队列
//        let queue2 = dispatch_queue_create("tk.bourne.testQueue", DISPATCH_QUEUE_CONCURRENT)
//        // 全局并行队列(同步、异步都在主线程中，前者不会死锁)
//        let queue3 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        // 6. guard （判断）的使用
//        let b:Int? = nil
//        guard let a = b else{ // 即若 b不为nil，则执行else前面的；否则，执行else的内容（b可以是一个式子）
//            print("b == nil")
//            return
//        }
//        
//        print(a)
    }
    
}


class Person:NSObject{

    var name = ""
    weak var part:Part! // 避免了循环引用， 且part属性此时可以为空
    // 1. unowned的第一种做法
//    unowned var part:Part // 此时不能用 Part?或 Part!，只能用Part类型了
//    init(part:Part) {
//        self.part = part
//    }
    // unowned的第二种做法
//    unowned var part:Part {
//        return Part()
//    }
    override init() {
        
    }
    
    deinit{
        print("person被释放了")
    }
}

class Part: NSObject {
    var person:Person!
    
    override init() {
        
    }
    
    deinit{
        print("part被释放了")
    }
}


/*
 1. warn_unused_result你可以为方法添加这个属性，这样当你对函数不正确调用，或者调用该方法却没有使用它的结果时，就会获得提醒。message 参数用来提供当你调用方法却没使用结果时编译器给出的警告。mutable_varient 用来提供你所使用的non mutating 方法的mutating 版本方法的名字。
    比如，Swift标准库里面提供mutating 方法SortInPlace() 和 non mutating方法 sort() 如果你调用sort() 但却并没有用到它的结果，编译器就会猜测你想用的是SortInPlace()。
 
 2. 将类声明为final，说明它是不能被继承的； 类中的方法若用final修饰，则说明此法不可被子类重写（保证了有子类继承的情况下，父类中的某些方法仍可以继续被父类执行）；类中的属性若用final修饰，则说明此属性不可被子类重写。public internal(set) var value = "11", 即在本项目里可以set，在外项目里用不可set
 
 3. swift 2.0 后， [1.public:可以被模块外访问, 写cocopods时有用 2.internal：可以被本模块访问 3.private：可以被本文件访问]
 
 4. @noescape .    现在很多函数式编程，比如有个排序，需要一个比较的closure作为参数，这种closure都会是同步调用完毕获得返回值。这种可以放一个@noescape在前面，可优化内存，引用self不必写self。其他的closure在外部引用着等待将来回掉用的则不能@noescape，因为它会escape。总体来说这个@noescape没啥卵用，但是有些人会用，可能会吓到你，这个基本可以无视.
 
 5. typealias Item = T 定义类型，
 
 6. map 方法接受一个闭包作为参数， 然后它会遍历整个 numbers 数组，并对数组中每一个元素执行闭包中定义的操作。 相当于对数组中的所有元素做了一个映射。 操作二维数组时，flatMap 和 map 无区别。 flatMap 依然会遍历数组的元素，并对这些元素执行闭包中定义的操作。 但唯一不同的是，它对最终的结果进行了所谓的 “降维” 操作。 本来原始数组是一个二维的， 但经过 flatMap 之后，它变成一维的了。  map 函数值对元素进行 变换 操作。 但不会对数组的 结构 造成影响。
 
 * 7. 
 7.1 弱引用
     注意弱引用必须被声明为变量，表明其值能在运行时被修改。弱引用不能被声明为常量。
     因为弱引用可以没有值，你必须将每一个弱引用声明为可选类型。在 Swift 中，推荐使用可选类型描述可能没有值的类型。
     因为弱引用不会保持所引用的实例，即使引用存在，实例也有可能被销毁。因此，ARC 会在引用的实例被销毁后自动将其赋值为nil
     。你可以像其他可选值一样，检查弱引用的值是否存在，你将永远不会访问已销毁的实例的引用。
 
 7.2 无主引用
     和弱引用类似，无主引用不会牢牢保持住引用的实例。和弱引用不同的是，无主引用是永远有值的。因此，无主引用总是被定义为非可选类型（non-optional type）。你可以在声明属性或者变量时，在前面加上关键字unowned
     表示这是一个无主引用。
     由于无主引用是非可选类型，你不需要在使用它的时候将它展开。无主引用总是可以被直接访问。不过 ARC 无法在实例被销毁后将无主引用设为nil
     ，因为非可选类型的变量不允许被赋值为nil，注意如果你试图在实例被销毁后，访问该实例的无主引用，会触发运行时错误。使用无主引用，你必须确保引用始终指向一个未销毁的实例。还需要注意的是如果你试图访问实例已经被销毁的无主引用，Swift 确保程序会直接崩溃，而不会发生无法预期的行为。所以你应当避免这样的事情发生。
 
 原文链接：http://www.jianshu.com/p/e1025f722377
 
 8. var a:UIView?  ===  var b:UIView!  即二者都是nil，因为未初始化, 即此时打印b就会提示found nil；基本数据类型如Int也一样的。
 
 
 9. CoreText是的iOS3.2+和OSX10.5+中的文本引擎，让您精细的控制文本布局和格式。它位于在UIKit中和CoreGraphics/Quartz之间的最佳点。 UIKit中你有的文本空间，你可以通过XIB简单的使用文本控件在屏幕上显示文字，但你不能改变个别字的颜色。
 CoreGraphics/Quartz你可以做几乎可以胜任所有的工作，但是你需要计算每个字形的在文本中的位置，并绘制在屏幕上。*
 
 CoreText正好位于两者之间！你可以完全控制位置，布局，属性，如颜色和大小，但CoreText布局需要你自己管理-从自动换行到字体渲染等等。 原文链接：http://www.jianshu.com/p/dacb99506bb9
 
 
 10. Images.xcassets中的图片资源只能通过imageNamed:方法加载，通过NSBundle的pathForResource:ofType:无法获得图片路径。因此，Images.xcassets只适合存放系统常用的，占用内存小的图片资源。
 
 11. Range 的使用：  let range = Range.init(str.startIndex.advancedBy(2) ..< str.startIndex.advancedBy(7))
 
 12. dump(obj) // 打印出某个对象的信息；数组遍历、找出其中的最值ary.enumerate() ,ary.maxElement()；ary.sort() 将数组元素（如数组里全部是数字、全部是字母、）按升序排序； let ary = ["a", "be", "ba", "e", "a1"] // print(ary.sort()):["a","a1","ba","be","e"]；print(ary.sort({$0 > $1}))，则为按倒序排。
 
 13. 因为在Swift中，struct都是按值传递，class是按引用传递；数组和字典都是struct, 故引入了inout关键字。
 
 14. Any是一个空协议集合的别名，它表示没有实现任何协议，因此它可以是任何类型，包括类实例与结构体实例。Any是一个别名。
    AnyObject是一个成员为空的协议，任何对象都实现了这个协议。
    AnyClass是AnyObject.Type的别名而已。
 
 15. 三目运算符要分开， let b = (a == 0) ? "a" : "b"
 
 16. MVVM:  VC里只有页面逻辑，VM里包含所有业务逻辑, 这样VM就可以单独进行单元测试了；
 
 17. 单例写法看MyGifView。
 
 18. // 闭包的写法
 typealias colsure = (str:String) -> Void // typealias colsure = (str:String) -> () ,可将没返回值的方法传过去
 var colsure1:((str:String) -> String) = {str in return str }
 let colsure2:((str:String) -> String) = {str in return str + "你好"}
 
 19. 对于键盘退出的看test里的工程以及UFO里设置密码的xib，注意有无nav时的情况是不一样的
 
 20. static 与 class 的又一区别： 一个了写了个如  static func model(withJsonObj obj:AnyObject?) -> Mappable? {} 的方法，则此法不能被子类重写，因为它默认是final的， 但用class修饰后就可被重写了。
 
         {  对ObjectMapper
         let dic = ["sub": "base----"]
         
         do{
         
         let obj = try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions.init(rawValue: 2))
         
         let json = try NSJSONSerialization.JSONObjectWithData(obj, options: .AllowFragments)
         
         let subModel = Subclass.model(withJsonObj: json) as? Subclass
         
         debugPrint(subModel!.sub)
         
         
         }catch{
         
         
         }
         

         }
 
 21. webView 不能加载Asses里的图片，把Asses放在一个文件夹下面然后逐步获取，不知是否可以
 
 22. 自定义只读数据的情况, 有以下四种形式：
 
         let testInt = {   // closure
         return 3
         }()
         
         var testInt1:Int { // var
         return 1
         }
 
        func testInt2 -> Int {   return  3  }
 
        lazy var testInt3:Int  = { return  3  }()
 
 
 
 23. 结构体
 　　1 结构题的属性必须初始化,必须有默认值或者通过构造器init
 　　2 结构体本身是值传递,如果一个结构体赋值给另外一个结构体了也是两份拷贝,互相修改不会有影响
 
 
 24.  手势
 UIPanGestureRecognizer（拖动）  UIPinchGestureRecognizer（捏合） UIRotationGestureRecognizer（旋转） UITapGestureRecognizer（点按）  UILongPressGestureRecognizer（长按） UISwipeGestureRecognizer（轻扫）
 
 
 
 */


/**************   多线程的  *********************
 0. NSThread创建线程方式，是经过苹果封装后的，并且完全面向对象的；但是，它的生命周期还是需要我们手动管理，所以这套方案也是偶尔用用；NSThread 用起来也挺简单的，因为它就那几种方法。同时，我们也只有在一些非常简单的场景才会用 NSThread
 1. GCD 是苹果为多核的并行运算提出的解决方案，所以会自动合理地利用更多的CPU内核（比如双核、四核），最重要的是它会自动管理线程的生命周期（创建线程、调度任务、销毁线程），完全不需要我们管理，我们只需要告诉干什么就行。
 1.0
 任务：即操作，你想要干什么，说白了就是一段代码，在 GCD 中就是一个 Block，所以添加任务十分方便。任务有两种执行方式： 同步执行 和 异步执行
 1.1
 队列：用于存放任务。一共有两种队列， 串行队列 和 并行队列。
 1.2
 如果是 同步（sync） 操作，它会阻塞当前线程并等待 Block 中的任务执行完毕，然后当前线程才会继续往下运行。
 如果是 异步（async）操作，当前线程会直接往下执行，它不会阻塞当前线程。
 2. NSOperation和NSOperationQueue
 
 NSOperation 是苹果公司对 GCD 的封装，完全面向对象，所以使用起来更好理解。 大家可以看到 NSOperation 和 NSOperationQueue 分别对应 GCD 的 任务 和 队列
 2.1
 将要执行的任务封装到一个 NSOperation 对象中。
 将此任务添加到一个 NSOperationQueue 对象中。

 
 
 */


/**  *****************************   项目其他东西 *******************************
 1. 大部分更改语言设置的建议都是在info.plist文件(即项目的info选项)中设置Localization native development region的字段
 该字段默认为en即英文，改为china即可将该app内的软件设为中文；然而，有些app无效……网上很多地方也没有解答和说明，找了很久终于发现，还要在项目的PROJECT -> Info -> Localizations中添加语言包才可以。
 
 
 
 */


/* *****************************  初级的总结 *******************************
 1. 不同于 C 和 Objective-C，Swift 中是可以对浮点数进行取余。
 
 2.  Swift 也提供恒等 === 和不恒等 !== 这两个比较符来判断两个对象是否引用同一个对象实例。即特征相等运算符
 
 3.  逻辑非（ !a ）  逻辑与（ a && b ）  逻辑或（ a || b ）
 
 4. 特殊的转义字符  \0 (空字符)、\\(反斜线)、\t (水平制表符)、\n (换行符)、\r (回车符)、\" (双引号)、\' (单引号)。
 单字节  Unicode 标量，写成  \xnn，其中  nn 为两位十六进制数。
 双字节  Unicode 标量，写成  \unnnn，其中  nnnn 为四位十六进制数。
 四字节  Unicode 标量，写成  \Unnnnnnnn，其中  nnnnnnnn 为八位十六进制数。
 
 5.  字符串的函数isEmpty, , , , , ,   字符串不是指针，而是实际的值
 
 6. 在后台，Swift 编译器会对字符的使用进行优化，只有在绝对必要的情况下才进行实际的值拷贝操作。这意味着你始终可以将字符串作为值类型的同时获得极高的性能 】
 
 7.  Swift 中的数组索引总是从零开始。
 
 8. 使用数组的 insert (atIndex:) 方法在 atIndex 之前添加元素： shoppingList.insert("Maple Syrup", atIndex: 0)===============使用 removeAtIndex 方法来移除数组中的某一项==========如果只想把数组中的最后一项移除，使用 removeLast 方法==========使用恒等运算符(identity operators)( === and !==)来判定两个数组或子数组共用相同的储存空间或元素。
 
 9. 数组还提供了创建特定大小并且元素被同时初始化的构造器。把数组的元素数量（count）和初始值（repeatedValue）传入数组即可：
 var threeDoubles = Double[](count: 3, repeatedValue: 0.0)
 // threeDoubles is of type Double[], and equals [0.0, 0.0, 0.0]  .......因为类型推断，使用这种构造器的时候不需要指定数组中存储的数据类型 ：
 var anotherThreeDoubles = Array(count: 3, repeatedValue: 2.5)
 // anotherThreeDoubles is inferred as Double[], and equals [2.5, 2.5, 2.5]
 
 10.  使用加法操作符（+）来合并两种相同类型的数组：前加后
 
 11.  可哈希的：简单的说就是不可变
 
 12. 使用下标语法来添加新的元素。使用 key 作为下标索引，并且分配新的值：//
 字典的 updateValue(forKey:) 方法可以添加或者更新 forKey 对应的值。如上面的示例，updateValue(forKey:) 方法在 forKey 不存在对应值的时候增加值，存在的时候更新对应已存在的值。// 通过使用下标语法给某个键对应的值赋值为 nil ，来从字典里移除一个键值对
 
 13. 你也可以通过获取关键字-值对来迭代字典中的数据，当迭代字典中的数据时，字典中的每一项将以(关键字-值)元组作为返回值。你可以在for-in循环体中用显示命名常数来分解(关键字-值)元组的数据以供使用，在此种情况下，字典的关键字被分解为animalName，同时字典的值被分解为常量legCount：
 let numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
 for (animalName, legCount) in numberOfLegs {
    println("\(animalName)s have \(legCount) legs")
 }
 

 迭代字典中的数据项不能保证它们被检索时的顺序，关于数组和字典的更多内容，请阅集合类型那一部分。
 除了数组和字典外，你也可以使用for-in循环去迭代字符串中的字符值：
 for character in "Hello" {
 println(character)
 }
 // H
 // e
 // l
 // l
 // o
 
 
 14. 如果你确实需要 C 风格的贯穿（fallthrough）的特性，你可以在每个需要该特性的 case 分支中使用fallthrough关键字。即执行本case后的语句后继续执行下一个case语句\default语句
 
 15.  你可以通过标记final关键词来禁止重写一个类的方法，属性或者下标。在定义的关键词前面标注@final属性即可。
 
 16. 无论何时将一个字典实例赋给一个常量或变量，或者传递给一个函数或方法，这个字典会即会在赋值或调用发生时被拷贝。(如果字典实例中所储存的键(keys)和/或值(values)是值类型(结构体或枚举)，当赋值或调用发生时，它们都会被拷贝。相反，如果键(keys)和/或值(values)是引用类型，被拷贝的将会是引用，而不是被它们引用的类实例或函数。字典的键和值的拷贝行为与结构体所储存的属性的拷贝行为相同。)
 
 17. 当你确定可选包含值之后，你可以在可选的名字后面加一个!来获取值。这个惊叹号表示“我知道这个可选有值，请使用它。”这被称为可选值的强制解析 （注意：使用!来获取一个不存在的可选值会导致运行时错误。。使用!来强制解析值之前，一定要确定可选包含一个非nil的值。）
 
 18. 这种类型的可选被定义为隐式解析可选。把后缀?改成!来声明一个隐式解析可选，比如String!。
 
 
 19. 属性将值跟特定的类、结构或枚举关联。存储属性存储常量或变量作为实例的一部分，计算属性计算（而不是存储）一个值。计算属性可以用于类、结构体和枚举里，存储属性只能用于类和结构体。 (注意：必须使用var关键字定义计算属性，包括只读计算属性，因为他们的值不是固定的。let关键字只用来声明常量属性，表示初始化后再也无法修改的值。)
 
 20. let vga = resolution（width:640, heigth: 480）// 逐一初始化
 与结构体不同，类实例没有默认的成员逐一初始化器。构造过程章节会对初始化器进行更详细的讨论。
 
 * 21. 实际上，在 Swift 中，所有的基本类型：整数(Integer)、浮点数(floating-point)、布尔值(Booleans)、字符串(string)、数组(array)和字典(dictionaries)，都是值类型，并且都是以结构体的形式在后台所实现；  （因此，结构体实例与枚举总是通过值传递，类实例总是通过引用传递。）  【所有的结构体和枚举都是值类型；类是引用类型 与值类型不同，引用类型在被赋予到一个变量，常量或者被传递到一个函数时，操作的并不是其拷贝。因此，引用的是已存在的实例本身而不是其拷贝。】
 
 22. 因为Swift中的类型名（如Int、String和Double）以大写字母开头，所以协议类型的名称也以大写字母开头
 
 23.  整型字面量（integer literals）表示未指定精度整型数的值。整型字面量默认用十进制表示，可以加前缀来指定其他的进制，二进制字面量加 0b，八进制字面量加 0o，十六进制字面量加 0x。
 
 24. 为了避免循环引用，不要将 Swift 代码导入到 Objective-C 头文件中. 但是你可以在 Objective-C 头文件中前向声明（forward declare）一个 Swift 类来使用它，然而，注意不能在 Objective-C 中继承一个 Swift 类。
 25 . 选项形式（as?）的操作执行转换并返回期望类型的一个选项值，如果转换成功则返回的选项包含有效值，否则选项值为 nil .   强制形式（as ）的操作执行一个实例到目的类型的强制转换，因此使用该形式可能触发一个运行时错误。
 
 */


