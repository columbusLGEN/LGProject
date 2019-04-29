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

@property (strong,nonatomic) NSString *navTitle;
@property (strong,nonatomic) UIColor *navTitleColor;
@property (strong,nonatomic) NSString *navLeftImgName;

- (void)lg_dismissViewController;
- (void)setNavLeftBackItem;

@end
