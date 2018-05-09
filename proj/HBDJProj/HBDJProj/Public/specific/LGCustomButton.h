//
//  ECRBiCustomButton.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/20.
//  Copyright © 2017年 retech. All rights reserved.
//

// 详情页面底部自定义按钮
/// UI结构：上imageView 下文字

#import <UIKit/UIKit.h>

@interface LGCustomButton : UIView

@property (strong,nonatomic) UIImageView *img;
@property (strong,nonatomic) UILabel *label;

/// 初始化
- (void)setupWithImgName:(NSString *)imgName labelText:(NSString *)labelText labelTextColor:(NSString *)labelTextColor;

/// button
- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)modifyTextColorWithColorString:(NSString *)colorString iconName:(NSString *)iconName;


@property (weak,nonatomic) NSString *bgColorStr;
@property (strong,nonatomic) UIButton *button;
@property (assign,nonatomic) NSInteger index;


@end
