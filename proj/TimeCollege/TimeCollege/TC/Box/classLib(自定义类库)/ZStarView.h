//
//  ZStarView.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZStarView;

@protocol ZStarViewDelegate <NSObject>

-(void)starRatingView:(ZStarView *)view score:(CGFloat)score;

@end

@interface ZStarView : UIView

@property (assign, nonatomic, readonly) NSInteger numberOfStar;  // 星星的数量

@property (weak, nonatomic) id <ZStarViewDelegate> delegate;

@property (assign, nonatomic) BOOL canChange; // 是否改变

/**
 *  Init StarRatingView
 *
 *  @param frame  尺寸
 *  @param number 星星个数
 *
 *  @return StarRatingView
 */
- (id)initWithFrame:(CGRect)frame numberOfStar:(NSInteger)number;

/**
 *  设置控件分数
 *
 *  @param score     分数 0-numberOfStar之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(NSInteger)score withAnimation:(BOOL)isAnimate;

///**
// *  设置控件分数
// *
// *  @param score      分数，必须在 0 － 1 之间
// *  @param isAnimate  是否启用动画
// *  @param completion 动画完成block
// */
//- (void)setScore:(CGFloat)score withAnimation:(BOOL)isAnimate completion:(void (^)(BOOL finished))completion;

@end
