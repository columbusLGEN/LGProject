//
//  ShareVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/31.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ShareVC.h"

@interface ShareVC () <UITextViewDelegate>

//  蒙版及分享 view

@property (weak, nonatomic) IBOutlet UIView *viewShareBook;         // 分享
@property (weak, nonatomic) IBOutlet UIView *viewShareBookLine;     // 分享底部的线
@property (weak, nonatomic) IBOutlet UIView *viewShareBookScore;    // 评星

@property (weak, nonatomic) IBOutlet UILabel *lblShareBookName;     // 书名
@property (weak, nonatomic) IBOutlet UILabel *lblShareBookAuthor;   // 作者
@property (weak, nonatomic) IBOutlet UILabel *lblShareBookPrice;    // 价格
@property (weak, nonatomic) IBOutlet UILabel *lblShareBookCancel;   // 取消
@property (weak, nonatomic) IBOutlet UILabel *lblShareBookSend;     // 发送

@property (weak, nonatomic) IBOutlet UIImageView *imgShareBook;     // 封面
@property (weak, nonatomic) IBOutlet UITextView  *txtvShareBookContent; // 分享的说明

// 底部 view

@property (weak, nonatomic) IBOutlet UIView *viewBottom;            // 分享底部按键

@property (weak, nonatomic) IBOutlet UIView *viewBottomLine;        // 分享底部的线
@property (weak, nonatomic) IBOutlet UIView *viewBottomLeft;        // 左边的 view(当做按钮)
@property (weak, nonatomic) IBOutlet UIView *viewBottomRight;       // 右边的 view
@property (weak, nonatomic) IBOutlet UIView *viewLine;

@property (weak, nonatomic) IBOutlet UIImageView *imgBottomLeft;    // 左边的图片
@property (weak, nonatomic) IBOutlet UIImageView *imgBottomRight;   // 右边的图片
@property (weak, nonatomic) IBOutlet UIImageView *imgVirtualCurrency;

@property (weak, nonatomic) IBOutlet UILabel *lblBottomLeft;        // 左边文字描述
@property (weak, nonatomic) IBOutlet UILabel *lblBottomRight;       // 右边文字描述
@property (weak, nonatomic) IBOutlet UILabel *lblTextLength;        // 文本长度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYBackViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthBackViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightBackViewConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightBookCoverConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthBookCoverConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBookCoverConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBookCoverConstraint;



@end

@implementation ShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configShareBookView];
    //    [self configBottomView];
    [self configData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    _lblBottomLeft.text      = LOCALIZATION(@"分享给好友");
    _lblBottomRight.text     = LOCALIZATION(@"分享到好友动态");
    _lblShareBookCancel.text = LOCALIZATION(@"取消");
    _lblShareBookSend.text   = LOCALIZATION(@"发送");
}

- (void)configShareBookView
{
    _imgVirtualCurrency.image = [UIImage imageNamed:@"icon_virtual_currency"];
    self.view.backgroundColor           = [UIColor cm_blackColor_000000_2F];
    _viewShareBook.backgroundColor      = [UIColor whiteColor];
    _viewLine.backgroundColor           = [UIColor cm_lineColor_D9D7D7_1];
    _lblShareBookSend.backgroundColor   = [UIColor cm_mainColor];
    _lblShareBookCancel.backgroundColor = [UIColor whiteColor];

    _lblShareBookName.textColor   = [UIColor cm_blackColor_333333_1];
    _lblShareBookAuthor.textColor = [UIColor cm_blackColor_666666_1];
    _lblShareBookPrice.textColor  = [UIColor cm_orangeColor_FF5910_1];
    _lblShareBookCancel.textColor = [UIColor cm_mainColor];
    _lblShareBookSend.textColor   = [UIColor whiteColor];

    _lblShareBookName.font   = [UIFont systemFontOfSize:cFontSize_18];
    _lblShareBookAuthor.font = [UIFont systemFontOfSize:cFontSize_14];
    _lblShareBookPrice.font  = [UIFont systemFontOfSize:cFontSize_16];
    _lblShareBookCancel.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblShareBookSend.font   = [UIFont systemFontOfSize:cFontSize_16];
    
    _lblTextLength.textColor = [UIColor cm_blackColor_666666_1];
    _lblTextLength.font      = [UIFont systemFontOfSize:cFontSize_14];
    _lblTextLength.text      = [NSString stringWithFormat:@"0/%ld", cMaxShareLength];

    _txtvShareBookContent.textColor = [UIColor cm_blackColor_333333_1];
    _txtvShareBookContent.font      = [UIFont systemFontOfSize:cFontSize_16];

    _txtvShareBookContent.layer.borderColor = [UIColor cm_lineColor_D9D7D7_1].CGColor;
    _txtvShareBookContent.layer.borderWidth = 1.f;
    _txtvShareBookContent.delegate = self;

    _lblShareBookSend.userInteractionEnabled   = YES;
    _lblShareBookCancel.userInteractionEnabled = YES;

    UITapGestureRecognizer *tapCancel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelShareBook)];
    UITapGestureRecognizer *tapSend   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendShareBook)];

    [_lblShareBookCancel addGestureRecognizer:tapCancel];
    [_lblShareBookSend   addGestureRecognizer:tapSend];
    _viewBottom.hidden = YES;
    
    [self updateShareConstraint];
}

