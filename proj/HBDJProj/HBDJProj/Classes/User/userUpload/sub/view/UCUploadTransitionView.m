//
//  UCUploadTransitionView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCUploadTransitionView.h"

@interface UCUploadTransitionView ()
@property (weak, nonatomic) IBOutlet UIView *containerView;


@end

@implementation UCUploadTransitionView

- (IBAction)uploadAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(utView:action:)]) {
        [self.delegate utView:self action:sender.tag];
    }
}

- (IBAction)close:(id)sender {
    if ([self.delegate respondsToSelector:@selector(utViewClose:)]) {
        [self.delegate utViewClose:self];
    }
}

+ (instancetype)uploadTransitionView{
    return [[[NSBundle mainBundle] loadNibNamed:@"UCUploadTransitionView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0];
    self.containerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
}

@end
