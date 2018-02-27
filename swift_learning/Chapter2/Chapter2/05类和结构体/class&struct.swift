//
//  class&struct.swift
//  Chapter2
//
//  Created by Peanut Lee on 2018/1/29.
//  Copyright © 2018年 LG. All rights reserved.
//

import Foundation

class StudyClassStruct: ViewController {
    
    override func viewDidLoad() {
        
        /*
         9.类和结构体
         a. 类和结构体对比
             i. 既然结构体和类非常类型，且类具有更多结构体不具备的特点，那么在编码过程中都使用类就好了，为什么有些地方还要使用结构体？
             ii. 与OC不同，Swift 允许直接设置结构体属性的子属性
             iii. 结构体有一个自动生成的成员逐一构造器，SomeStruct(member1: value, member2: value ), 而类实例没有默认的成员逐一构造器
             iv. 结构体和枚举是值类型，类是引用类型。值类型被赋予一个变量，常量或者被传递给一个函数的时候，其值会被拷贝
             v. 在Swift中，所有的基本类型：整数，浮点数，布尔值，字符串，数组和字典都是值类型，并且底层都是以结构体的形式实现
         b. 结构体和枚举是值类型
         c. 类是引用类型
             i. 引用类型在被赋予到一个变量，常量或者被传递到一个函数时，其值不会被拷贝。
             ii. === ( 等价于 ) --> 表示两个类型的常量或变量引用同一个类实例，而( == 等于)表示两个实例的值相等或相同
             iii. !== ( 不等价于 )
         d. 类和结构体的选择
             i. 按照通用规则，当符合以下一条或者多条时，选择结构体
                 1. 该数据结构的主要目的是用来封装少量相关简单的数据值
                 2. 有理由预计该数据结构的实例在被赋值或者传递时，封装的数据将会被拷贝而不是被引用
                 3. 该数据结构中存储的值类型属性，也应该被拷贝，而不是引用
                 4. 该数据结构不需要去集成另一个既有类型的属性或者行为
             ii. 举例来说，一下情景适合使用结构体：
                 1. 几何形状的大小, 封装一个 width 和 height 属性, Double类型
                 2. 一定范围内的路径，封装一个 start 和 length 属性. Int 类型
                 3. 三维坐标系内一点，封装 x y z属性, 三者均为 Double类型
             iii. 在所有其他案例中，定义类，去生成它的实例。这意味着，绝大部分自定义数据结构都应该是类
         e. 字符串，数组，和字典类型的赋值与复制行为
             i. Swift 中，基本类型，注入 String, Array Dictionary 类型均以结构体的形式出现。这意味着被赋值给新的常量，或者被传入函数或者方法是，它们的值会被拷贝
             ii. 在OC中，NSString, NSArray, NSDictionary 类型均已类的形式出现，并非结构体。它们在被赋值或者被传入函数或方法时，不会发生值拷贝，而是传递现有实例的引用
         */
        
        /// 打印内存地址：
        /// 值: 调用 UnsafePointer 函数，传入值
        /// 对象：直接打印对象引用即可
//        let vc = StudyClassStruct()
//        print(vc)
        
        let arr0 = [1,2]
        
        var arr1 = [3,4]
//        print("arr1: \(UnsafePointer(arr1)) 赋值前")
        arr1 = arr0
        print("arr0: \(UnsafePointer(arr0))")// arr0: 0x0000600000252200
        print("arr1: \(UnsafePointer(arr1))")// arr1: 0x0000600000252200
        
        arr1[0] = 9
        print("arr0: \(UnsafePointer(arr0))")// arr0: 0x0000600000252200
        print("arr1: \(UnsafePointer(arr1))")// arr1: 0x00006000002524a0
        // * 以上打印结果证明，如果不修改赋值后新数组的值，则新数组和原数组在内存中占同一个存储空间，否则新建空间存储新的数组
        // * 这就证实了 Swift 管理所有的值拷贝以确保性能最优化，只在绝对必要的时候才执行实际的拷贝
        
        /// 打印结果证明了，数组在赋值时，值被拷贝了
        print(arr0)// [1, 2]
        print(arr1)// [9, 2]
    }
    
}
