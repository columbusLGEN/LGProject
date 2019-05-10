//
//  TCErrorViewController.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/9.
//  Copyright © 2019 lee. All rights reserved.
//

#import "LGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class TCErrorViewController;

@protocol TCErrorViewControllerDelegate <NSObject>

@optional
- (void)errorvcRealodData:(TCErrorViewController *)errorvc;

@end

@interface TCErrorViewController : LGBaseViewController

/** type 0: 网络异常;1: 没有搜到结果 */
+ (instancetype)errorvcWithType:(NSInteger)type delegate:(id<TCErrorViewControllerDelegate>)delegate noticeText:(NSString *)noticeText;

@property (weak,nonatomic) id<TCErrorViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
