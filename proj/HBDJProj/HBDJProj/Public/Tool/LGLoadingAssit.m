//
//  LGLoadingAssit.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGLoadingAssit.h"

@interface LGLoadingAssit ()
@property (strong,nonatomic) MBProgressHUD *loadingHUD;

//@property (weak,nonatomic) MBProgressHUD *normalHUD;

@end

@implementation LGLoadingAssit

- (void)normalShowHUDTo:(UIView *)view HUDBlock:(void (^)(MBProgressHUD *))block{
    MBProgressHUD *normalHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    normalHUD.backgroundColor = [UIColor clearColor];
    normalHUD.mode = MBProgressHUDModeIndeterminate;
    [normalHUD showAnimated:YES];
    if (block) block(normalHUD);
//    _normalHUD = normalHUD;
}

- (void)homeAddLoadingViewTo:(UIView *)view{
    self.loadingHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.loadingHUD.backgroundColor = [UIColor clearColor];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.loadingHUD.backgroundColor = [UIColor whiteColor];
    });
    if (!_loadingHUD) {
        [view addSubview:self.loadingHUD];
    }else{
        [self.loadingHUD showAnimated:YES];
    }
    self.loadingHUD.mode = MBProgressHUDModeIndeterminate;
}
- (void)homeRemoveLoadingView{
    [self.loadingHUD hideAnimated:YES];
}
+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

@end
