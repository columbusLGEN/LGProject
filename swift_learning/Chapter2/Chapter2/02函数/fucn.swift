//
//  ViewController.swift
//  Charpter2_function
//
//  Created by Peanut Lee on 2018/1/25.
//  Copyright © 2018年 LG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.函数的定义与调用
        test()
        
        // 2.函数的参数与返回值
        let test1_back_value = test1(param1: 1)
        print("test1_back_value: \(test1_back_value)")
        // 函数的返回值可以忽略，使用 _
        let _ = test1(param1: 1)// 打印结果: 5
        
        // 2.1 没有返回值
        test2(param1: 2)
        
        // 2.2 多重返回值
        let arr = [2,6,23,8,4,50]
        var tuple = (0,0)
        tuple = test3(array: arr)
        print(tuple)
        
        // 3.函数参数标签 和 参数名称
        let sum = test4(firstParam: 5, secondParam: 6)
        print("函数参数标签,sum = \(sum)")
        
//        test5(<#T##param1: Int##Int#>)
        test5(9)// 调用 忽略参数标签 的函数
        test5(param1: 9)// 调用普通的带有参数的函数
        
        // 3.1 test6 的 参数 有默认值
        let test6_back_value = test6()
        print(test6_back_value)
        
        // 3.2 可变参数
        // func test7(_ param: Int...) -> Int
        // 一个函数最多只能有一个可变参数
        print(test7(7,2,1,3,5))
        
        // 3.3 输入输出参数
        // 函数参数默认是常量。
        // 被 关键字：inout 修饰的参数 可以在函数内部修改
        var test8_param = 1
        test8(&test8_param)
        
        // 4.函数类型
        // * 每一个函数都有 函数类型，函数类型由参数的个数以及类型和返回值类型 组成
        // * 例如：fucn test(param: Int, param2: Int) -> Int {}的类型是 (Int,Int) -> Int
        // * 在 Swift 中，使用函数类型就像使用其他类型一样。例如，可以定义一个类型为 函数 的常量/变量，并将适当
        //   的函数赋值给它
        // * 函数类型 可以 作为 参数类型 以及 返回类型
        
        // 5.嵌套函数
        // * 目前为止，所有的函数都叫 全局函数
        // * 也可以把函数定义在别的函数内部，陈祚 嵌套函数
        
        test9()
    }

    // 1.
    func test() {
        print("最简单的函数，没有参数，没有返回值")
    }
    
    // 2.
    func test1(param1: Int) -> Int {
        print("参数param1：\(param1)")
        return param1
    }
    // 2.1
    func test2(param1: Int) -> Void {
        print("参数：\(param1)" + "本函数没有返回值")
    }
    // 2.2 多重返回值
    func test3(array: [Int]) -> (min: Int, max: Int) {
        var min = array[0]
        var max = array[0]
        
        for num in array[1..<array.count]{
            // 因为已经取了数组中的第一个值，所以循环从 1开始
            print(num)
            if num < min {
                min = num
            }else if num > max{
                max = num
            }
        }
        
        return (min, max)
    }
    // 3.函数参数标签 和 参数名称
    func test4(firstParam param1: Int, secondParam param2: Int) -> Int {
        return param1 + param2
    }
    // 忽略参数标签
    func test5(_ param1: Int){
        print("忽略参数标签 \(param1)")
    }
    func test5(param1: Int){
        print("没有参数标签 \(param1)")
    }
    func test6(_ param1: Int = 6) -> Int {
        return param1
    }
    
    // 3.2 可变参数
    func test7(_ param: Int...) -> Int {
        var sum = 0
        
        for num in param {
            sum += num
            print(num)
        }
        return sum
    }
    // 3.3 输入输出参数
    func test8(_ param: inout Int) {
        param = 5
        print(param)
    }
    
    // 5.嵌套函数
    func test9() {
        func nestFunc1(){
            print("嵌套函数")
        }
        
        nestFunc1()
        
    }

}

