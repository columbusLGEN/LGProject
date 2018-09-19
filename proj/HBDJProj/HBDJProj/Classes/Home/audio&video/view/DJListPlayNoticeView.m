//
//  DJListPlayNoticeView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/19.
//  Copyright © 2018 Lee. All rights reserved.
//

#import "DJListPlayNoticeView.h"

@implementation DJListPlayNoticeView

- (void)showNoticeWithView:(UIView *)view complete:(void(^)(void))complete{
    [view addSubview:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        if (complete) complete();
    });
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:frame.size.height * 0.5];
        UILabel *label = UILabel.new;
        label.text = @"列表播放";
        label.textColor = UIColor.whiteColor;
        label.font = [UIFont systemFontOfSize:15];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}

@end
