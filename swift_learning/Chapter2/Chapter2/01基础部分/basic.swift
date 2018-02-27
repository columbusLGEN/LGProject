//
//  ViewController.swift
//  Chapter2
//
//  Created by Peanut Lee on 2018/1/22.
//  Copyright © 2018年 LG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
  
        // 基本类型
//        Int
//        Double
//        Float
//        Bool
//        String
        // 基本集合类型
//        Array
//        Set
//        Dictionary
        // 高阶数据类型

//        元组(Tuple)
//        let http404Error = (404,"not found")
//        print(http404Error)
//
//        // 用_省略不想要的部分
//        let (justCode,_) = http404Error
//        print("\(justCode)")
//
//        let (_,justInfo) = http404Error
//        print("\(justInfo)")
//
//        // 根据下表取元组中的数据
//        print("\(http404Error.1)")
//        print("\(http404Error.0)")
//
//        // 给元组的元素命名
//        let http200 = (statusCode: 200, statusInfo: "success")
//        print(http200.statusCode)
//        print(http200.statusInfo)
        
        // 捕获异常,不入OC好用,还是我不会用?
//        do{
//            try makeHotDog()
//            print("一切正常")
//        } catch {
//            print("hotDog is nil")
//        }
        
        // 断言
//        let age = -3
//        assert(age > 0, "年龄应大于0")
        
        // 字符串
//        let characters: [Character] = ["a","b","c","w","k"]
//        let str = String(characters)
//        print(str)
        
//        let string0 = "\ni am"
//        let string1 = " kd"
//
//        var who = "who r u?"
//        who += string0
//        who += string1
//        print(who)
        
//        let three = 3
//        let threeIsThree = "\(three) is three"
//        print(threeIsThree)
        
//        let eAute: Character = "\u{E9}"
//        print(eAute)// é
//
//        let e: Character = "\u{65}"
//        print(e)// e
//        let e_: Character = "\u{301}"
//        print(e_)//
//
//        let combinedEAute: Character = "\u{65}\u{301}"
//        print(combinedEAute)// é
//        
//        let str = [eAute]
//        print(str.count)
        
//        let chineseStr = "一串中文"
//        let englishStr = "this"
//
//        print(chineseStr.characters.count)// 4
//        print(englishStr.characters.count)// 4
        
//        let test_str = "qwerty"
//        let start = test_str[test_str.startIndex]
//        print(start)
////        let end = test_str[test_str.endIndex]// 直接取 endIndex 导致程序崩溃
////        print(end)
//        let third = test_str[test_str.index(test_str.startIndex, offsetBy: 3)]// r
//        print(third)
//        let beforeEnd = test_str[test_str.index(before: test_str.endIndex)]// 正确的取字符串最后一个字符
//        print(beforeEnd)
        
//        var arr: [Any] = Array()
//        let arr1 = [1,2]
//        arr = arr1
//        print(arr)
        
//        var arr = ["www","baidu","com","http"]
//        print(arr)
//        arr[1...3] = ["iwiw","ssss"]
//        print(arr)
//        arr.insert("sss", at: 0)
//        print(arr)
        
//        for number in 1..<9{
//            print(number)
//        }
        
//        var a = 0
//        test: while a < 5 {
//            a += 1
//            if(a == 3) {continue test}
//            print(a)
//        }
        
//        let nacy = "objc"
//        var tony = ""
//
//        for letter in nacy {
//            switch letter{
//            case "b","j":
//                continue
//            default:
//                tony.append(letter)
//            }
//        }
//        print(tony)
        
//        if #available(iOS 5, *) {
//
//        }else{
//
//        }
//        test(firstArgument: "first")
//        test(param: "not label")
        
//        var param1 = 0
//        var param2 = 0
//
//        avalibleParamTest(param1: &param1, param2: &param2)
        
//        let testFunc: () -> Void = funcAssignmentTest
//
//        testFunc()
        
    }
    
//    func funcAssignmentTest(){
//        print("这是一个测试函数")
//    }
    
//    // 可变参数
//    func avalibleParamTest(param1: inout Int,param2: inout Int) {
//
//        param1 += 1
//        param1 += 10
//
//        let sum = param1 + param2
//
//
//        print(sum)
//    }
    
//    func thursday(time: String) {
//        
//    }
//    func thursday(time1: String) {
//        
//    }
    // ***参数名字是函数名的一部分
    
//    func test(firstArgument param: String) {
//
//    }
//    func test(param: String) {
//
//    }
    
//    func makeHotDog() throws{
//        let hotDog: String! = nil
//        let err = NSError()
//
//        if hotDog == nil {
//            throw err
//        }else{
//            print("makeHotDog")
//        }
//
//    }
    


}

