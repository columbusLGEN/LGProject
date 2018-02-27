//
//  Methods.swift
//  Chapter2
//
//  Created by Peanut Lee on 2018/1/30.
//  Copyright © 2018年 LG. All rights reserved.
//

import Foundation

/// 可变实例方法举例：三态开关
enum TriStateSwitch {
    case Off,Low,High
    mutating func next(){
        switch self {
        case .Off:
            self = .Low
        case .Low:
            self = .High
        case .High:
            self = .Off
        }
    }
}

class Methods: ViewController {
    
    class func canBeOverrided(){
        print("这是一个类型方法")
    }
    static func cannotBeOverried(){
        print("这是一个类型方法 static")
    }
    
    override func viewDidLoad() {
        
        Methods.canBeOverrided()
        Methods.cannotBeOverried()
        
        /// 0.方法
        /// * 方法是与某些特定类型相关联的函数.
        /// * 结构体 和 枚举 能够定义方法是Swift C/OC 的主要区别之一
        
        /// 1.实例方法
        /// * 实例方法是属于某个特定类，结构体，枚举实例的方法.
        /// * 当 实例的属性名 与 函数的某个参数名 相同时，在函数内部，如果不指定self，Swift认为是指函数的参数
        
        /// * 在实例方法中修改值类型 mutating. 默认情况下，值类型的属性不能在它的实例方法中被修改。但是，如果需要在某个特定方法中修改结构体或者枚举的属性，可以为这个方法选择可变(mutating)行为, 然后就可以在他的方法内部改变它的属性
        
        /// * 枚举的可变方法可以把self 设置为同一枚举类型中不同的成员
        var currentState = TriStateSwitch.High
        currentState.next()/// 在可变方法中，给self 赋值
        currentState.next()
        print(currentState)
        
        /// 2.类型方法（类似OC的类方法）
        /// * 可以在func 加上 static 修饰，来指定类型方法
        /// * 类还可以用 class 关键字来允许子类重写父类的方法实现
        /// * 在OC中，只能为类类型添加类方法。在Swift中，可以为所有的类，结构体，枚举定义类型方法。每一个类型方法都被它所支持的类型显示包含
        
    }
    
}


class SonOfMethods: Methods {
    
//    override func testCanBeOverrided (){
//        print("重写父类的方法 testCanBeOverrided ")
//    }
    
    
    
    override func viewDidLoad() {
        
    }
    
}

