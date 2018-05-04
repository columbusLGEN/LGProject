//
//  OLVoteDetailFooterView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLVoteDetailFooterView.h"

@interface OLVoteDetailFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *commit;


@end

@implementation OLVoteDetailFooterView

- (IBAction)commit:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voteFooterCommit:)]) {
        [self.delegate voteFooterCommit:self];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_commit cutBorderWithBorderWidth:0 borderColor:0 cornerRadius:_commit.height / 2];
}

- (void)setupUI{
    [_commit setBackgroundColor:[UIColor EDJMainColor]];
    [_commit setTitle:@"提交" forState:UIControlStateNormal];
    [_commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}
+ (instancetype)footerForVoteDetail{
    return [[[NSBundle mainBundle] loadNibNamed:@"OLVoteDetailFooterView" owner:nil options:nil] lastObject];
}

@end
