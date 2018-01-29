//
//  ECRNetLoadingView.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/12/22.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRNetLoadingView.h"

@interface ECRNetLoadingView ()
@property (strong,nonatomic) MBProgressHUD *loadingHUD;//

@end

@implementation ECRNetLoadingView

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.loadingHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loadingHUD hideAnimated:YES];
    });
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}
- (MBProgressHUD *)loadingHUD{
    if (_loadingHUD == nil) {
        _loadingHUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
        _loadingHUD.mode = MBProgressHUDModeIndeterminate;
    }
    return _loadingHUD;
}

@end
