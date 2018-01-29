//
//  ECRNetErrorView.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/12/29.
//  Copyright © 2017年 retech. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 提示类型

 - ECRNetErrorViewMentionNoData: 无数据通用类型
 */
typedef NS_ENUM(NSUInteger, ECRNetErrorViewMention) {
    ECRNetErrorViewMentionNoData
};

@protocol ECRNetErrorViewDelegate;

@interface ECRNetErrorView : UIView
/** mention type */
@property (assign,nonatomic) ECRNetErrorViewMention mentionType;
/** ECRNetErrorViewDelegate */
@property (weak,nonatomic) id<ECRNetErrorViewDelegate> delegate;
@end

@protocol ECRNetErrorViewDelegate <NSObject>
- (void)netErrorViewReloadData:(ECRNetErrorView *)neview;
@end
