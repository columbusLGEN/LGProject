//
//  EDJSearchTagHotCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJSearchTagHotCell.h"
#import "EDJSearchTagModel.h"

@interface EDJSearchTagHotCell ()
@property (weak, nonatomic) IBOutlet UIButton *tagButton;


@end

@implementation EDJSearchTagHotCell

- (void)setModel:(EDJSearchTagModel *)model{
    [super setModel:model];
    [_tagButton setTitle:model.name forState:UIControlStateNormal];
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.tagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.tagButton setBackgroundColor:[UIColor EDJMainColor]];
    _tagButton.userInteractionEnabled = NO;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.tagButton cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:self.tagButton.height * 0.5];
    
}

@end
