//
//  DCSubPartStateDetailViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateDetailViewController.h"
#import "DCSubPartBottomView.h"

@interface DCSubPartStateDetailViewController ()<
DCSubPartBottomViewDelegate>
@property (weak,nonatomic) DCSubPartBottomView *bottom;

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
    /// bottom
    DCSubPartBottomView *sbBottom = [DCSubPartBottomView sbBottom];
    sbBottom.delegate = self;
    CGFloat sbbHeight = 60;
    BOOL isiPhoneX = ([LGDevice sharedInstance].currentDeviceType == LGDeviecType_iPhoneX);
    if (isiPhoneX) {
        sbbHeight = 90;
    }
    sbBottom.frame = CGRectMake(0, kScreenHeight - sbbHeight, kScreenWidth, sbbHeight);
    [self.view addSubview:sbBottom];
    _bottom = sbBottom;
    
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

#pragma mark - DCSubPartBottomViewDelegate
- (void)sbBottomActionClick:(DCSubPartBottomView *)sbBottom action:(SubPartyBottomAction)action{
    switch (action) {
        case SubPartyBottomActionLike:
            NSLog(@"点赞 -- ");
            break;
        case SubPartyBottomActionCollect:
            NSLog(@"收藏 -- ");
            break;

    }
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
