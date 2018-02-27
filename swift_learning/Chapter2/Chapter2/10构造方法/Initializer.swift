//
//  Initializer.swift
//  Chapter2
//
//  Created by Peanut Lee on 2018/1/30.
//  Copyright © 2018年 LG. All rights reserved.
//

import Foundation
import UIKit

class Initializer: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange
        /// 构造过程
        /// Swift的构造器无需返回值，他们的任务是保证实例在第一次使用前完成正确的初始化
        
        /// 1.存储属性的初始赋值.
        /// * 类和结构体在创建实例时，必须为所有存储型属性设置合适的初始值。并且它们的值是直接被设置的，不会触发任何属性观察者
        
        /// 2.类的构造器代理规则
        /// 规则1 * 指定构造器必须调用其直接父类的指定构造器
        /// 规则2 * 便利构造器必须调用同类中定义的其他构造器
        /// 规则3 * 便利构造器必须最终导致一个指定构造器被调用
            /// 指定构造器必须总是向上代理
            /// 便利构造器必须总是横向代理
        
        /// * 子类不能直接调用父类的便利构造器
        /// * 子类可以修改继承来的变量属性，但是不能修改继承来的常量属性
        
//        let apple = Food()
//        print(apple.name)
//
//        let banana = Food(name: "香蕉")
//        print(banana.name)
        
//        var breakfast = [
//            ShoppingListItem(),
//            ShoppingListItem(name: "肉夹馍"),
//            ShoppingListItem(name: "鸡蛋", quantity: 2)
//        ]
//        breakfast[0].name = "豆浆"
//        breakfast[0].purchased = true
//
//        for item in breakfast {
//            print(item.description)
//        }
        
        /// 可失败构造器 --
        /// 构造器不支持返回值。只是用return nil 表明可失败构造器构造失败，而不需要用return来表明构造成功
        
//        let a = ""
        let arr = [2,3]
//        UnsafePointer(arr)
//        UnsafePointer(a) /// 编译报错
        print("\(UnsafePointer(arr))")
//        print("\(UnsafePointer(a))")
//        print(a+"a")
//        print("a")
        
        /// 必要构造器
        /// 如果子类继承的构造器能满足必要构造器的要求，则无需再子类中显示提供必要构造器的实现。？
        
        /// 通过闭包或函数提供属性的默认值
        /// 闭包
        let someProperty: String = {
            return "我是someProperty的默认值"
        }()/// () 用来告诉Swift立即执行该闭包，并返回临时值给 someProperty
        
//        let someProperty: String = {
//            return "我是someProperty的默认值"
//        }/// 这种写法是将 闭包赋值给 someProperty
        
        
    }
}

class Food{
    var name: String
    
    /// Food 指定构造器
    init(name: String) {
        self.name = name
    }
    
    /// Food 便利构造器
    convenience init (){
        self.init(name: "[Unnamed]")
    }
    
}

class RecipeIngredient: Food {
    var quantity: Int
    
    /// RecipeIngredient 指定构造器
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    /// RecipeIngredient 便利构造器
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}

class ShoppingListItem: RecipeIngredient {
    var purchased = false
    var description: String{
        var output = "\(quantity) x \(name)"
        output += purchased ? " ?" : " ?"
        return output
    }

}






