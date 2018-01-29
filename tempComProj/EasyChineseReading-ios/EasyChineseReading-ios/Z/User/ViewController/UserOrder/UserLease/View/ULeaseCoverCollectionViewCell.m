//
//  ULeaseCoverCollectionViewCell.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/28.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ULeaseCoverCollectionViewCell.h"

@interface ULeaseCoverCollectionViewCell()

@property (strong, nonatomic) UIImageView *imgLeaseCover; // 包月封面

@end

@implementation ULeaseCoverCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configCoverCell];
        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark - 配置界面

- (void)configCoverCell
{
    _imgLeaseCover = [UIImageView new];
    _imgLeaseCover.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_imgLeaseCover];
    
    [_imgLeaseCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top   .equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left  .equalTo(self.mas_left);
        make.right .equalTo(self.mas_right);
    }];
}

#pragma mark - 更新数据

- (void)dataDidChange
{
    SerialModel *serial = self.data;
    [_imgLeaseCover sd_setImageWithURL:[NSURL URLWithString:serial.serialUrl] placeholderImage:[UIImage imageNamed:@"img_book_placeholder"]];
}

@end
