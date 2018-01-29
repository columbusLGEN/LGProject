//
//  ECRSubjectView.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/23.
//  Copyright © 2017年 retech. All rights reserved.
//

//static CGFloat imgHeight = 240;

#import "ECRSubjectView.h"

@interface ECRSubjectView ()
// 如果顶部图片不滑动，用 img显示，否则使用tableview的header
@property (strong,nonatomic) UIImageView *img;//

@end

@implementation ECRSubjectView

- (void)setupUI{
//    [self addSubview:self.img];
    [self addSubview:self.tableView];
//    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top);
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.height.equalTo(@(imgHeight));
//        make.bottom.equalTo(self.tableView.mas_top);
//    }];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.bottom.equalTo(self.mas_bottom);
//    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-64);
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

- (UIImageView *)img{
    if (_img == nil) {
        _img = [[UIImageView alloc] init];
        [_img setImage:[UIImage imageNamed:@"bys_15"]];
        
    }
    return _img;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight =  UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
        _tableView.estimatedRowHeight = 150;//必须设置好预估值
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
