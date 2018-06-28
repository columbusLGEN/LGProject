//
//  DJNotOpenViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJNotOpenViewController.h"

@interface DJNotOpenViewController ()
@property (weak,nonatomic) UIImageView *icon;
@property (weak,nonatomic) UILabel *text;

@end

@implementation DJNotOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *icon = UIImageView.new;
    [icon setImage:[UIImage imageNamed:@"dj_nor_open_item"]];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:icon];
    _icon = icon;
    
    UILabel *text = UILabel.new;
    [self.view addSubview:text];
    text.text = @"该功能暂未开放，敬请期待";
    text.font = [UIFont systemFontOfSize:17];
    text.textColor = UIColor.EDJGrayscale_33;
    _text = text;
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-80);
    }];
    
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom).offset(80);
        make.centerX.equalTo(icon.mas_centerX);
    }];
    
}

- (void)setNavLeftBackItem{
    if (_showBackItem) {
        [super setNavLeftBackItem];
    }
}


@end
