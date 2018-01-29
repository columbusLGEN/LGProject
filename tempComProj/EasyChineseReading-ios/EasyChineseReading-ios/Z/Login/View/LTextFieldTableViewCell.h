//
//  LTextFieldTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTextFieldTableViewCell;

@protocol LTextFieldTableViewCellDelegate <NSObject>
/** 选择国家 */
- (void)selectedCountry;
/** 选择学校类型 */
- (void)selectedSchoolType;

@end

@interface LTextFieldTableViewCell : ECRBaseTableViewCell

@property (weak, nonatomic) id<LTextFieldTableViewCellDelegate> delegate;
/* 是否能选择 */
@property (assign, nonatomic) BOOL canSelected;

@property (weak, nonatomic) IBOutlet UITextField *txtfContent;
/** 取消所有第一响应者 */
- (void)resignAllFirstResponder;

@end
