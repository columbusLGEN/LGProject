//
//  ECRSwichView.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

/**
 需要增加的功能:
    segment 滑动
    
 */

@interface LGSegmentControlModel: NSObject
@property (copy,nonatomic) NSString *imageName;
@property (copy,nonatomic) NSString *title;
@end

#import <UIKit/UIKit.h>
@class LGSegmentControl;
@protocol LGSegmentControlDelegate;

@interface LGSegmentControl : UIView

- (instancetype)initWithFrame:(CGRect)frame models:(NSArray<LGSegmentControlModel *> *)models;

@property (weak,nonatomic) id<LGSegmentControlDelegate> delegate;
@property (strong,nonatomic,readonly) NSArray<LGSegmentControlModel *> *models;

- (void)elfAnimateWithIndex:(NSInteger)index;

/** 动画横条颜色,默认黑色 */
@property (strong,nonatomic) UIColor *elfColor;
/** 字号,默认12 */
@property (assign,nonatomic) NSInteger textFont;

@end

@protocol LGSegmentControlDelegate <NSObject>

/**
 点击回调
 
 @param sender view
 @param click 左起 0 开始
 */
- (void)segmentControl:(LGSegmentControl *)sender didClick:(NSInteger)click;

@end
