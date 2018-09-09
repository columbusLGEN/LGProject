//
//  LIGBaseViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LGBaseViewControllerPushWay) {
    LGBaseViewControllerPushWayPush,
    LGBaseViewControllerPushWayModal,
};

@interface LGBaseViewController : UIViewController

@property (assign,nonatomic) LGBaseViewControllerPushWay pushWay;
- (void)lg_dismissViewController;
- (void)setNavLeftBackItem;

/// 之后，将一下方法、属性封装到DJ基础控制器，从全局基类控制器中移除
/** 开始查看内容的时间点，用于计时之后想后台发送用户查看时间, 单位分钟*/
@property (strong,nonatomic) NSDate *startReadDate;
/// 部分需要调用用户增加积分接口的方法
- (void)IntegralGrade_addWithIntegralid:(DJUserAddScoreType)integralid;

@end