- (void)updateShareConstraint
{
    _centerYBackViewConstraint.constant = isPad ? -110.f : -62.f;
    _widthBackViewConstraint.constant   = isPad ? 530.f : 300.f;
    _heightBackViewConstraint.constant  = isPad ? 460.f : 350.f;
    _heightBookCoverConstraint.constant = isPad ? 130.f : 130.f;
    _widthBookCoverConstraint.constant  = isPad ? 95.f : 95.f;
    _topBookCoverConstraint.constant    = isPad ? 30.f : 20.f;
    _leftBookCoverConstraint.constant   = isPad ? 35.f : 20.f;
}

- (void)configBottomView
{
    _viewBottom.backgroundColor     = [UIColor whiteColor];
    _viewBottomLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    
    _viewBottomLeft.backgroundColor  = [UIColor whiteColor];
    _viewBottomRight.backgroundColor = [UIColor whiteColor];
    
    _lblBottomLeft.textColor  = [UIColor cm_blackColor_333333_1];
    _lblBottomRight.textColor = [UIColor cm_blackColor_333333_1];
    
    _lblBottomLeft.font  = [UIFont systemFontOfSize:cFontSize_16];
    _lblBottomRight.font = [UIFont systemFontOfSize:cFontSize_16];
    
    _viewBottomLeft.userInteractionEnabled  = YES;
    _viewBottomRight.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapLView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareToFriend)];
    UITapGestureRecognizer *tapRView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareToDynamic)];
    
    [_viewBottomLeft  addGestureRecognizer:tapLView];
    [_viewBottomRight addGestureRecognizer:tapRView];
    _viewShareBook.hidden = _shareType = ENUM_ShareTypeDynamic;
}

#pragma mark - 配置数据

- (void)configData
{
    [_imgShareBook sd_setImageWithURL:[NSURL URLWithString:_book.iconUrl] placeholderImage:[UIImage imageNamed:@"img_book_placeholder"]];
    _lblShareBookName.text   = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? _book.bookName : _book.en_bookName;
    _lblShareBookAuthor.text = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"作者"), [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? _book.author : _book.en_author];

    _lblShareBookPrice.text = [NSString stringWithFormat:@"%.2f", _book.price];

    ZStarView *star = [[ZStarView alloc] initWithFrame:CGRectMake(0, 0, _viewShareBookScore.height*5, _viewShareBookScore.height) numberOfStar:5];
    star.canChange = NO;
    [_viewShareBookScore addSubview:star];

    [star setScore:_book.score withAnimation:NO];
}

#pragma mark - text view delegate

- (void)textViewDidChange:(UITextView *)textView
{
    _lblTextLength.text = [NSString stringWithFormat:@"%ld/%ld", textView.text.charLength, cMaxShareLength];
}

#pragma mark - 操作
/** 取消分享 */
- (void)cancelShareBook
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 分享图书 */
- (void)sendShareBook
{
    if (_txtvShareBookContent.text.charLength > cMaxShareLength) {
        [self presentFailureTips:[NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"分享"), LOCALIZATION(@"字符长度为"), cMaxShareLength]];
    }
    else {
        [self showWaitTips];
        WeakSelf(self)
        [[FriendRequest sharedInstance] shareBookWithBookId:_book.bookId shareTitle:_txtvShareBookContent.text completion:^(id object, ErrorModel *error) {
            StrongSelf(self)
            [self dismissTips];
            if (error) {
                [self presentFailureTips:error.message];
            }
            else {
                [self fk_postNotification:kNotificationShareBookToDynamicSuccess];
                [self presentSuccessTips:LOCALIZATION(@"分享成功")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }
        }];
    }
}

/** 分享给好友 */
- (void)shareToFriend
{
    _shareType = ENUM_ShareTypeDynamic;
    _viewShareBook.hidden = NO;
    _viewBottom.hidden = YES;
}

/** 分享到动态 */
- (void)shareToDynamic
{
    WeakSelf(self)
    [self dismissViewControllerAnimated:YES completion:^{
        weakself.shareToFriendWithBook(_book);
    }];
}

/** 点击空白 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_txtvShareBookContent resignFirstResponder];
}

@end
