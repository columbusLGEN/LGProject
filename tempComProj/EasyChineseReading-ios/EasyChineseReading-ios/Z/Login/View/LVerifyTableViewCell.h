//
//  LVerifyTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LVerifyTableViewCell;

@protocol LVerifyTableViewCellDelegate <NSObject>

- (void)sendVerifyCode;

@end

@interface LVerifyTableViewCell : ECRBaseTableViewCell

@property (weak, nonatomic) id<LVerifyTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet ZTextField *txtfContent;
@property (weak, nonatomic) IBOutlet UIButton *sendVerify;

- (void)resignAllFirstResponder;

@end
