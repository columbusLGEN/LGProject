
//  UCMessageVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UClassMessageVC.h"
#import "UserClassVC.h"

@interface UClassMessageVC () <UITextViewDelegate>

@property (strong, nonatomic) UITextView *txtDescribe;
@property (strong, nonatomic) UILabel *lblPlaceHolder;   // 用 label 仿制 placeHolder
@property (strong, nonatomic) UILabel *lblMessageLength; // 消息长度

@end

@implementation UClassMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configMessageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"站内信");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LOCALIZATION(@"发送") style:UIBarButtonItemStyleDone target:self action:@selector(submitMessage)];
}

- (void)configMessageView
{
    _txtDescribe = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, Screen_Width - 20 * 2, 200)];
    _txtDescribe.textColor = [UIColor cm_blackColor_333333_1];
    _txtDescribe.font = [UIFont systemFontOfSize:cFontSize_14];
    _txtDescribe.delegate = self;
    
    _txtDescribe.layer.borderColor = [UIColor cm_blackColor_333333_1].CGColor;
    _txtDescribe.layer.borderWidth = .5f;
    
    _lblPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(26, 26, 100, 20)];
    _lblPlaceHolder.textColor = [UIColor cm_lineColor_D9D7D7_1];
    _lblPlaceHolder.font = [UIFont systemFontOfSize:cFontSize_14];
    _lblPlaceHolder.text = LOCALIZATION(@"请输入信息内容");
    
    _lblMessageLength = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width - 100, _txtDescribe.y + _txtDescribe.height + 5, 80, 20)];
    _lblMessageLength.textColor = [UIColor cm_blackColor_666666_1];
    _lblMessageLength.textAlignment = NSTextAlignmentRight;
    _lblMessageLength.font = [UIFont systemFontOfSize:cFontSize_14];
    _lblMessageLength.text = [NSString stringWithFormat:@"%ld/%ld", _txtDescribe.text.charLength, cMaxMessageLength];
    
    [self.view addSubview:_txtDescribe];
    [self.view addSubview:_lblPlaceHolder];
    [self.view addSubview:_lblMessageLength];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    _lblPlaceHolder.hidden = textView.text.length > 0;
    _lblMessageLength.text = [NSString stringWithFormat:@"%ld/%ld", _txtDescribe.text.charLength, cMaxMessageLength];
}

#pragma mark - 发送站内信
- (void)submitMessage
{
    if ([[_txtDescribe.text trim] empty]) {
        [self presentFailureTips:LOCALIZATION(@"请输入信息内容")];
        return;
    }
    if (_txtDescribe.text.charLength > cMaxMessageLength) {
        [self presentFailureTips:[NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"消息"),LOCALIZATION(@"字符长度为"), cMaxMessageLength]];
        return;
    }
    // 检查 emoji
    if ([NSString stringContainsEmoji:_txtDescribe.text]) {
        [self presentFailureTips:LOCALIZATION(@"不能输入emoji表情")];
        return;
    }
    
    NSString *userIds = [NSString string];
    for (NSInteger i = 0; i < _arrUsers.count; i ++) {
        UserModel *user = _arrUsers[i];
        userIds = [userIds stringByAppendingString:[NSString stringWithFormat:@"%ld,", user.userId]];
    }
    userIds = [userIds substringToIndex:userIds.length - 1];
    [self showWaitTips];
    WeakSelf(self)
    [[ClassRequest sharedInstance] sendMessageWithType:@"" name:[UserRequest sharedInstance].user.name message:self.txtDescribe.text studentId:userIds completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            [self presentSuccessTips:LOCALIZATION(@"发送成功")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self popToViewControllerWithController:[UserClassVC class] completionBlock:^{
                    
                }];
            });
        }
    }];
}


@end
