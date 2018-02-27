//
//  Properties.swift
//  Chapter2
//
//  Created by Peanut Lee on 2018/1/29.
//  Copyright © 2018年 LG. All rights reserved.
//

import Foundation

/// 全局计算型变量
var price_whole = 3{
    didSet{
        if price_whole > oldValue{
            print(price_whole)
        }else{
            print("全局变量didset 新值小于旧值")
        }
    }
}

class Properties: ViewController {
    
    /// 类型属性
    class var test: Int{
        return 0
    }
    /// 类型属性
    static var test0: Int = 2
    
    /// 计算型属性
    var price = 5{
        didSet{
            if price > oldValue{
                print("price \(price)")
            }else{
                print("新值小于旧值 ")
            }
        }
    }
    
    override func viewDidLoad() {
        
//        let vc = Properties()
//        vc.price = 10
//        print("实例属性值 \(vc.price)")
        print("类型属性 \(Properties.test)")
        print("类型属性2 \(Properties.test0)")
        
        /// 局部计算型变量
        var price_part = 1{
            didSet{
                print("局部计算型变量 \(price_part),oldVlue \(oldValue)")
            }
        }
        
        
        /*
         属性
             1. 存储属性
             2. 计算属性
             3. 属性观察器
             4. 全局变量和局部变量
             5. 类型属性
         */
        
        /// 1.存储属性
        
        self.price = 2
//        price_whole = 1
//        price_part = 3
        
    }
    
}
