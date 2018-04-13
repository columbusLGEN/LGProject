//
//  ECRSwichView.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

@interface LGSegmentControlModel: NSObject
@property (copy,nonatomic) NSString *imageName;
@property (copy,nonatomic) NSString *title;
@end

#import <UIKit/UIKit.h>
@class LGSegmentControl;

/** 底部横条高度,在.m文件中修改 */
extern CGFloat elfHeight;

@protocol LGSegmentControlDelegate <NSObject>

/**
 点击回调

 @param sender view
 @param click 左起 0 开始
 */
- (void)segmentControl:(LGSegmentControl *)sender didClick:(NSInteger)click;

@end

@interface LGSegmentControl : UIView

//- (instancetype)initWithFrame:(CGRect)frame models:(NSArray<LGSegmentControlModel *> *)models;

/** 图片与纯文字切换,YES = 图片样式, NO = 纯文字切换, 默认为NO */
@property (assign,nonatomic) BOOL pictureStyle;

@property (weak,nonatomic) id<LGSegmentControlDelegate> delegate;


@end
