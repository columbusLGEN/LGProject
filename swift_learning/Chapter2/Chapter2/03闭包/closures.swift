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
        
//        2. 尾随闭包
        
//        3. 值捕获
        
//        4. 闭包是引用类型
        
//        5. 逃逸闭包
        
//        6. 自动闭包
        
    }
    
    func backword(_ s1: String, _ s2: String) -> Bool {
        return s1 > s2
    }
    
    
}
