//
//  TCErrorViewController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/9.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCErrorViewController.h"

@interface TCErrorViewController ()
@property (weak,nonatomic) UIImageView *imgv;
@property (strong,nonatomic) NSString *imgName;
/** 刷新按钮 */
@property (weak,nonatomic) UIButton *button;
/** 是否展示 ”刷新按钮“ YES: 展示 */
@property (assign,nonatomic) BOOL buttonShow;
@property (strong,nonatomic) NSString *noticeText;

@end

@implementation TCErrorViewController

/** type 0: 网络异常;1: 没有搜到结果 */
+ (instancetype)errorvcWithType:(NSInteger)type delegate:(id<TCErrorViewControllerDelegate>)delegate noticeText:(NSString *)noticeText{
    TCErrorViewController *vc = TCErrorViewController.new;
    return [vc errorvcWithType:type delegate:delegate noticeText:noticeText];
}
- (instancetype)errorvcWithType:(NSInteger)type delegate:(id<TCErrorViewControllerDelegate>)delegate noticeText:(NSString *)noticeText{
    self.imgName = [self imgNameWithType:type];
    self.buttonShow = (type == 0);
    self.noticeText = noticeText;
    self.delegate = delegate;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

#pragma mark - target
- (void)errorvcRequest{
    /// TODO: target 不响应？？？
    if ([self.delegate respondsToSelector:@selector(errorvcRealodData:)]) {
        [self.delegate errorvcRealodData:self];
    }
}

- (void)configUI{
    /// image
    UIImageView *imgv = UIImageView.new;
    imgv.contentMode = UIViewContentModeScaleAspectFit;
    imgv.clipsToBounds = YES;
    [self.view addSubview:imgv];
    imgv.image = [UIImage imageNamed:self.imgName];
    _imgv = imgv;
    
    /// label for notice
    UILabel *notice = UILabel.new;
    notice.text = self.noticeText;
    notice.textAlignment = NSTextAlignmentCenter;
    notice.textColor = UIColor.blackColor;
    notice.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:notice];
    
    /// button for click to reload data
    UIButton *button = UIButton.new;
    [self.view addSubview:button];
    [button setTitle:@"刷新" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [button addTarget:self action:@selector(errorvcRequest) forControlEvents:UIControlEventTouchUpInside];
    _button = button;
    
    NSLog(@"button.alltargets: %@",button.allTargets);
    
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-120);
        make.width.height.mas_equalTo(180);
    }];
    [notice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgv.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(notice.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(50);
    }];
    
    button.hidden = !self.buttonShow;
    
}

- (NSString *)imgNameWithType:(NSInteger)type{
    switch (type) {
        case 0:{
            return @"img_empty_network";
        }
            break;
        case 1:{
            return @"img_empty_search";
        }
            break;
            default:
            return @"img_empty_network";
    }
}

@end
