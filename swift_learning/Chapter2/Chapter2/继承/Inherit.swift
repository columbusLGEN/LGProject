//
//  Inherit.swift
//  Chapter2
//
//  Created by Peanut Lee on 2018/1/30.
//  Copyright © 2018年 LG. All rights reserved.
//

import Foundation

class Inheriet: ViewController {
    
    override func viewDidLoad() {
       
        /// Swift中的类并不是从一个通用的基类继承而来。
        
        /// * 注意：不可以为继承来的常量存储型属性 或 只读计算型属性添加属性观察器。这些属性的值是不可以被设定的，所以为他们提供willSet和didSet是不恰当的
        
        /// * 可以 使用 final 标记来防止 方法，属性，或下标被重写, 如果用final标记一个类，则这个类是不可以被继承的
        
    }
}


class LGBaseObject {
    
    
}
