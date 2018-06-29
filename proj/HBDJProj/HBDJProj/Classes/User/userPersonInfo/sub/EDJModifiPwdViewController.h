//
//  EDJModifiPwdViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 找回密码 & 重置密码 公共控制器

typedef NS_ENUM(NSUInteger, CodeOperationType) {
    CodeOperationTypeSendVerCode,/// 找回密码页面
    CodeOperationTypeConfirmPwd,/// 重置密码页面
};

#import "LGBaseViewController.h"

@interface EDJModifiPwdViewController : LGBaseViewController

@property (assign,nonatomic) CodeOperationType coType;
/** coType为 confirmPwd时，该值由上一个页面传入 */
@property (strong,nonatomic) NSString *phone;

@end
