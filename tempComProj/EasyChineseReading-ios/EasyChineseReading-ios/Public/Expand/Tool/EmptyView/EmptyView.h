//
//  EmptyView.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/12.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyView : UIView

/* 空图标 */
@property (strong, nonatomic) UIImage *image;
/* 描述 */
@property (strong, nonatomic) NSString *strDesc;
/* 子描述 */
@property (strong, nonatomic) NSString *strSubDesc;

// 更新显示空数据
- (void)updateEmptyViewWithType:(ENUM_EmptyResultType)type Image:(UIImage *)image desc:(NSString *)desc subDesc:(NSString *)subDesc;

- (void)updateEmptyViewWithType:(ENUM_EmptyResultType)type Image:(UIImage *)image desc:(NSString *)desc subDesc:(NSString *)subDesc backgroundColor:(UIColor *)color;

//- (void)updateEmptyView;

@end
