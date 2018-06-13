//
//  HPNetworkFailureView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPNetworkFailureView.h"

@interface HPNetworkFailureView ()


@end

@implementation HPNetworkFailureView

- (IBAction)click:(id)sender {
    if ([self.delegate respondsToSelector:@selector(djemptyViewClick)]) {
        [self.delegate djemptyViewClick];
    }
}

+ (instancetype)DJEmptyView{
    return [[[NSBundle mainBundle] loadNibNamed:@"HPNetworkFailureView" owner:nil options:nil] lastObject];
}

- (void)setupUI{
    
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}

@end
