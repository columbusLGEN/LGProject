//
//  Destruct.swift
//  Chapter2
//
//  Created by Peanut Lee on 2018/2/1.
//  Copyright © 2018年 LG. All rights reserved.
//

import Foundation

class Destruct: ViewController {
    
    override func viewDidLoad() {
    
        /// 自动引用计数
        
        /// 无主引用 & 弱引用
        
        /// 哪种情况用 若应用解除循环引用问题 ？哪种情况用 无主引用？
        /// * 弱引用举例: Person 和 Apartment
            /// 一个人可以拥有一个公寓，也可以不拥有
            /// 一个公寓可以有所有者，也可以没有
            /// 像这种两个属性都允许为nil的情况就使用弱引用
        
        /// * 无主引用举例: Customer 和 CreditCard
            ///  一个人可以拥有信用卡或者没有
            ///  但是一张引用卡必须要有持有者
            ///  这种一个属性允许为nil，而另一个属性不允许为nil的情况适合使用无主引用
        
        /// * 然而存在第三种场景: 两个属性都必须有值，并且初始化完成之后永不为nil，这种场景中，需要一个类使用无主属性，另一个类使用隐式解析可选属性
        
        /// 闭包引起的循环引用
        let manager = Person(name: "马云")
        let staff0 = Person(name: "年度最佳员工 - 小美")

        manager.dispatchTaskToStaff(staff: staff0, taskName: "买年货") { (status: Bool, info:
            String) in
//        manager.dispatchTaskToStaff(staff: staff0, taskName: "买年货") { [unowned staff0] (status: Bool, info: String) in  /// --> [unowned staff0] 定义捕获列表
            print(status,info)
            print(staff0.name)
            // 1.如果打印 staff0.name
                /**
                 结果:
                 任务完成
                 true 任务完成 年度最佳员工
                 销毁马云
                 结果表明：员工实例未销毁
                 */
            /// 这就是闭包的循环引用
            /// Person的实例 statff0 强引用 taskSuccess 闭包，taskSuccess 闭包内又引用了 statff0
            
            // 2.不打印 staff0.name
                /**
                 结果: 正常结果
                 任务完成
                 true 任务完成 年度最佳员工
                 销毁马云
                 销毁年度最佳员工
             
                 */
        }
        
        /// 定义捕获列表，解决 闭包的循环引用
        /// 如果被捕获的引用绝对不会变为nil， 应该用无主引用，而不是用弱引用
        
    }
    
    /// 析构方法
    deinit {
        print("析构方法")
    }
    
}

class Person: NSObject {
    typealias success = (Bool,String) -> Void

    /// 姓名
    var name: String
    /// 员工任务名
    var taskName: String?
    
    /// 构造器
    init(name: String) {
        self.name = name
    }
    /// 员工任务执行成功回调
    var taskSuccess: success?
    
    /// 经理分派任务函数
    func dispatchTaskToStaff(staff: Person, taskName: String, status: @escaping success) {
        staff.taskName = taskName
        staff.taskSuccess = status
        staff.performTask()
    }
    
    /// 员工执行任务函数
    func performTask() {
        print("任务完成")
//        self.taskSuccess(true, "任务完成")
        if let temp = self.taskSuccess {
        temp(true,"任务完成")
        }
    }
    
    /// 析构函数
    deinit {
        print("销毁" + self.name)
    }
}
