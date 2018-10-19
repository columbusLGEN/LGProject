//
//  HPBookInfoHeaderCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPBookInfoHeaderCell.h"
#import "HPBookInfoModel.h"
#import "LGGaussManager.h"

@interface HPBookInfoHeaderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *fuzzyBg;
@property (weak, nonatomic) IBOutlet UIImageView *bookCover;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *press;
@property (weak, nonatomic) IBOutlet UILabel *pressTime;
@property (weak, nonatomic) IBOutlet UILabel *readProgress;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverWidth;

@end

@implementation HPBookInfoHeaderCell

//@synthesize model = _model;

+ (instancetype)bookInInfoHeaderCell{
    return [[[NSBundle mainBundle] loadNibNamed:bookinfoHeaderCell owner:nil options:nil] lastObject];
}

- (void)setModel:(HPBookInfoModel *)model{
    _model = model;
    
    [_bookCover sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:DJPlaceholderImage];
    [_fuzzyBg sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:DJPlaceholderImage];
    _bookName.text = model.bookName;
    _author.text = [NSString stringWithFormat:@"作者：%@",model.author];
    _press.text = [NSString stringWithFormat:@"出版社：%@",model.press];
    
    _pressTime.text = model.testPressTime;
    _readProgress.text = model.testProgress;
    
//    _coverHeight.constant = (160 * model.cellHeight) / 233;
//    NSLog(@"model.cellHeight: %f",model.cellHeight);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    
    UIVisualEffectView *effectView = [LGGaussManager gaussViewWithFrame:CGRectZero style:UIBlurEffectStyleDark];
    [self.contentView addSubview:effectView];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_fuzzyBg);
    }];
    [self.contentView sendSubviewToBack:effectView];
    [self.contentView sendSubviewToBack:_fuzzyBg];

    _coverWidth.constant = (125 * kScreenWidth) / plusScreenWidth;
//    _coverHeight.constant = (222 * kScreenHeight) / plusScreenHeight;
    _coverHeight.constant = _coverWidth.constant * 1.4;
    
    if ([LGDevice isiPad]) {
//        _coverHeight.constant = 125 * 1.4;
    }
}

@end
