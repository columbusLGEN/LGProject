//
//  ECRNetErrorView.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/12/29.
//  Copyright © 2017年 retech. All rights reserved.
//

#define LGNoData LOCALIZATION(@"网络竟然崩溃了")

#import "ECRNetErrorView.h"

@interface ECRNetErrorView ()
/** mention word */
@property (copy,nonatomic) NSString *mentionWord;
/** sub mention word */
@property (copy,nonatomic) NSString *mentionWord_sub;
/** mention image */
@property (strong,nonatomic) UIImage *mentionImage;
/** mention image view */
@property (strong,nonatomic) UIImageView *mentionImageView;
/** Label for displaying mention word */
@property (strong,nonatomic) UILabel *mwLabel;
/** sub label */
@property (strong,nonatomic) UILabel *mwLabel_sub;
/** reload button */
@property (strong,nonatomic) UIButton *reloadButton;

@end

@implementation ECRNetErrorView

- (void)setMentionType:(ECRNetErrorViewMention)mentionType{
    _mentionType = mentionType;
    switch (mentionType) {
        case ECRNetErrorViewMentionNoData:{
            self.mentionWord = LGNoData;
//            self.metionImage = [UIImage imageNamed:<#(nonnull NSString *)#>]
        }
            break;
        default:{
            
        }
            break;
    }
}
#pragma mark - setter
- (void)setMentionImage:(UIImage *)mentionImage{
    _mentionImage = mentionImage;
    self.mentionImageView.image = mentionImage;
}
- (void)setMentionWord:(NSString *)mentionWord{
    _mentionWord = mentionWord;
    self.mwLabel.text = mentionWord;
}
#pragma mark - getter
- (NSString *)mentionWord_sub{
    return LOCALIZATION(@"别紧张,试试看刷新页面~");
}

- (void)setupUI{
    [self addSubview:self.mentionImageView];
    [self addSubview:self.mwLabel];
    [self addSubview:self.mwLabel_sub];
    [self addSubview:self.reloadButton];
    [self.mentionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.mwLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.mwLabel_sub mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
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

@end
