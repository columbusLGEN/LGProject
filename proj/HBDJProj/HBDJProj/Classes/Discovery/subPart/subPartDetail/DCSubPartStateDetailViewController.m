//
//  DCSubPartStateDetailViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateDetailViewController.h"
#import "LGThreeRightButtonView.h"

@interface DCSubPartStateDetailViewController ()
@property (strong,nonatomic) LGThreeRightButtonView *bottom;

@end

@implementation DCSubPartStateDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    
    CGFloat bottomHeight = 50;
    if ([LGDevice isiPhoneX]) {
        bottomHeight = 70;
    }
    [self.view addSubview:self.bottom];
    [self.bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bottomHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
    /// 注册键盘相关通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
}

#pragma mark - notifications
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect frameBegin = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect frameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    /// TODO: 为什么键盘的起始frame 异常？
    
    NSLog(@"frameBegin -- %@ ",NSStringFromCGRect(frameBegin));
//    NSLog(@"frameEnd -- %@",NSStringFromCGRect(frameEnd));
    CGFloat offsetY = frameBegin.origin.y - frameEnd.origin.y;
    NSLog(@"willchangeframe.y -- %f",offsetY);
}
- (void)keyboardDidChangeFrame:(NSNotification *)notification{
//    NSDictionary *userInfo = notification.userInfo;
//    CGRect frameBegin = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    CGRect frameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSLog(@"frameBegin -- %@ ",NSStringFromCGRect(frameBegin));
//    NSLog(@"frameEnd -- %@",NSStringFromCGRect(frameEnd));
//    CGFloat offsetY = frameEnd.origin.y - frameBegin.origin.y;
//    NSLog(@"didchangeframe.y -- %f",offsetY);
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (LGThreeRightButtonView *)bottom{
    if (!_bottom) {
        _bottom = [LGThreeRightButtonView new];
        _bottom.bothSidesClose = YES;
        [_bottom setBtnConfigs:@[@{TRConfigTitleKey:@"99+",
                                        TRConfigImgNameKey:@"dc_like_normal",
                                        TRConfigSelectedImgNameKey:@"dc_like_selected",
                                        TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                        TRConfigTitleColorSelectedKey:[UIColor EDJColor_6CBEFC]
                                        },
                                      @{TRConfigTitleKey:@"99+",
                                        TRConfigImgNameKey:@"uc_icon_shouc_gray",
                                        TRConfigSelectedImgNameKey:@"uc_icon_shouc_yellow",
                                        TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                        TRConfigTitleColorSelectedKey:[UIColor EDJColor_FDBF2D]
                                        },
                                      @{TRConfigTitleKey:@"99+",
                                        TRConfigImgNameKey:@"dc_discuss_normal",
                                        TRConfigSelectedImgNameKey:@"dc_discuss_selected",
                                        TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                        TRConfigTitleColorSelectedKey:[UIColor EDJColor_CEB0E7]
                                        }]];
    }
    return _bottom;
}

@end
