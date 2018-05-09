//
//  DCSubPartBottomView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartBottomView.h"

@interface DCSubPartBottomView ()
@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UIButton *like;
@property (weak, nonatomic) IBOutlet UIButton *collect;


@end

@implementation DCSubPartBottomView

- (IBAction)click:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
    SubPartyBottomAction action;
    if (sender.tag == 1) {
        /// 收藏
        action = SubPartyBottomActionCollect;
    }else{
        /// 点赞
        action = SubPartyBottomActionLike;
    }
    if ([self.delegate respondsToSelector:@selector(sbBottomActionClick:action:)]) {
        [self.delegate sbBottomActionClick:self action:action];
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    UIView *leftRect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    leftRect.backgroundColor = [UIColor clearColor];
    self.txtField.leftView = leftRect;
    self.txtField.leftViewMode = UITextFieldViewModeAlways;
}

+ (instancetype)sbBottom{
    return [[[NSBundle mainBundle] loadNibNamed:@"DCSubPartBottomView" owner:nil options:nil] lastObject];
}

@end
