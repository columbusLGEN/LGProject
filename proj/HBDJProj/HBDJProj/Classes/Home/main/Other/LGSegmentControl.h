//
//  ECRSwichView.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LGSegmentControl,LGSegmentControlModel;

@protocol LGSegmentControlDelegate <NSObject>

/**
 点击回调
 
 @param sender view
 @param click 左起 0 开始
 */
- (void)segmentControl:(LGSegmentControl *)sender didClick:(NSInteger)click;

@end

@interface LGSegmentControl : UIView

- (instancetype)initWithFrame:(CGRect)frame models:(NSArray<LGSegmentControlModel *> *)models;

@property (weak,nonatomic) id<LGSegmentControlDelegate> delegate;
@property (strong,nonatomic,readonly) NSArray<LGSegmentControlModel *> *models;

@end

@interface LGSegmentControlModel: NSObject
@property (copy,nonatomic) NSString *imageName;
@property (copy,nonatomic) NSString *title;

@end
