//
//  closures.swift
//  Chapter2
//
//  Created by Peanut Lee on 2018/1/25.
//  Copyright © 2018年 LG. All rights reserved.
//

import Foundation
import UIKit

class closures: ViewController {
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        // ？（中文问号）表示此处存疑
        
        // 0. 闭包
        // 0.1 全局函数和嵌套函数实际上是特殊的闭包
            // * 全局函数 是一个（有名字）但（不会捕获任何值的）闭包
            // * 嵌套函数 是一个 （有名字）并可以（捕获其封闭函数域内值？）的闭包
            // * 闭包表达式 是一个 利用轻量级语法所写的可以 捕获？其上下文中变量或常量值的（匿名闭包）
        
        // 0.2 swift闭包表达式 拥有简介的代码格式，并鼓励在常见场景中进行语法优化，主要优化如下:
            // * 利用上下文推断参数和返回值类型？
            // * 银式返回（单表达式闭包？），即单表达式闭包可以省略 return 关键字
            // * 参数名称所写？
            // * 尾随闭包语法
        
//        1. 闭包表达式
        let arr = ["Goodman","Willson","Amanda","Zonbine"]
        print(arr.sorted(by: backword))
        print(arr.sorted())
        
        // 闭包表达式
//        {(参数) -> 返回值 in
//            语句
//        }
        print(arr.sorted(by: {(s1: String, s2: String) -> Bool in
            return s1 > s2
        }))
        // 1.1 根据上下文推断类型 -- 省略表达式的写法
        print(arr.sorted(by: { s1,s2 in return s1 > s2 }))
        
        // 1.2 单表达式闭包隐式返回
        print(arr.sorted(by: { s1,s2 in s1 > s2 }))
        
        // 1.3 参数名称缩写 -- Swift 自动为（内联闭包）提供了参数名称缩写功能，你可以直接通过 $0 ， $1 ， $2 来顺序调用闭包的参数，以此类推
        // * 注意：内联闭包
        print(arr.sorted(by: { $0 > $1 }))
        // 1.4 运算符方法
        // * swift 的 String 类型定义了关于 大于号 > 的 字符串实现，其作为一个函数可以接受两个String类型的参数并返回Bool类型的值
        // * 这正好与 sorted(by: <#T##(String, String) throws -> Bool#>) 参数需要的函数类型相符合。因此可直接传入 > ，swift 可以自动推断出你想使用大于号的字符串函数实现
        print(arr.sorted(by: >))
        
//        2. 尾随闭包
        // * 如果需要将一个很长的闭包作为最后一个参数传递给函数，可以使用尾随闭包来增强函数的可读性
        // * 尾随闭包，不需要参数标签
        
        
        /// 尾随闭包测试函数
        ///
        /// - Parameter param1: 闭包参数
        /// closure:    参数标签
        /// param1:     参数名称
        /// () -> Void: 参数类型
        func closureTest0(closure param1: () -> Void){

        }
//        closureTest0 {
//            <#code#>
//        }
        
        let time: TimeInterval = 0
        
        func closureTest1(userid param1: Int, success param2: (NSObject) -> Void,failure param3: @escaping (NSError,String) -> Void){
            
            param2(NSObject())
            let error = NSError(domain: "错误测试", code: 400, userInfo: nil)
            
            // 延时调用的闭包 需要 用 关键字 @escaping 修饰，定义其 为逃逸闭包
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
//                param3(error, "错误msg")
//            }
            param3(error, "错误msg")
        }
        
        closureTest1(userid: 9, success: { (obj) in
            print(obj)
        }) { (error, msg) in
            print(error,msg)
        }
        
//        3. 值捕获
        // * 闭包可在其被定义的上下文中 捕获 常量或变量
        
//        4. 闭包是引用类型
        // * 当把一个闭包赋值给一个常量或者变量时，只是将该闭包的引用赋值，并不是将闭包内容本身赋值
        
//        5. 逃逸闭包 --> 使用 关键字 @escaping 修饰
        
//        6. 自动闭包
        var customInLine = ["Alex","Marry","Tony"]

        // 闭包表达式
//        { (parameters) -> returnType in
//            statements
//        }
        
        let customProvider = { customInLine.remove(at: 0) }// 这是一个闭包
        
        print(customProvider())// 调用闭包
        
        print(customInLine)
    }
    
    func backword(_ s1: String, _ s2: String) -> Bool {
        return s1 > s2
    }
    
    
}
