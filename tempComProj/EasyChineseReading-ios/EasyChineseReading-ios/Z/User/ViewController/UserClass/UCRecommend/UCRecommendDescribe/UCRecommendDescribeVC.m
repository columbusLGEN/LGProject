//
//  UCRecommendDescribeVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/14.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRecommendDescribeVC.h"

#import "UCRecommendManageVC.h"

#import "ECRBookListModel.h"

@interface UCRecommendDescribeVC () <UITextViewDelegate>

@property (strong, nonatomic) UITextView *txtDescribe;    // 推荐的内容
@property (strong, nonatomic) UILabel *lblPlaceHolder;    // 用 label 仿制推荐描述上的 placeHolder
@property (strong, nonatomic) UILabel *lblDescribeLength; // 描述长度

@end

@implementation UCRecommendDescribeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTxtDescribeView];
}

#pragma mark -

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"推荐阅读");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LOCALIZATION(@"推荐") style:UIBarButtonItemStyleDone target:self action:@selector(submitRecommend)];
}

- (void)configTxtDescribeView
{
    _txtDescribe = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, Screen_Width - 20 * 2, 200)];
    _txtDescribe.textColor = [UIColor cm_blackColor_333333_1];
    _txtDescribe.font = [UIFont systemFontOfSize:14.f];
    _txtDescribe.delegate = self;
    
    _txtDescribe.layer.borderColor = [UIColor cm_blackColor_333333_1].CGColor;
    _txtDescribe.layer.borderWidth = .5f;
    
    _lblPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(26, 26, 100, 20)];
    _lblPlaceHolder.textColor = [UIColor cm_lineColor_D9D7D7_1];
    _lblPlaceHolder.font = [UIFont systemFontOfSize:14.f];
    _lblPlaceHolder.text = LOCALIZATION(@"请输入推荐描述");
    
    _lblDescribeLength = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width - 100, _txtDescribe.y + _txtDescribe.height + 5, 80, 20)];
    _lblDescribeLength.textColor = [UIColor cm_blackColor_666666_1];
    _lblDescribeLength.textAlignment = NSTextAlignmentRight;
    _lblDescribeLength.font = [UIFont systemFontOfSize:cFontSize_14];
    _lblDescribeLength.text = [NSString stringWithFormat:@"%ld/%ld", _txtDescribe.text.charLength, cMaxMessageLength];
    
    [self.view addSubview:_txtDescribe];
    [self.view addSubview:_lblPlaceHolder];
    [self.view addSubview:_lblDescribeLength];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    _lblPlaceHolder.hidden = textView.text.length > 0;
    _lblDescribeLength.text = [NSString stringWithFormat:@"%ld/%ld", _txtDescribe.text.charLength, cMaxMessageLength];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""])
        return YES;
    if (range.length + range.location > textView.text.charLength)
        return NO;
    NSUInteger newLength = [textView.text charLength] + [text length] - range.length;
    
    return newLength <= cMaxRecommendLength;
}

// 提交推荐阅读的内容
- (void)submitRecommend
{
    // 检查 emoji
    if ([NSString stringContainsEmoji:_txtDescribe.text]) {
        [self presentFailureTips:LOCALIZATION(@"不能输入emoji表情")];
        return;
    }
    // 检查字符超限
    if (_txtDescribe.text.charLength > cMaxRecommendLength) {
        [self presentFailureTips:[NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"推荐"),LOCALIZATION(@"字符长度为"), cMaxRecommendLength]];
        return;
    }
    NSString *strBookIds = @"";
    NSString *strUserIds = @"";
    // 将图书和选中的人数组组成的字符串, 用逗号分隔
    for (NSInteger i = 0; i < _arrBooks.count; i ++) {
        ECRBookListModel *book = _arrBooks[i];
        strBookIds = [strBookIds stringByAppendingString:[NSString stringWithFormat:@"%ld,", book.bookId]];
    }
    for (NSInteger i = 0; i < _arrUsers.count; i ++) {
        UserModel *user = _arrUsers[i];
        strUserIds = [strUserIds stringByAppendingString:[NSString stringWithFormat:@"%ld,", user.userId]];
    }
    // 去掉最后一个逗号
    strBookIds = [strBookIds substringToIndex:strBookIds.length - 1];
    strUserIds = [strUserIds substringToIndex:strUserIds.length - 1];
    [self showWaitTips];
    WeakSelf(self)
    [[ClassRequest sharedInstance] recommendBooksWithShareTitle:_txtDescribe.text bookIds:strBookIds studentIds:strUserIds type:1 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[UCRecommendManageVC class]]) {
                    [self fk_postNotification:kNotificationReloadRecommends];
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }
    }];
}

@end
