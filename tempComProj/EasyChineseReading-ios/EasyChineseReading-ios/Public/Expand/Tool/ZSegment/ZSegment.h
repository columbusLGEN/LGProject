//
//  ZSegment.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/6.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseView.h"

@interface ZSegment : ECRBaseView

@property (copy, nonatomic) void(^ selectedRight)();
@property (copy, nonatomic) void(^ selectedLeft)();

/**
 调用主题颜色的初始化
 */
- (instancetype)initWithFrame:(CGRect)frame leftTitle:(NSString *)lt rightTitle:(NSString *)rt;
- (instancetype)initWithFrame:(CGRect)frame leftTitle:(NSString *)lt rightTitle:(NSString *)rt selectedIndex:(NSInteger)selectedIndex;
- (instancetype)initWithFrame:(CGRect)frame leftTitle:(NSString *)lt rightTitle:(NSString *)rt selectedColor:(UIColor *)selectedColor sliderColor:(UIColor *)sliderColor;
- (instancetype)initWithFrame:(CGRect)frame leftTitle:(NSString *)lt rightTitle:(NSString *)rt selectedColor:(UIColor *)selectedColor sliderColor:(UIColor *)sliderColor verLineColor:(UIColor *)verLineColor diamondColor:(UIColor *)diamondColor;
/**
 初始化 ZSegment
 
 @param frame         frame
 @param lt            左侧标题
 @param rt            右侧标题
 @param selectedColor 选中颜色
 @param sliderColor   滑块颜色
 @param verLineColor  竖线颜色
 @param diamondColor  选中的色块颜色
 @param selectedIndex 选中的模块
 @return segment
 */
- (instancetype)initWithFrame:(CGRect)frame leftTitle:(NSString *)lt rightTitle:(NSString *)rt selectedColor:(UIColor *)selectedColor sliderColor:(UIColor *)sliderColor verLineColor:(UIColor *)verLineColor diamondColor:(UIColor *)diamondColor selectedIndex:(NSInteger)selectedIndex;

@end
