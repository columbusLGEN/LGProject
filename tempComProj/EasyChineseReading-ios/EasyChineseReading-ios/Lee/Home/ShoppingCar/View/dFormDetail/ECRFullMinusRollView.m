//
//  ECRFullMinusRollView.m
//  downloadStateDemo
//
//  Created by Peanut Lee on 2017/9/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ECRFullMinusRollView.h"
#import "ECRTopupFieldView.h"

//static CGFloat  spaceA       = 8;
//static NSString *colors      = @"333333";

@interface ECRFullMinusRollView ()

@end

@implementation ECRFullMinusRollView

- (void)textDependsLauguage{
    
}

- (void)setupUI{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top    .equalTo(self.mas_top);//.offset(spaceA);
        make.left   .equalTo(self.mas_left);
        make.right  .equalTo(self.mas_right);
        make.bottom .equalTo(self.mas_bottom);
    }];
    [self textDependsLauguage];
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
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end




