//
//  EDJHomeController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJHomeController.h"
#import "LIGBaseViewController.h"

@interface EDJHomeController ()

/** 控制器 class name 数组 */
@property (strong,nonatomic) NSArray *classNames;
/** 控制器数组 */
@property (strong,nonatomic) NSMutableArray *controllers;

@end

@implementation EDJHomeController


- (instancetype)init{
    
    if (self = [super init]) {
        /// 微党课 EDJMicroPartyLessionViewController
        /// 党建要闻 EDJPartyBuildViewController
        /// 数字阅读 EDJDigitalReadViewController
        
        /// 初始化 类名数组,如果需要增加,创建好相应的控制器类之后,将类名添加到该数组中即可
        _classNames = @[@"EDJMicroPartyLessionViewController",
                        @"EDJPartyBuildViewController",
                        @"EDJDigitalReadViewController"];
        _controllers = [NSMutableArray array];
    }
    
    return self;
}


/**
 获取控制器

 @param index 索引
 @param className 类名
 @return 控制器
 */
- (UIViewController *)viewControllerWithIndex:(NSInteger)index className:(NSString *)className {
    /// 如果控制器数组中已经存在该控制器,则不创建新的控制器
    if ((_controllers.count != 0)
        && (index < _controllers.count)
        && (_controllers[index] != nil)) {
        return _controllers[index];
    }
    /// 否则,创建新的控制器
    /// index 获取数据
    /// className 控制器标识
    LIGBaseViewController *vc = nil;
    if (className == nil) {/// 如果为空,建立微党课控制器
        className = @"EDJMicroPartyLessionViewController";
    }
    vc = [[NSClassFromString(className) alloc] viewControllerWithData:nil];
    [_controllers addObject:vc];
//    NSLog(@"incex: %ld, count: %ld, 创建新的vc: %@",index,_controllers.count,vc);
    return vc;
}

/**
 获取控制器索引

 @param viewController 控制器
 @return 索引
 */
- (NSInteger)indexOfViewController:(UIViewController *)viewController{
    return [self.classNames indexOfObject:NSStringFromClass([viewController class])];
}

/// MARK: 动作:last
#pragma mark - page view controller data source
- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    
    /// 获取当前索引
    NSInteger index = [self indexOfViewController:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    /// 计算即将要显示的索引
        index--;
    
    /// 根据索引获取将要显示的控制器
    UIViewController *vc = [self viewControllerWithIndex:index className:self.classNames[index]];
    
    return vc;
}

/// MARK: 动作:next
- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController {
    
    /// 获取当前索引
    NSInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    /// 计算即将要显示的索引
    index++;
    if (index >= self.classNames.count) {
        return nil;
    }
    
    /// 根据索引获取将要显示的控制器
    
    UIViewController *vc = [self viewControllerWithIndex:index className:self.classNames[index]];
    return vc;
}

@end
