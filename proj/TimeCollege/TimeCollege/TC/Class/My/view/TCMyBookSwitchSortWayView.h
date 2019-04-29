//
//  TCMyBookSwitchSortWayView.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/17.
//  Copyright © 2019 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TCMyBookSortWay) {
    TCMyBookSortWayAdd = 1,/// 最近加入
    TCMyBookSortWayRead/// 最近阅读
};

@interface TCMyBookSwitchSortWayView : UIView
@property (weak, nonatomic) IBOutlet UIButton *close;
@property (weak, nonatomic) IBOutlet UIButton *addRecently;
@property (weak, nonatomic) IBOutlet UIButton *readRecently;

@property (assign,nonatomic) TCMyBookSortWay sortWay;

+ (instancetype)switchSortwayView;
@end

NS_ASSUME_NONNULL_END
