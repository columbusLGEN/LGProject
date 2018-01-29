//
//  UIViewController+storyBoard.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/29.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController(storyBoard)

+ (instancetype)loadFromStoryBoard:(NSString *)storyBoard;
+ (instancetype)loadInitialViewControllerFromStoryBoard:(NSString *)storyBoard;

- (void)pushToViewControllerWithStoryBoard:(NSString *)storyBoard;
- (void)pushToViewControllerWithStoryBoard:(NSString *)storyBoard withStoryBoardId:(NSString *)storyboardID;
//- (void)pushToViewControllerWithStoryBoard:(NSString *)storyBoard withStoryBoardId:(NSString *)storyboardID hideBottomBar:(BOOL)hide;

@end
