//
//  HPSearchHistoryView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPSearchHistoryView.h"

@interface HPSearchHistoryView ()

@property (weak,nonatomic) UIView *topContentv;
@property (weak,nonatomic) UIButton *searchRecord;


@end

@implementation HPSearchHistoryView

- (void)setRecords:(NSArray *)records{
    _records = records;
    
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIView *topContentv = [[UIView alloc] init];
        [self addSubview:topContentv];
        
        UIButton *searchRecord = [[UIButton alloc] init];
        searchRecord.titleLabel.font = [UIFont systemFontOfSize:14];
        searchRecord.userInteractionEnabled = NO;
        [searchRecord setTitle:@"搜索历史" forState:UIControlStateNormal];
        [searchRecord setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [topContentv addSubview:searchRecord];
        
//        UIButton *deleteRecord = [[UIButton alloc] init];
//        [deleteRecord setImage:[UIImage imageNamed:@"home_icon_remove"] forState:UIControlStateNormal];
//        [topContentv addSubview:deleteRecord];
        
        UIScrollView *scrollv = [[UIScrollView alloc] init];
        [self addSubview:scrollv];
        
        UIView *blueRect = UIView.new;
        blueRect.backgroundColor = UIColor.TCColor_mainColor;
        [topContentv addSubview:blueRect];
        
        [topContentv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.width.mas_equalTo(Screen_Width);
            make.height.mas_equalTo(50);
        }];
        
        [blueRect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topContentv.mas_centerY);
            make.left.equalTo(topContentv.mas_left).offset(marginFifteen);
            make.width.mas_equalTo(2);
            make.height.mas_equalTo(15);
        }];
        [searchRecord mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topContentv.mas_centerY);
            make.left.equalTo(blueRect.mas_left).offset(marginEight);
        }];
//        [deleteRecord mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(topContentv.mas_centerY);
//            make.right.equalTo(topContentv.mas_right).offset(-marginFifteen);
//        }];
        
        [scrollv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topContentv.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
        }];
        
        _topContentv = topContentv;
        _searchRecord = searchRecord;
//        _deleteRecord = deleteRecord;
        _scrollv = scrollv;
        
//        _scrollv.backgroundColor = UIColor.EDJGrayscale_A4;
    }
    return self;
}

@end
