//
//  ZPickView.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/6.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZPickView;

@protocol ZPickViewDelegate<NSObject>

- (void)ZPickerView:(ZPickView *)picker makeSureIndex:(NSInteger)index;
- (void)ZPickerViewCancel:(ZPickView *)picker;

@end

@interface ZPickView : ECRBaseView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView   *viewBackground;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnSure;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;

@property (weak, nonatomic) id<ZPickViewDelegate> delegates;
@property (assign, nonatomic ,readonly) BOOL showing;

@property (assign ,nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSArray *arrData;

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource selected:(NSInteger)selected;

- (void)show;
- (void)hidden;

@end
