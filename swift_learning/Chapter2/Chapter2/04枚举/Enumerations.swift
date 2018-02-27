//
//  Enumerations.swift
//  Chapter2
//
//  Created by Peanut Lee on 2018/1/26.
//  Copyright © 2018年 LG. All rights reserved.
//

enum BreakFast {
    case doujiang
    case doufunao
    case hundun
    case pidanzhou
}/// 枚举不会像C语言和OC那样赋默认值0123等，反而 成员本身的名字就是确定的值

/// 2.关联值
enum BreakFastCombo {
    case doujiang(String)
    case hundun(String)
    case pidanzhou(Int,Int,Int)
}

/// 3.原始值
enum SportType: Int {
    case basketBall = 1
    case soccer = 2
    case baseBall = 3
    case surfing = 4
}
enum Compass: String {
    case north = "北"
    case south = "南"
    case east = "东"
    case west = "西"
}

/// 4.递归枚举
enum ArithmeticExpression {
    // 相关值
    case Number(Int)
    // 递归枚举
    indirect case Addition(ArithmeticExpression, ArithmeticExpression)// 表示关联值为 ArithmeticExpression 枚举类型
    indirect case Multiplication(ArithmeticExpression, ArithmeticExpression)
    indirect case Division(ArithmeticExpression, ArithmeticExpression)
}

import Foundation

class enumerations: ViewController {
    
    override func viewDidLoad() {
        
//        /// 1.枚举语法
//        let zaocan = drinkWaht(caocanheshenm: BreakFast.doufunao)
//        print(zaocan)
//        var drink = BreakFast.hundun
//        drink = .pidanzhou
//        print(drink)
//
//        /// 2.关联值
//        let combo1 = BreakFastCombo.doujiang("油条")
//        let combo2 = BreakFastCombo.hundun("包子")
//        let combo3 = BreakFastCombo.pidanzhou(02, 2, 4)
//        breakFastCombo(combo1)
//        breakFastCombo(combo2)
//        breakFastCombo(combo3)
        
//        /// 3.原始值
//        print(Compass.north)// north
//        print(Compass.north.rawValue)// 北
//
//        let direction = "南"
//        if let someDir = Compass(rawValue: direction) {
//            switch someDir{
//            case .south:
//                print("\(direction) is \(Compass.south)")
//            default:
//                print("其他方向")
//            }
//        }else{
//            print("\(direction) is not a direction")
//        }
        
        /// 4.递归枚举
        /// 递归枚举有什么用？
        let five = ArithmeticExpression.Number(5)
        let four = ArithmeticExpression.Number(4)
        let sum = ArithmeticExpression.Addition(five, four)
        let product = ArithmeticExpression.Multiplication(sum, ArithmeticExpression.Number(2))
        let quotient = ArithmeticExpression.Division(five, four)
        
//        print(sum)/// Addition(Chapter2.ArithmeticExpression.Number(5), Chapter2.ArithmeticExpression.Number(4))
//        print(product)
//        print(quotient)
        
        print(evaluate(expression: sum))        // 9
        print(evaluate(expression: product))    // 18
        print(evaluate(expression: quotient))   // 1
        
        
    }
    /// 4.递归枚举
    func evaluate(expression: ArithmeticExpression) -> Int {
        switch expression {
        case .Number(let value):
            return value
        case .Addition(let left, let right):
            return evaluate(expression: left) + evaluate(expression: right)
        case .Multiplication(let left, let right):
            return evaluate(expression: left) * evaluate(expression: right)
        case .Division(let left, let right):
            return evaluate(expression: left) / evaluate(expression: right)
        }
    }
    
    /// 2.
    func breakFastCombo(_ combo: BreakFastCombo) {
        switch combo {
        case let .doujiang(sFood):
            print("豆浆\(sFood)")
        case let .hundun(sFood):
            print("混沌\(sFood)")
        case let .pidanzhou(num1,num2,num3):
            print("皮蛋粥\(num1,num2,num3)")
        }
    }
    
    /// 1.
    func drinkWaht(caocanheshenm drink: BreakFast) -> String {
        switch drink {
        case .doujiang:
            return "豆浆"
        case .doufunao:
            return "豆腐脑"
        case .hundun:
            return "混沌"
        case .pidanzhou:
            return "皮蛋粥"
        }
    }
    
}
