//
//  TCMyCollectionViewCell.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/16.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCMyCollectionViewCell.h"
#import "TCMyBookrackModel.h"
#import "BookDownloadProgressv.h"

/** 下载进度视图 边长 */
static CGFloat borderLength_pv = 50;

@interface TCMyCollectionViewCell ()
@property (strong, nonatomic) UILabel *bookName;
@property (strong, nonatomic) UIView *overView;

@end

@implementation TCMyCollectionViewCell

- (void)setModel:(TCMyBookrackModel *)model{
    _model = model;
    _bookName.text = @"黄梅戏";
    _progressv.model = model;
    if (model.ds != 3) {
        /// 只要没下载 就展示蒙层
        _overView.hidden = NO;
    }else{
        _overView.hidden = YES;
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.cover];
        [self.contentView addSubview:self.bookName];
        [self.contentView addSubview:self.overView];
        
        [self.cover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginTen);
            make.right.equalTo(self.contentView.mas_right).offset(-marginTen);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-50);
            make.top.equalTo(self.contentView.mas_top).offset(marginFive);
            
        }];
        [self.bookName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.cover);
            make.top.equalTo(self.cover.mas_bottom).offset(8);
        }];
        [self.overView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.cover);
        }];
        self.overView.hidden = YES;
        
        [self.overView addSubview:self.progressv];
        [self.progressv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(borderLength_pv);
            make.centerX.centerY.equalTo(self.overView);
        }];
        
    }
    return self;
}

- (UIImageView *)cover{
    if (!_cover) {
        _cover = UIImageView.new;
        _cover.image = [UIImage imageNamed:@"AtestBookCover"];
        _cover.contentMode = UIViewContentModeScaleAspectFit;
        _cover.clipsToBounds = YES;
    }
    return _cover;
}
- (UILabel *)bookName{
    if (!_bookName) {
        _bookName = UILabel.new;
        _bookName.font = [UIFont systemFontOfSize:15];
        _bookName.numberOfLines = 2;
        _bookName.textColor = UIColor.blackColor;
    }
    return _bookName;
}
- (UIView *)overView{
    if (!_overView) {
        _overView = UIView.new;
        _overView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//        _overView.alpha = 0.5;
    }
    return _overView;
}
- (BookDownloadProgressv *)progressv{
    if (!_progressv) {
        _progressv = BookDownloadProgressv.new;
//        _progressv.backgroundColor = UIColor.whiteColor;
    }
    return _progressv;
}

@end
