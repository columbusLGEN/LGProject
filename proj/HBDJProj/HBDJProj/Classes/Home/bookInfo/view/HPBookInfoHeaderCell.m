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


@end

@implementation HPBookInfoHeaderCell

@synthesize model = _model;

- (void)setModel:(HPBookInfoModel *)model{
    _model = model;
    
    [_bookCover sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:DJPlaceholderImage];
    [_fuzzyBg sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:DJPlaceholderImage];
    _bookName.text = model.bookName;
    _author.text = [NSString stringWithFormat:@"作者：%@",model.author];
    _press.text = [NSString stringWithFormat:@"出版社：%@",model.press];
    
    _pressTime.text = model.testPressTime;
    _readProgress.text = model.testProgress;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
//    NSLog(@"_fuzzyBg.frame: %@",NSStringFromCGRect(_fuzzyBg.frame));
    UIVisualEffectView *effectView = [LGGaussManager gaussViewWithFrame:_fuzzyBg.frame style:UIBlurEffectStyleDark];
    [self.contentView addSubview:effectView];
    [self.contentView sendSubviewToBack:effectView];
    [self.contentView sendSubviewToBack:_fuzzyBg];
}

@end
