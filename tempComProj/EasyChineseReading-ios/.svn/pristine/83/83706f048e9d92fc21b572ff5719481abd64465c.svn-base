//
//  ZPickDateView.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/6.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZPickDateView;
@protocol ZPickDateViewDelegate <NSObject>

@optional
- (void)datePickerView:(ZPickDateView *)picker selectedDate:(NSDate*)aValue;
- (void)datePickerViewCancel:(ZPickDateView *)picker;

@end

@interface ZPickDateView : ECRBaseView

@property (weak, nonatomic) id<ZPickDateViewDelegate> delegete;
@property (assign, nonatomic ,readonly) BOOL showing;
@property (strong, nonatomic ,readonly) NSDate *date;
@property (strong, nonatomic, readonly) NSDate *maxDate; // 最大时间
@property (strong ,nonatomic, readonly) NSDate *minDate; // 最小时间
- (instancetype)initWithFrame:(CGRect)frame getAfterDate:(BOOL)getAfterDate selected:(NSDate *)selectedDate;

- (instancetype)initWithFrame:(CGRect)frame getAfterDate:(BOOL)getAfterDate selected:(NSDate *)selectedDate minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate;

- (void)show;
- (void)hidden;

@end
