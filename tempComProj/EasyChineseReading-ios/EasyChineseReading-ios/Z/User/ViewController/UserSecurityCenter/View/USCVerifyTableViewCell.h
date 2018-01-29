//
//  USCVerifyTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USCVerifyTableViewCell;

@protocol USCVerifyTableViewCellDelegate <NSObject>

- (void)sendVerifyCode;

@end

@interface USCVerifyTableViewCell : ECRBaseTableViewCell

@property (weak, nonatomic) id<USCVerifyTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *txtfVerity;
@property (weak, nonatomic) IBOutlet UIButton *btnSendVerify;

@end
