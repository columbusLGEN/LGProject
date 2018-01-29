//
//  UIViewController+storyBoard.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/29.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UIViewController+storyBoard.h"

@implementation UIViewController(storyBoard)


#pragma mark - 加载 storyboard 中控制器

+ (instancetype)loadFromStoryBoard:(NSString *)storyBoard
{
    UIViewController * board = [[UIStoryboard storyboardWithName:storyBoard bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    return board;
}

+ (instancetype)loadInitialViewControllerFromStoryBoard:(NSString *)storyBoard
{
    UIViewController * board = [[UIStoryboard storyboardWithName:storyBoard bundle:nil] instantiateInitialViewController];
    return board;
}

#pragma mark - 推出 storyboard 中控制器

- (void)pushToViewControllerWithStoryBoard:(NSString *)storyBoard
{
    [self pushToViewControllerWithStoryBoard:storyBoard withStoryBoardId:nil];
//    [self pushToViewControllerWithStoryBoard:storyBoard withStoryBoardId:nil hideBottomBar:hide];
}

- (void)pushToViewControllerWithStoryBoard:(NSString *)storyBoard withStoryBoardId:(NSString *)storyboardID
//                             hideBottomBar:(BOOL)hide
{
    UIViewController *viewController;
    if (storyboardID == nil || storyboardID.length == 0 || [storyboardID isEqualToString:@""])
        viewController = [[UIStoryboard storyboardWithName:storyBoard bundle:nil] instantiateInitialViewController];
    else
        viewController = [[UIStoryboard storyboardWithName:storyBoard bundle:nil] instantiateViewControllerWithIdentifier:storyboardID];
    
//    if (hide) {
//        viewController.hidesBottomBarWhenPushed = hide;
//    }
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
